frp是一个内网穿透软件，可以实现公网访问局域网内设备。


设置开机启动


重启并后台启动frp客户端
```
pkill frpc
nohup ./frpc -c frpc.toml > frpc.log 2>&1 &
tail -f frpc.log
```