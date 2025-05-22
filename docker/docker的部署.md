
Docker 部署过程相对简单，但由于国内网络限制，直接访问 Docker Hub 经常会失败。推荐配置代理来加速镜像拉取。以下是安装 Docker 并配置代理的完整流程，适用于国内网络环境，建议在虚拟机或物理机中操作：

### 一、安装 Docker（以 Rocky Linux / CentOS 为例）

##### 若之前安装过需要清理掉旧的docker
```bash
sudo dnf remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine
```
##### 安装依赖
```bash
sudo dnf install -y yum-utils device-mapper-persistent-data lvm2
```

##### 安装docker并设置为开机启动
```bash
sudo dnf install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable --now docker
```
##### 验证安装结果
```bash
docker version
docker info
```

### 二、配置代理以访问 Docker Hub
##### 下载代理软件clash并添加执行权限
```bash
chmod +x clash
```

##### 下载订阅链接
```bash
curl -o config.yaml "https://example.com/subscription.yaml"
```
##### 查看配置文件
```bash
~/.config/clash/config.yaml
```

##### 启动
```bash
#后台启动：
tmux new -s clash
clash -d ~/.config/clash

#这里把程序升级为系统服务，会更方便
#创建一个 systemd 单元文件，让系统托管 Clash：
sudo nano /etc/systemd/system/clash.service

#输入以下内容：（注意修改user和地址）
[Unit]
Description=Clash Service
After=network.target

[Service]
Type=simple
User=xxx
ExecStart=/home/xxx/software/clash/clash -d /home/xxx/.config/clash
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target

#重新加载systemd配置：
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

#启动clash服务：
sudo systemctl start clash

#设为开机启动：
sudo systemctl enable clash

#重启停止和查看状态：
sudo systemctl restart clash
sudo systemctl stop clash
sudo systemctl status clash

#查看日志：
journalctl -u clash -f
```

##### 修改节点
```bash
#方法1:修改配置文件
#方法2:命令行选择
curl -X PUT http://127.0.0.1:9090/proxies/🔰%20选择节点 \
     -H "Content-Type: application/json" \
     -d '{"name": "🇭🇰 香港Y02 | IEPL"}'

#注意端口号跟节点名字

```
##### 设置环境变量
```bash
vim ~/.bashrc

export http_proxy=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890

source ~/.bashrc
```

sudo systemctl restart clash

### 三、重启 Docker 服务以应用代理配置

```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### 四、验证是否可用

```bash
docker pull hello-world
```

如果输出成功，说明配置生效。
