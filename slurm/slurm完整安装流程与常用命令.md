✅ 目标与约定
	•	机器与主机名：master、worker01、worker02（三台都要做）
	•	系统：Rocky 8/9 混用也可以（cgroup 说明见下）
	•	安装方式：源码安装到 /usr/local
	•	Slurm 运行账户：slurm:slurm
	•	目录位置（按你要求）
	•	状态/队列：StateSaveLocation=/home/slurm/spool/slurmctld
	•	计算节点本地缓存：SlurmdSpoolDir=/home/slurm/spool/slurmd
	•	日志：/home/slurm/log/...
	•	认证：MUNGE（同一把 key）

⸻

1. 准备：三台机统一主机名与 hosts

三台机都执行，保证 `hostname -s` 分别为：
```bash
hostnamectl set-hostname master     # 在 master
hostnamectl set-hostname worker01   # 在 worker01
hostnamectl set-hostname worker02   # 在 worker02
```
三台机 `/etc/hosts` 都写死内网 IP（自行替换为你的实际 IP）：

```bash
sudo vim /etc/hosts

写入:
192.168.124.5   master
192.168.124.19  worker01
192.168.124.18  worker02
```

⸻

1. 三台机都装依赖
```bash
sudo dnf install -y epel-release
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y \
  munge munge-libs munge-devel \
  readline-devel ncurses-devel \
  hwloc hwloc-devel \
  pam-devel systemd-devel \
  perl gcc gcc-c++ make \
  wget tar
```
Rocky8/9 都适用。若提示包名不同，按提示补齐。

⸻

2. 创建系统用户与目录（创建munge、slurm账户，统一 UID/GID）

强烈建议全集群统一 UID/GID，避免“Unexpected uid != Slurm uid”类错误。下面示例用 978/976；若被占用，挑一个全集群都空闲的数字。

在三台机依次执行：

# slurm 用户与组
```bash
sudo groupadd -g 976 slurm 2>/dev/null || true
id -u slurm &>/dev/null || sudo useradd -m -u 978 -g 976 -s /bin/bash slurm
```

# munge 用户与组（通常包会自带，如无则创建）
```bash
sudo groupadd -r munge 2>/dev/null || true
id -u munge &>/dev/null || sudo useradd -r -g munge -s /sbin/nologin munge
```

# 你自定义的目录（重要）
```bash
sudo mkdir -p /home/slurm/spool/slurmctld \
              /home/slurm/spool/slurmd \
              /home/slurm/log
sudo chown -R slurm:slurm /home/slurm
sudo chmod -R 755 /home/slurm
```
后续 SELinux 如是 Enforcing，记得 sudo restorecon -Rv /home/slurm。

⸻

3. 配置 MUNGE（同一把密钥）

在 master：
```bash
sudo /usr/sbin/create-munge-key -f
sudo chown munge:munge /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key
sudo systemctl enable --now munge
```
把 key 分发到 worker01/worker02：
```bash
master:
sudo scp /etc/munge/munge.key worker01:/tmp/
sudo scp /etc/munge/munge.key worker02:/tmp/
worker01/worker02:
sudo mkdir -p /etc/munge
sudo mv /tmp/munge.key /etc/munge/munge.key
sudo chown munge:munge /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key
sudo systemctl enable --now munge
```
验证（任意节点）：
```bash
munge -n | unmunge | head
```
# 跨机验证（在 worker01）：
```bash
munge -n | ssh master unmunge | head
```


⸻

4. 源码编译安装 Slurm（每台机都装）
```bash
cd ~
wget https://download.schedmd.com/slurm/slurm-23.11.9.tar.bz2
tar -xjf slurm-23.11.9.tar.bz2
cd slurm-23.11.9

./configure --prefix=/usr/local --sysconfdir=/etc/slurm
make -j"$(nproc)"
sudo make install
```
之后 Slurm 可执行位于 /usr/local/sbin、/usr/local/bin。systemd unit 要用这个路径，不要写 /usr/sbin。可以用`which slurm`确定slurm安装位置。
测试:
```bash
slurmd --version
```
⸻

