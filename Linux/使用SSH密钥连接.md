


# 使用 SSH 密钥连接远程服务器

## 一、在客户端生成密钥对

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

- `-t rsa`：使用 RSA 算法（或使用更安全的 `ed25519`）
- `-b 4096`：密钥长度（ed25519 不需要）
- 按提示操作后会在 `~/.ssh/` 目录生成：
  - 私钥：`id_rsa`
  - 公钥：`id_rsa.pub`

## 二、将公钥复制到远程服务器

使用 ssh-copy-id：

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub -p 端口号 用户名@服务器IP
```
这里提一下，如果只有一个密钥文件不用加-i也是可以的

如果提示密钥已存在，可以使用 `-f` 强制替换


## 三、远程服务器 SSH 配置检查（可选）

编辑 `/etc/ssh/sshd_config` 确保以下设置：

```
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
PasswordAuthentication no  # 可选，禁用密码登录
```

重启 SSH 服务：

```bash
# Ubuntu/Debian
sudo systemctl restart ssh

# CentOS/Rocky
sudo systemctl restart sshd
```

## 五、测试密钥登录

```bash
ssh -p 2222 -i ~/.ssh/id_rsa tommy@192.168.124.12
```

## 六、推荐配置 ~/.ssh/config（可选）

方便管理多个密钥和主机：

```bash
Host WSL
    HostName 192.168.124.12
    Port 2222
    User tommy
    IdentityFile ~/.ssh/id_rsa_gitee
```

然后可以直接使用：

```bash
ssh WSL
```