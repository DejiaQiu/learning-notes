# Transformer 与注意力机制

## 1. 为什么学习 Transformer

Transformer 是现代深度学习的重要基础。

它广泛用于：

- 自然语言处理。
- 计算机视觉。
- 多模态学习。
- 时间序列建模。
- 大模型。

如果研究生论文涉及深度学习，Transformer 和 Attention 通常需要掌握。

## 2. Attention 的直观理解

Attention 的核心思想：

```text
在处理当前信息时，动态关注输入中最相关的部分
```

例如机器翻译中，翻译当前词时，模型会关注源句中相关词。

图像任务中，模型可以关注关键区域。

## 3. Query、Key、Value

Attention 中每个输入会映射成三个向量：

- Query：我要找什么。
- Key：我有什么特征。
- Value：真正要汇总的信息。

计算过程：

1. Query 和 Key 计算相似度。
2. 对相似度做 softmax 得到权重。
3. 用权重对 Value 加权求和。

## 4. Scaled Dot-Product Attention

公式：

```text
Attention(Q, K, V) = softmax(QK^T / sqrt(d_k)) V
```

其中：

- Q 是 Query 矩阵。
- K 是 Key 矩阵。
- V 是 Value 矩阵。
- d_k 是 Key 向量维度。

除以 sqrt(d_k) 是为了避免点积过大导致 softmax 梯度太小。

## 5. Self-Attention

Self-Attention 指 Q、K、V 都来自同一个序列。

作用：

- 建模序列内部元素之间的关系。
- 捕捉长距离依赖。
- 不需要像 RNN 那样按顺序递归计算。

例如句子：

```text
我 喜欢 机器 学习
```

每个词都可以关注句子中的其他词。

## 6. Multi-Head Attention

多头注意力会并行计算多个 attention。

直观理解：

```text
不同 head 学习不同关系
```

例如：

- 一个 head 关注语法关系。
- 一个 head 关注语义关系。
- 一个 head 关注局部邻近关系。

最后把多个 head 的结果拼接，再做线性变换。

## 7. 位置编码

Self-Attention 本身不包含顺序信息。

所以 Transformer 需要加入位置编码。

常见方式：

- 正弦余弦位置编码。
- 可学习位置编码。
- 相对位置编码。

位置编码告诉模型 token 在序列中的位置。

## 8. Transformer Encoder

Encoder 主要由以下部分组成：

- Multi-Head Self-Attention。
- Add & Norm。
- Feed Forward Network。
- Add & Norm。

Encoder 适合：

- 文本分类。
- 序列标注。
- 表征学习。
- BERT 类模型。

## 9. Transformer Decoder

Decoder 主要用于生成任务。

比 Encoder 多一个 Masked Self-Attention。

Masked Self-Attention 的作用：

```text
生成当前位置时，不能看到未来 token
```

Decoder 适合：

- 文本生成。
- 机器翻译解码。
- GPT 类模型。

## 10. Encoder-Decoder 结构

Encoder-Decoder Transformer 用于输入序列到输出序列的任务。

典型任务：

- 机器翻译。
- 摘要生成。
- 语音识别。

结构：

```text
输入序列 -> Encoder -> 编码表示 -> Decoder -> 输出序列
```

## 11. BERT

BERT 是 Encoder-only 模型。

特点：

- 双向上下文建模。
- 适合理解任务。
- 常用于分类、匹配、实体识别。

预训练任务：

- Masked Language Modeling。
- Next Sentence Prediction。

## 12. GPT

GPT 是 Decoder-only 模型。

特点：

- 自回归生成。
- 适合文本生成。
- 每次预测下一个 token。

训练目标：

```text
根据前文预测下一个 token
```

## 13. Vision Transformer

Vision Transformer（ViT）把图像切成 patch，再当作 token 输入 Transformer。

流程：

1. 图像切成固定大小 patch。
2. 每个 patch 映射成向量。
3. 加入位置编码。
4. 输入 Transformer Encoder。
5. 用分类 token 或平均池化做分类。

优点：

- 能建模全局关系。
- 大数据预训练下效果强。

缺点：

- 对数据量要求较高。
- 小数据上通常不如 CNN 稳。

## 14. Transformer 优点

- 能捕捉长距离依赖。
- 并行计算能力强。
- 可扩展性好。
- 适用于文本、图像、语音、多模态。

## 15. Transformer 缺点

- 计算复杂度随序列长度平方增长。
- 需要较多数据和计算资源。
- 对位置编码和训练设置较敏感。
- 可解释性仍有限。

## 16. Attention 和 CNN 对比

| 项目 | CNN | Transformer |
| --- | --- | --- |
| 关注范围 | 局部感受野逐渐扩大 | 可直接建模全局关系 |
| 归纳偏置 | 强，适合图像局部结构 | 弱，更依赖数据 |
| 并行能力 | 强 | 强 |
| 数据需求 | 相对较低 | 通常较高 |
| 常见任务 | 图像 | 文本、多模态、图像 |

## 17. 论文中如何使用 Transformer

常见研究方式：

- 用预训练 Transformer 做特征提取。
- 在任务数据上 fine-tune。
- 加入注意力模块改进 CNN。
- 设计轻量化 Transformer。
- 做 CNN + Transformer 混合结构。

论文中需要说明：

- 输入如何变成 token。
- 位置编码如何设计。
- attention 模块放在哪里。
- 和 CNN、RNN、传统模型相比优势是什么。
- 计算成本是否增加。

## 18. 记忆重点

- Attention 是动态加权汇总相关信息。
- Q、K、V 分别表示查询、键和值。
- Self-Attention 建模序列内部关系。
- Multi-Head Attention 让模型学习多种关系。
- Transformer 需要位置编码。
- BERT 是 Encoder-only，适合理解任务。
- GPT 是 Decoder-only，适合生成任务。
- ViT 把图像 patch 当 token。

