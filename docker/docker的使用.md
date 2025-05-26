## docker基本命令

```bash
# 拉取镜像
docker pull <image>
```

```bash
# 创建运行容器
docker run -d --name mynginx -p 8080:80 <image> 
```

```bash
# 查看运行中的容器
docker ps -a
```

```bash
# 终端调试nginx
docker run -it --name mynginx nginx /bin/sh
```


```bash
# 进入容器和查看日志
docker exec -it mynginx bash / sh
docker logs
```

```bash
# 停止和删除容器
docker stop <container>
docker rm -f <container>
```
```bash
# 删除镜像
docker rmi <image>
```


```bash
# 重启容器
docker restart <container>
```

## 创建容器

```bash
docker run -d \
  --name nginx-server \
  -p 8080:80 \
  -v /home/tommy/nginx/html:/usr/share/nginx/html \
  -v /home/tommy/nginx/conf.d:/etc/nginx/conf.d \
  -v /etc/localtime:/etc/localtime:ro \
  --restart unless-stopped \
  nginx
```


## 进入nginx
```
    docker exec -it nginx-server bash
```

## 查看挂载

```bash
docker inspect mynginx | grep Mounts -A 20
```

## 查看所有 volume 挂载点：

```bash
docker volume inspect mynginx
```

如果以后想长期调试 nginx，建议直接挂宿主机目录：

```bash
-v /home/tommy/nginx_conf:/etc/nginx
```

✅ 改完后：记得重启 nginx 容器

```bash
docker restart mynginx
```


## 运行一个临时ubuntu容器

```bash
docker run -it --rm \
  -v mynginx:/etc/nginx \
  ubuntu:22.04 bash
```

这条命令的意思是：  
- 创建一个临时 Ubuntu 容器（退出即删）  
- 把你 nginx 容器的配置目录挂载到它的 /etc/nginx

## 更新vim

```bash
apt update
apt install vim
vim /etc/nginx/nginx.conf
```



## mysql安装
```
 docker run -d -p 3306:3306 \
  --restart=unless-stopped \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -e LC_ALL=C.UTF-8 \
  -v "/etc/localtime:/etc/localtime" \
  -v mysql:/var/lib/mysql \
  mysql:8.4
```

## 运行mysql
```
docker exec -it (ID) /bin/bash
mysql -uroot -p
```



## 常用参数

### docker run 常用参数说明

| 参数 | 说明 | 示例 |
|------|------|------|
| `-d` | 后台运行容器 | `docker run -d nginx` |
| `-it` | 交互式运行容器 | `docker run -it ubuntu bash` |
| `--rm` | 容器退出后自动删除 | `docker run --rm ubuntu` |
| `--name` | 指定容器名称 | `--name mynginx` |
| `-p` | 端口映射：宿主机:容器 | `-p 8080:80` |
| `-v` | 数据卷挂载：宿主机路径:容器路径 | `-v /host:/container` |
| `--network` | 指定网络模式（bridge、host、自定义网络） | `--network host` |
| `-e` | 设置环境变量 | `-e MYSQL_ROOT_PASSWORD=123456` |
| `--env-file` | 从文件加载环境变量 | `--env-file .env` |
| `--restart` | 重启策略（如 `no`, `on-failure`, `always`, `unless-stopped`） | `--restart unless-stopped` |
| `--privileged` | 启用特权模式 | `--privileged=true` |
| `--entrypoint` | 覆盖默认启动命令 | `--entrypoint /bin/bash` |
| `--cpus` | 限制 CPU 使用数量 | `--cpus="1.5"` |
| `-m` / `--memory` | 限制内存使用量 | `--memory="512m"` |
| `--log-driver` | 日志驱动（json-file, syslog, none 等） | `--log-driver=json-file` |



## 查询帮助
```bash
docker run --help
docker exec --help
```