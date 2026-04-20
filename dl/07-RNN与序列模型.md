# RNN 与序列模型

## 1. 序列数据

序列数据具有顺序关系。

常见序列：

- 文本。
- 语音。
- 时间序列。
- 视频帧。
- 传感器数据。

序列建模要利用前后依赖关系。

## 2. RNN

RNN 全称 Recurrent Neural Network。

核心思想：

```text
当前时刻的输出依赖当前输入和上一时刻隐藏状态
```

公式：

```text
h_t = f(W_x*x_t + W_h*h_{t-1} + b)
```

其中 h_t 保存历史信息。

## 3. RNN 的问题

普通 RNN 难以处理长序列。

主要问题：

- 梯度消失。
- 梯度爆炸。
- 长距离依赖难以学习。

因此提出 LSTM 和 GRU。

## 4. LSTM

LSTM 通过门控机制控制信息流动。

核心组件：

- 遗忘门。
- 输入门。
- 输出门。
- 细胞状态。

优点：

- 能保留更长时间的信息。
- 缓解梯度消失。

缺点：

- 参数较多。
- 训练和推理比普通 RNN 慢。

## 5. GRU

GRU 是 LSTM 的简化版本。

核心门：

- 更新门。
- 重置门。

优点：

- 参数比 LSTM 少。
- 训练更快。
- 效果常常接近 LSTM。

## 6. 双向 RNN

双向 RNN 同时使用：

- 正向序列。
- 反向序列。

适合需要完整上下文的任务：

- 文本分类。
- 命名实体识别。
- 序列标注。

不适合严格实时预测，因为它需要看到未来信息。

## 7. 序列到类别

输入一个序列，输出一个类别。

例子：

- 文本情感分类。
- 故障序列分类。
- 动作识别。

做法：

- 使用最后一个隐藏状态。
- 对所有隐藏状态池化。
- 使用 attention 汇总。

## 8. 序列到序列

输入序列，输出序列。

例子：

- 机器翻译。
- 摘要生成。
- 语音识别。

经典结构：

```text
Encoder -> Decoder
```

## 9. Attention 在 RNN 中的作用

传统 Encoder-Decoder 把整个输入压缩成一个固定向量，长序列效果差。

Attention 允许 Decoder 在生成每个输出时关注输入序列的不同位置。

优点：

- 缓解信息瓶颈。
- 改善长序列建模。

## 10. 时间序列预测

时间序列任务常见形式：

- 单步预测。
- 多步预测。
- 序列分类。
- 异常检测。

注意事项：

- 不能随机打乱时间顺序做划分。
- 标准化参数只能从训练集计算。
- 特征不能使用未来信息。

## 11. Teacher Forcing

序列生成训练中，Teacher Forcing 使用真实上一时刻输出作为下一时刻输入。

优点：

- 训练更快。
- 更稳定。

缺点：

- 训练和推理不一致。
- 可能产生 exposure bias。

## 12. RNN 与 Transformer 对比

| 项目 | RNN | Transformer |
| --- | --- | --- |
| 计算方式 | 顺序递归 | 并行计算 |
| 长距离依赖 | 较难 | 较强 |
| 训练速度 | 慢 | 快 |
| 序列长度成本 | 线性递归 | attention 为平方复杂度 |
| 当前主流程度 | 较少 | 主流 |

## 13. PyTorch LSTM 示例

```python
import torch.nn as nn

class LSTMClassifier(nn.Module):
    def __init__(self, input_dim, hidden_dim, num_classes):
        super().__init__()
        self.lstm = nn.LSTM(
            input_size=input_dim,
            hidden_size=hidden_dim,
            batch_first=True,
            bidirectional=True,
        )
        self.fc = nn.Linear(hidden_dim * 2, num_classes)

    def forward(self, x):
        outputs, (h_n, c_n) = self.lstm(x)
        last = outputs[:, -1, :]
        logits = self.fc(last)
        return logits
```

## 14. 记忆重点

- RNN 用隐藏状态保存历史信息。
- 普通 RNN 难以处理长距离依赖。
- LSTM 用门控机制缓解梯度消失。
- GRU 是更简化的门控循环网络。
- 双向 RNN 能利用前后文，但不适合严格实时预测。
- Transformer 已经成为多数序列任务的主流结构。

