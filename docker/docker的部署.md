
Docker 部署过程相对简单，但由于国内网络限制，直接访问 Docker Hub 经常会失败。推荐配置代理来加速镜像拉取。以下是安装 Docker 并配置代理的完整流程，适用于国内网络环境，建议在虚拟机或物理机中操作：

### 一、安装 Docker（以 Rocky Linux / CentOS 为例）

```bash
sudo dnf remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine

sudo dnf install -y yum-utils

sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo dnf install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable --now docker
```

### 二、配置代理以访问 Docker Hub

```bash
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo tee /etc/systemd/system/docker.service.d/proxy.conf <<EOF
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:7890"
Environment="HTTPS_PROXY=http://127.0.0.1:7890"
Environment="NO_PROXY=localhost,127.0.0.1"
EOF
```

> 请根据你本机代理软件的设置修改端口（如 Clash/V2Ray 常为 7890 或 1080）。

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