5. 写统一的 /etc/slurm/slurm.conf（在 master 生成 → 分发）

先在 master 编辑，主机配置可以用`slurmd -C`查询
```bash
sudo vim /etc/slurm/slurm.conf
```
```bash
### 基本
ClusterName=hpc-cluster
ControlMachine=master
ControlAddr=192.168.124.5

### 认证与运行账户
SlurmUser=slurm
AuthType=auth/munge

### 状态、缓存、日志
StateSaveLocation=/home/slurm/spool/slurmctld
SlurmdSpoolDir=/home/slurm/spool/slurmd
SlurmctldLogFile=/home/slurm/log/slurmctld.log
SlurmdLogFile=/home/slurm/log/slurmd-%n.log

### 端口（默认即可）
SlurmctldPort=6817
SlurmdPort=6818

### 调度/选择/任务插件（Rocky8/9 通用）
SchedulerType=sched/backfill
SelectType=select/cons_res
SelectTypeParameters=CR_Core_Memory
ProctrackType=proctrack/cgroup
TaskPlugin=task/cgroup

### 其他基础
ReturnToService=2
SlurmctldPidFile=/run/slurmctld.pid
SlurmdPidFile=/run/slurmd.pid
SwitchType=switch/none
# 邮件程序占位，防止告警
MailProg=/bin/true

### 节点（请按实际 CPU / 内存修改 RealMemory 值）
NodeName=master   NodeAddr=192.168.124.5   CPUs=104 RealMemory=180000 State=UNKNOWN
NodeName=worker01 NodeAddr=192.168.124.19  CPUs=112 RealMemory=180000 State=UNKNOWN
NodeName=worker02 NodeAddr=192.168.124.18  CPUs=96  RealMemory=250000 State=UNKNOWN

PartitionName=normal Nodes=master,worker01,worker02 Default=YES MaxTime=INFINITE State=UP
```

# 修改权限与属主
```bash
sudo chown slurm:slurm /etc/slurm/slurm.conf
sudo chmod 644 /etc/slurm/slurm.conf
```
分发到节点：
```bash
master:
scp /etc/slurm/slurm.conf worker01:/tmp/
scp /etc/slurm/slurm.conf worker02:/tmp/
worker01/work02:
sudo mkdir -p /etc/slurm
sudo mv /tmp/slurm.conf /etc/slurm/slurm.conf
sudo chown slurm:slurm /etc/slurm/slurm.conf
```
验证一下md5是否一致,在每台机都输入:
```bash
md5sum /etc/slurm/slurm.conf
```
⸻

6.（可选）cgroup.conf（建议开 CPU/内存约束）

三台机：
```bash
sudo tee /etc/slurm/cgroup.conf >/dev/null <<'EOF'
CgroupMountpoint=/sys/fs/cgroup
ConstrainCores=yes
ConstrainRAMSpace=yes
EOF
sudo chown slurm:slurm /etc/slurm/cgroup.conf
sudo chmod 644 /etc/slurm/cgroup.conf
```
Rocky8 默认 cgroup v1，Rocky9 多为 v2：TaskPlugin=task/cgroup 在 23.11 可同时工作；无需 task/cgroup_v2 名字。不要重复设置 TaskPlugin/ProctrackType，以免“specified more than once”。

⸻

1. systemd 单元（使用 /usr/local 路径）(一般编译的都自带了)

