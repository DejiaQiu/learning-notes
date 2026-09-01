frp是一个内网穿透软件，可以实现公网访问局域网内设备。
FRP 分为两部分：
	•	frps：服务端（部署在有公网 IP 的服务器上）
	•	frpc：客户端（部署在内网需要暴露服务的机器上）

运行原理是：客户端通过 frpc 主动连接公网的 frps，frps 再把请求转发到内网服务。
### frp的安装：
```bash
wget https://github.com/fatedier/frp/releases/download/v0.60.0/frp_0.60.0_linux_amd64.tar.gz
tar -zxvf frp_0.60.0_linux_amd64.tar.gz
cd frp_0.60.0_linux_amd64

1️⃣主机端：
vim frpc.toml
[common]  # 云服务的ip以及端口
server_addr = xxx.xxx.xxx.xxx
server_port = 8001

[ssh_master] # 当前主机的ssh服务  
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 985

后台启动frpc:
nohup ./frpc -c frpc.toml > frpc.log 2>&1 &

可选杀掉frpc：
pkill frpc

查看frpc的日志：
tail -f frpc.log

2️⃣云服务端：
vim frps.toml
bindPort = 8001  # 服务端监听端口

nohup ./frps -c frps.toml > frps.log 2>&1 &
```

### (可选)设置为系统服务

1.	创建配置文件目录（假设放在 /etc/frp）：
```bash
sudo mkdir -p /etc/frp
sudo cp frps.ini /etc/frp/
sudo cp frps /usr/local/bin/
sudo cp frpc.ini /etc/frp/
sudo cp frpc /usr/local/bin/
```
2.	新建 systemd service 文件：
```bash
服务端(frps)：
sudo nano /etc/systemd/system/frps.service

[Unit]
Description=FRP Server Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/frps -c /etc/frp/frps.ini
Restart=on-failure
RestartSec=5s
User=nobody
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target

frpc（客户端）:
sudo nano /etc/systemd/system/frpc.service

[Unit]
Description=FRP Client Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/frpc -c /etc/frp/frpc.ini
Restart=on-failure
RestartSec=5s
User=nobody
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
```

```bash
启动服务：
sudo systemctl start frps
sudo systemctl start frpc

开机自启：
sudo systemctl enable frps
sudo systemctl enable frpc

查看日志：
journalctl -u frps -f
journalctl -u frpc -f
```
