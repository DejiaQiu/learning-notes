# PyTorch 基础与训练流程

## 1. PyTorch 的核心组件

常用组件：

- Tensor。
- autograd。
- nn.Module。
- Dataset。
- DataLoader。
- optimizer。
- scheduler。

PyTorch 的优势：

- 动态计算图。
- 调试方便。
- 社区生态成熟。
- 论文复现常用。

## 2. Tensor

Tensor 是 PyTorch 的基础数据结构。

```python
import torch

x = torch.tensor([[1.0, 2.0], [3.0, 4.0]])
print(x.shape)
```

常见属性：

- shape。
- dtype。
- device。
- requires_grad。

## 3. CPU 和 GPU

把模型和数据放到同一个 device。

```python
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

model = model.to(device)
x = x.to(device)
y = y.to(device)
```

如果模型在 GPU，数据在 CPU，会报错。

## 4. Dataset

Dataset 定义如何读取一个样本。

```python
from torch.utils.data import Dataset

class MyDataset(Dataset):
    def __init__(self, samples):
        self.samples = samples

    def __len__(self):
        return len(self.samples)

    def __getitem__(self, idx):
        x, y = self.samples[idx]
        return x, y
```

## 5. DataLoader

DataLoader 负责批量加载数据。

```python
from torch.utils.data import DataLoader

loader = DataLoader(
    dataset,
    batch_size=32,
    shuffle=True,
    num_workers=4,
)
```

训练集通常 `shuffle=True`，验证集和测试集通常 `shuffle=False`。

## 6. nn.Module

所有模型通常继承 `nn.Module`。

```python
import torch.nn as nn

class MLP(nn.Module):
    def __init__(self, input_dim, hidden_dim, num_classes):
        super().__init__()
        self.net = nn.Sequential(
            nn.Linear(input_dim, hidden_dim),
            nn.ReLU(),
            nn.Linear(hidden_dim, num_classes),
        )

    def forward(self, x):
        return self.net(x)
```

## 7. 训练循环

标准训练循环：

```python
model.train()

for x, y in train_loader:
    x = x.to(device)
    y = y.to(device)

    optimizer.zero_grad()
    logits = model(x)
    loss = criterion(logits, y)
    loss.backward()
    optimizer.step()
```

关键点：

- `model.train()`。
- `optimizer.zero_grad()`。
- `loss.backward()`。
- `optimizer.step()`。

## 8. 验证循环

验证阶段不更新参数。

```python
model.eval()

total_loss = 0.0

with torch.no_grad():
    for x, y in val_loader:
        x = x.to(device)
        y = y.to(device)
        logits = model(x)
        loss = criterion(logits, y)
        total_loss += loss.item()
```

关键点：

- `model.eval()`。
- `torch.no_grad()`。

## 9. 保存模型

推荐保存 state_dict。

```python
torch.save(
    {
        "model": model.state_dict(),
        "optimizer": optimizer.state_dict(),
        "epoch": epoch,
        "best_metric": best_metric,
    },
    "checkpoint.pt",
)
```

加载：

```python
ckpt = torch.load("checkpoint.pt", map_location=device)
model.load_state_dict(ckpt["model"])
```

## 10. 固定随机种子

为了提高可复现性：

```python
import random
import numpy as np
import torch

def set_seed(seed):
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
```

注意：

- 固定随机种子不能保证所有操作完全确定。
- GPU 上某些算子仍可能存在非确定性。

## 11. 混合精度训练

混合精度可以减少显存占用并加速训练。

PyTorch 常用 AMP：

```python
scaler = torch.cuda.amp.GradScaler()

for x, y in train_loader:
    optimizer.zero_grad()

    with torch.cuda.amp.autocast():
        logits = model(x)
        loss = criterion(logits, y)

    scaler.scale(loss).backward()
    scaler.step(optimizer)
    scaler.update()
```

## 12. 常见 bug

### 12.1 忘记 zero_grad

会导致梯度累加，训练异常。

### 12.2 忘记 model.eval

Dropout 和 BatchNorm 在训练和验证阶段行为不同。

### 12.3 忘记 no_grad

验证阶段会浪费显存。

### 12.4 label 类型错误

CrossEntropyLoss 要求：

- logits shape: `[batch, num_classes]`
- labels shape: `[batch]`
- labels dtype: long

### 12.5 Softmax 重复使用

PyTorch 的 `CrossEntropyLoss` 内部已经包含 log-softmax。

通常不要在模型最后手动加 softmax 再传给 CrossEntropyLoss。

## 13. 项目结构建议

```text
project/
├── configs/
├── data/
├── datasets/
├── models/
├── train.py
├── evaluate.py
├── infer.py
├── utils/
└── outputs/
```

建议把配置、模型、数据读取和训练逻辑分开。

## 14. 记忆重点

- Dataset 负责单样本读取，DataLoader 负责批量加载。
- 模型继承 nn.Module，并实现 forward。
- 训练时使用 model.train，验证时使用 model.eval。
- 每步训练需要 zero_grad、backward、step。
- 验证和推理要使用 no_grad。
- CrossEntropyLoss 不需要提前 softmax。
- 保存模型时推荐保存 state_dict 和实验配置。

