# Prometheus + Grafana 部署教程（Docker & Docker Compose）

Prometheus 是一个开源的系统监控和报警工具包，具有多维数据模型和强大的查询语言 PromQL，广泛用于基础设施和应用监控。

Grafana 是一款功能强大的开源数据可视化平台，支持多种数据源（如 Prometheus、InfluxDB、Loki 等），常与 Prometheus 搭配使用，以图形化方式展示监控数据。

二者结合可以构建灵活、可扩展的监控系统，实现对服务器、容器、应用程序的实时监控和告警。

本教程介绍如何使用 Docker 和 Docker Compose 在本地部署 Prometheus 与 Grafana，实现基础的监控可视化平台。

## 📦 环境准备

- Docker
- 创建工作目录：

```bash
mkdir -p ~/monitoring/{prometheus,grafana}
cd ~/monitoring
```

## 📁 项目结构

```linux
[tommy@master prometheus]$ tree ~/monitoring -I 'grafana'
/home/tommy/monitoring
├── alertmanager-webhook-v1.0-linux-amd64.tar
├── docker-compose.yml
└── prometheus
    ├── alertmanager-webhook-v1.0-linux-amd64
    │   ├── alertmanager-webhook
    │   ├── alertmanager-webhook.log
    │   ├── alertmanager-webhook.yaml
    │   ├── Dockerfile
    │   ├── example
    │   │   ├── default.tmpl
    │   │   ├── dingding.tmpl
    │   │   ├── feishu.tmpl
    │   │   └── qywechat.tmpl
    │   └── template
    │       └── alert.tmpl
    ├── alertmanager.yml
    ├── prometheus.yml
    └── rules.yaml

```

## 🛠️ 配置 Prometheus(已经包括最小配置和规则配置，altermanager配置)

编辑 `prometheus/prometheus.yml` 文件：

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node_exporters'
    static_configs:
      - targets: ['192.168.124.5:9100']
        labels:
          nodename: master
      - targets: ['192.168.124.18:9100']
        labels:
          nodename: worker-2
      - targets: ['192.168.124.19:9100']
        labels:
          nodename: worker-1

rule_files:
  - "rules.yaml"   # 告警规则文件路径，注意文件需与 Prometheus 配置文件同目录或使用绝对路径

alerting:    # 告警配置
  alertmanagers:    # 配置Alertmanager
    - static_configs:    # 静态配置
      - targets: ['192.168.124.5:9093']  # 使用的Alertmanager     
```

## 🧱 编写 docker-compose.yml(已经包括最小配置和规则配置，altermanager配置)

在 `monitoring/` 目录下创建 `docker-compose.yml` 文件：

```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - ./prometheus/rules.yaml:/etc/prometheus/rules.yaml
    ports:
      - "19090:9090"
    restart: unless-stopped

  alertmanager:
    image: prom/alertmanager:latest
    ports:
      - "9093:9093"
    volumes:
      - ./prometheus/alertmanager.yml:/etc/alertmanager/alertmanager.yml
    command:
      - '--config.file=/etc/alertmanager/alertmanager.yml'

  grafana:
    image: grafana/grafana-oss:latest
    container_name: grafana
    volumes:
      - ./grafana:/var/lib/grafana
    ports:
      - "13000:3000"
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin
    restart: unless-stopped


  node_exporter:
    image: quay.io/prometheus/node-exporter:latest
    container_name: node_exporter
    restart: unless-stopped
    network_mode: "host"
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - --path.procfs=/host/proc
      - --path.sysfs=/host/sys
      - --path.rootfs=/rootfs
      - --collector.filesystem.ignored-mount-points=^/(sys|proc|dev|host|etc)($|/)
      - --collector.filesystem.ignored-fs-types=^(tmpfs|devtmpfs|overlay|aufs|squashfs)$
```

## 🚀 启动服务

进入 `monitoring/` 目录，执行：

```bash
docker-compose up -d
```

验证容器运行状态：

```bash
docker ps
```

## ➕ Grafana 添加 Prometheus 数据源

1. 打开 Grafana 后台 → “Configuration” → “Data Sources”
2. 添加 Prometheus 数据源，URL 填写 `http://prometheus:9090`
3. 保存并测试连接