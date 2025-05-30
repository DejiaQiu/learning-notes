## 监控告警
Prometheus 是一款强大的开源监控系统，结合 Alertmanager 可以实现自动化告警通知，接入webhook后可以通过飞书，企业微信等自动通知。其主要流程为：

1. Prometheus 采集被监控系统的指标（metrics）；
2. 通过配置的规则（rule）评估是否触发告警；
3. 若触发，发送告警至 Alertmanager；
4. Alertmanager 对告警进行分组、抑制，并通过 Email、Slack、钉钉等方式通知用户。

## Prometheus配置规则
Prometheus 使用规则文件（如 `rules.yml`）来定义告警逻辑。

示例告警规则：
```yaml
groups:
  - name: hpc-monitoring
    rules:
      # 高 CPU 使用率（> 95% 持续 5 分钟）
      - alert: HighCPUUsage
        expr: (100 - avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[2m])) * 100) > 95
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "高 CPU 使用率：{{ $labels.instance }}"
          description: "CPU 使用率超过 95%，当前为 {{ printf \"%.1f\" $value }}%"
```

在 `prometheus.yml` 中引用该规则：
```yaml
rule_files:
  - "rules.yml"   # 也可以使用绝对路径
```

同时配置 Alertmanager 地址：
```yaml
alerting:
  alertmanagers:
    - static_configs:
        - targets: ["localhost:9093"]
```

## Prometheus+Alertmanager配置告警
Alertmanager 负责接收 Prometheus 发出的告警，并通过邮件、Webhook、钉钉等方式推送通知。
docker-compose编排Alertmanager:
```yaml
  alertmanager:
    image: prom/alertmanager:latest
    ports:
      - "9093:9093"
    volumes:
      - ./prometheus/alertmanager.yml:/etc/alertmanager/alertmanager.yml
    command:
      - '--config.file=/etc/alertmanager/alertmanager.yml'
```


使用alertmanager-webhook开源工具：https://github.com/Rainbowhhy/alertmanager-webhook

`alertmanager.yml` 配置：
```yaml
route:    # 根路由，路由规则
  group_by: ['alertname']  # 按照哪些标签对告警分组，这里为alertname
  group_wait: 30s          # 当一个告警首次触发时，等待多久后发送
  group_interval: 5m       # 在发送初始通知后，等待多久再次发送同一组告警 s
  repeat_interval: 1h      # 告警持续存在的情况下，多久后重复发送告警
  receiver: 'web.hook'     # 指定告警通知的接收器名称
receivers:
  - name: 'web.hook'  # 接收器的名称
    webhook_configs:  # 接收器使用的webhook配置
      - url: 'http://192.168.124.5:9095/feishu'  # url
        send_resolved: true  # 告警恢复后是否发送通知       
```
使用 Docker：
```bash
docker run -d --name redis -p 0.0.0.0:6379:6379 redis:5.0.0 redis-server /etc/redis/redis.conf
           -v /root/redis.conf:/etc/redis/redis.conf

docker run -d --name alertmanager-webhook -p 0.0.0.0:9095:9095 
           -v /root/alertmanager-webhook.yaml:/etc/alertmanager-webhook/alertmanager-webhook.yaml rainbowhhy/alertmanager-webhook:v1.0
```
或者启用系统服务：
```bash
cat >/etc/systemd/system/alertmanager_webhook.service <<EOF
[Unit]
Description=alertmanager-webhook
After=network.target  

[Service]
Type=simple
# 工作目录
WorkingDirectory=/home/tommy/monitoring/prometheus/alertmanager-webhook-v1.0-linux-amd64
# 启动命令
ExecStart=/home/tommy/monitoring/prometheus/alertmanager-webhook-v1.0-linux-amd64/alertmanager-webhook -c alertmanager-webhook.yaml
Restart=on-failure
PrivateTmp=true  

[Install]
WantedBy=multi-user.target
EOF
```

重新加载systemd配置并启动服务:
```bash
systemctl daemon-reload
systemctl enable alertmanager_webhook.service
systemctl start alertmanager_webhook.service
systemctl status alertmanager_webhook.service
```

可以查看日志:
```bash
journalctl -u alertmanager_webhook.service
```


测试：
```bash
curl -X POST -H "Content-Type: application/json" -d '
{"alerts": [
    {
      "status": "firing",
      "labels": {
        "alertname": "机器宕机监测",
        "instance": "192.168.124.5",
        "job": "node_exporter",
        "serverity": "warning"
      },
      "annotations": {
        "description": "机器:192.168.124.5 所属 job:node_exporter 宕机超过1分钟，请检查！",
        "summary": "机器发生宕机"
      },
      "startsAt": "2024-01-10T11:59:09.775Z",
      "endsAt": "2024-01-10T13:00:00Z",
      "fingerprint": "02f13394997e5211"
    }
  ]
}' http://127.0.0.1:9095/feishu
```