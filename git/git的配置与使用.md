## 📌 Git 的配置与使用指南

### 🧱 一、生成 SSH Key


```bash
ssh-keygen -t rsa -C "你的邮箱" -f ~/.ssh/id_rsa
```


说明：
- `-C`：注释（推荐写你的邮箱）
- `-f`：指定生成的 key 文件路径


常见使用：
```bash
ssh-keygen -t rsa -C "798951257@qq.com" -f ~/.ssh/id_rsa_gitee
```

### 🔑 二、配置多个 SSH Key（GitHub 和 Gitee）

1. 为 GitHub 生成：
```bash
ssh-keygen -t rsa -C "you@github.com" -f ~/.ssh/id_rsa_github
```
2. 为 Gitee 生成：
```bash
ssh-keygen -t rsa -C "you@gitee.com" -f ~/.ssh/id_rsa_gitee
```


2. 编辑 `~/.ssh/config` 文件：

```sshconfig
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_rsa_github
  IdentitiesOnly yes

Host gitee.com
  HostName gitee.com
  User git
  IdentityFile ~/.ssh/id_rsa_gitee
  IdentitiesOnly yes
```

3. 验证是否配置成功：

```bash
ssh -T git@github.com
ssh -T git@gitee.com
```

---

### 🛰 三、配置 Git 多个远程仓库

#### 添加远程仓库：

这个可以新仓库页看到，直接复制完微调名字。

#### 查看远程：

```bash
git remote -v
```

#### 推送代码：

```bash
git push origin-github main
git push origin-gitee main
```

---

### ✍️ 四、Git 常用命令速查表

| 操作 | 命令 |
|------|------|
| 初始化仓库 | `git init` |
| 添加变更 | `git add .` |
| 提交变更 | `git commit -m "说明"` |
| 推送远程 | `git push origin main` |
| 查看状态 | `git status` |
| 查看历史 | `git log` |
| 删除远程 | `git remote remove origin` |

---