```bash
master:
sudo vim /etc/systemd/system/slurmctld.service

[Unit]
Description=Slurm controller daemon
After=network.target munge.service
ConditionPathExists=/etc/slurm/slurm.conf

[Service]
Type=simple
User=slurm
ExecStart=/usr/local/sbin/slurmctld -D
Restart=on-failure
LimitNOFILE=131072

[Install]
WantedBy=multi-user.target
```
三台都写:
```bash
sudo vim /etc/systemd/system/slurmd.service

[Unit]
Description=Slurm node daemon
After=network.target munge.service
ConditionPathExists=/etc/slurm/slurm.conf

[Service]
Type=simple
User=root
ExecStart=/usr/local/sbin/slurmd -D
Restart=on-failure
LimitNOFILE=131072

[Install]
WantedBy=multi-user.target
```

应用：
```bash
sudo systemctl daemon-reload
```

⸻

1. 防火墙与 SELinux

三台机都放行：
```bash
sudo firewall-cmd --permanent --add-port=6817-6819/tcp
sudo firewall-cmd --reload
```
SELinux 若 Enforcing，建议：
```bash
sudo restorecon -Rv /etc/slurm /home/slurm
```

⸻

9. 启动顺序与验证

三台机：
```bash
sudo systemctl enable --now munge

master：

sudo systemctl enable --now slurmctld
sudo systemctl status slurmctld --no-pager

worker01 / worker02：

sudo systemctl enable --now slurmd
sudo systemctl status slurmd --no-pager

master 上看集群：

scontrol ping                # 看到 Slurmctld(primary) ... is UP
sinfo -N -l                  # 三台都应 idle
scontrol show node master
scontrol show node worker01
scontrol show node worker02

若有节点 DOWN，可尝试：

scontrol update NodeName=worker01 State=RESUME
```

⸻

10. 提交测试作业
```bash
单节点：

srun -N1 -n1 hostname

多节点拉满 CPU（stress-ng 需已安装）：

三台机装：

sudo dnf install -y stress-ng

在 master 写 cpu_burn.slurm：

#!/bin/bash
#SBATCH -J burn
#SBATCH -p normal
#SBATCH -N 3
#SBATCH -t 00:05:00
#SBATCH -o burn-%j.out

# 每个节点起 1 个进程，内部拉满所有 CPU
srun --ntasks-per-node=1 stress-ng --cpu 0 --timeout 300s

提交：

sbatch cpu_burn.slurm
squeue
```

📌 小结（最关键的 4 点）
	1.	三台机 slurm 用户 UID/GID 一致。
	2.	同一把 MUNGE key（权限 400，属 munge:munge）。
	3.	同一份 slurm.conf（逐字节一致；NodeAddr/HostName/IP 写对）。
⸻


常用命令（存档）:

开关服务
sudo systemctl restart slurmd  
sudo systemctl restart slurmctld 
sudo systemctl restart munge

服务状态
sudo systemctl status slurmd  
sudo systemctl status slurmctld 
sudo systemctl status munge

查看日志
tail -f /home/slurm/spool/slurmd/slurmd.log

slurm.conf文件配置：
```bash
ClusterName=hpc-cluster
ControlMachine=master

SlurmUser=slurm
AuthType=auth/munge

#日志
StateSaveLocation=/home/slurm/spool/slurmctld
SlurmdSpoolDir=/home/slurm/spool/slurmd
SlurmctldLogFile=/home/slurm/log/slurmctld.log
SlurmdLogFile=/home/slurm/log/slurmd-%n.log
# 计算节点（含 master）
NodeName=master CPUs=104 RealMemory=180000 State=UNKNOWN
NodeName=worker01 CPUs=112 RealMemory=180000 State=UNKNOWN
NodeName=worker02 CPUs=96 RealMemory=250000 State=UNKNOWN
PartitionName=normal Nodes=master,worker01,worker02 Default=YES MaxTime=INFINITE State=UP

# 避免报错
MailProg=/bin/true
ProctrackType=proctrack/cgroup
TaskPlugin=task/cgroup

# 不用 slurmdbd，关掉计费
AccountingStorageType=none
AccountingStorageHost=localhost
AccountingStoragePort=6819
JobAcctGatherType=jobacct_gather/none
JobAcctGatherFrequency=0
```
