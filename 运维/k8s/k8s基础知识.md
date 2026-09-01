


# Kubernetes 基础知识

## 1. K8s 是为了解决什么问题出现的，和 Docker 有什么关系

Kubernetes (K8s) 是为了管理大规模容器集群出现的，核心目标是实现容器的自动化部署、扩缩容、负载均衡和自愈等。

Docker 主要解决「如何把应用和依赖打包到一个轻量级的容器里并在任何地方运行」；而 K8s 则是「如何大规模地管理和调度这些容器」。

---

## 2. K8s 中有哪些核心组件，它们分别负责什么

### 控制平面组件

- **kube-apiserver**：集群的入口，处理所有 REST API 请求。
- **etcd**：保存所有集群状态数据的分布式键值存储。
- **kube-scheduler**：负责将 Pod 调度到合适的节点。
- **kube-controller-manager**：负责各类控制器，保证集群状态符合预期。
- **cloud-controller-manager**（可选）：与云平台 API 交互。

### 节点组件

- **kubelet**：管理节点上的 Pod 生命周期。
- **kube-proxy**：提供网络代理和负载均衡。
- **容器运行时**：运行容器的实际工具，如 containerd、CRI-O。

---

## 3. K8s 中的最小单元是什么

Pod 是 Kubernetes 的最小调度单元，通常包含一个主要容器。

---

## 4. 什么是容器运行时，有哪些常用的

容器运行时是负责真正运行容器的组件。

常见的有：

- containerd
- CRI-O
- Docker Engine（现在主要通过 containerd 提供运行时）
- rkt（已不维护）

---

## 5. 什么是 CNI，有哪些常用的

CNI（Container Network Interface）是容器网络接口标准，负责给 Pod 分配 IP 并配置网络。

常用插件：

- Calico
- Flannel
- Cilium
- Weave

---

## 6. Pod 与容器有什么区别

- 容器：运行应用的最小单位。
- Pod：K8s 的基本调度单位，封装一个或多个容器，并共享网络、存储和生命周期。

---

## 7. 使用 kubeadm 安装 Kubernetes 集群

```bash
# 所有节点
yum install -y kubelet kubeadm kubectl
systemctl enable --now kubelet

# master 节点初始化
kubeadm init --pod-network-cidr=10.244.0.0/16

# 配置 kubeconfig
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

# node 节点加入
kubeadm join <master_ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```

---

## 8. 使用 Nginx 镜像运行一个 Pod

```bash
kubectl run nginx --image=nginx
```

---

## 9. 如何查看 Pod 的事件

```bash
kubectl describe pod nginx
```

---

## 10. 如何查看 Pod 的日志

```bash
kubectl logs nginx
```

---

## 11. 如何查看 Pod 启动在哪台机器

```bash
kubectl get pod -o wide
```

---

## 12. 如何进入 Pod 中的容器

```bash
kubectl exec -it nginx -- /bin/bash
```

---

## 13. 什么是抽象资源，什么是实例资源

- 抽象资源：Deployment、StatefulSet、Service 等，是配置和声明的对象。
- 实例资源：由抽象资源生成和管理的 Pod 等具体运行对象。

---

## 14. Pod 是抽象对象还是实例

Pod 是实例对象。

---

## 15. 访问 Nginx 的方法

- port-forward：

```bash
kubectl port-forward pod/nginx 8080:80
```

- 创建 Service 暴露端口：

```bash
kubectl expose pod nginx --port=80 --type=NodePort
```

---

## 16. Pod 如何重启

删除后重新创建：

```bash
kubectl delete pod nginx
```

若由 Deployment 管理，会自动拉起新 Pod。

---

## 17. 如何删除 Pod

```bash
kubectl delete pod nginx
```

---

## 18. 单独创建 Pod 的缺点

- 无自愈能力，崩溃不会自动重启。
- 不支持副本管理，不能扩容。
- 不支持滚动更新。

推荐使用 Deployment 或 StatefulSet 管理 Pod。