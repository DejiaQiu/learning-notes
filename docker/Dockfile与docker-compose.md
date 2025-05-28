# Dockerfile 与 Docker Compose 知识整理

## 一、Dockerfile 基础

Dockerfile 是用于构建自定义镜像的脚本。

### 常用指令说明

| 指令 | 作用 |
|------|------|
| `FROM` | 指定基础镜像 |
| `LABEL` | 添加作者、版本等元数据 |
| `RUN` | 在镜像构建过程中执行命令 |
| `COPY` / `ADD` | 拷贝文件到镜像中 |
| `ENV` | 设置环境变量 |
| `WORKDIR` | 指定工作目录 |
| `EXPOSE` | 声明容器暴露的端口（仅用于文档） |
| `CMD` | 容器启动时默认命令（可被 docker run 覆盖） |
| `ENTRYPOINT` | 容器启动时执行的主命令（不易被覆盖） |
| `VOLUME` | 声明挂载点 |
| `ARG` | 构建时参数 |

### 示例 Dockerfile

```Dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "main.py"]
```

---

## 二、Docker Compose 基础

Docker Compose 用于定义和运行多容器应用。

### 关键字段

| 字段 | 含义 |
|------|------|
| `version` | Compose 文件版本 |
| `services` | 多个服务（容器）配置块 |
| `image` | 使用的镜像名 |
| `build` | 指定 Dockerfile 路径 |
| `ports` | 端口映射 |
| `volumes` | 数据卷挂载 |
| `environment` | 环境变量 |
| `depends_on` | 声明依赖的服务 |
| `networks` | 网络设置 |
| `restart` | 重启策略 |
| `command` | 覆盖容器启动命令 |

### 示例 docker-compose.yml

```yaml
version: "3.9"
services:
  app:
    build: .
    ports:
      - "8000:8000"
    volumes:
      - .:/app
    environment:
      - DEBUG=true
  redis:
    image: redis:alpine
```
一般命令
```bash
docker compose up -d
docker compose down
```