## 命令示例（拉取nginx）

```bash
# 拉镜像
docker pull nginx
```

```bash
# 创建运行容器
docker run -d --name mynginx -p 8080:80 nginx 
```

```bash
# 终端调试nginx
docker run -it --name mynginx nginx /bin/sh
```


```bash
# 查看容器状态
docker ps -a
```

```bash
# 进入容器
docker exec -it mynginx bash / sh
```

```bash
# 删除容器
docker rm -f mynginx
```



```bash
# 重启容器
docker restart mynginx
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