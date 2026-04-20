# Transformer 与注意力机制

## 1. Transformer 的地位

Transformer 是现代深度学习的核心结构之一。

应用场景：

- NLP。
- 图像识别。
- 目标检测。
- 语音识别。
- 时间序列。
- 多模态。
- 大语言模型。

## 2. Attention 的核心思想

Attention 是一种动态加权机制。

处理当前元素时，模型会根据相关性关注输入中的不同部分。

```text
相关性高 -> 权重大
相关性低 -> 权重小
```

## 3. Q、K、V

Attention 中有三个重要向量：

- Query：查询，表示当前想找什么。
- Key：键，表示每个位置有什么。
- Value：值，表示真正要汇总的信息。

计算过程：

1. Query 和 Key 计算相似度。
2. 对相似度进行 softmax。
3. 用权重对 Value 加权求和。

## 4. Scaled Dot-Product Attention

公式：

```text
Attention(Q, K, V) = softmax(QK^T / sqrt(d_k))V
```

为什么除以 sqrt(d_k)：

- d_k 大时，点积值可能很大。
- softmax 会进入饱和区。
- 梯度会变小。

## 5. Self-Attention

Self-Attention 中 Q、K、V 来自同一个序列。

作用：

- 建模序列内部关系。
- 捕捉长距离依赖。
- 支持并行计算。

## 6. Multi-Head Attention

多头注意力并行计算多个 attention。

直观理解：

- 不同 head 可以关注不同关系。
- 最后把多个 head 的结果拼接。

优点：

- 表达能力更强。
- 能同时建模多种依赖。

## 7. 位置编码

Self-Attention 本身不包含顺序信息。

所以需要位置编码。

常见方式：

- 正弦余弦位置编码。
- 可学习位置编码。
- 相对位置编码。
- Rotary Position Embedding。

## 8. Feed Forward Network

Transformer 每层中除了 attention，还有前馈网络。

形式：

```text
Linear -> activation -> Linear
```

常用激活：

- ReLU。
- GELU。
- SwiGLU。

## 9. Add & Norm

Transformer 中常见结构：

```text
x = x + sublayer(x)
x = LayerNorm(x)
```

作用：

- 残差连接帮助梯度传播。
- LayerNorm 稳定训练。

## 10. Encoder

Encoder 由多层结构堆叠：

```text
Self-Attention
Feed Forward
```

适合理解类任务：

- 文本分类。
- 序列标注。
- 图像分类。
- 特征提取。

BERT 是 Encoder-only。

## 11. Decoder

Decoder 使用 Masked Self-Attention。

作用：

```text
当前位置不能看到未来 token
```

适合生成任务。

GPT 是 Decoder-only。

## 12. Encoder-Decoder

Encoder-Decoder 结构适合序列到序列任务。

例如：

- 机器翻译。
- 摘要生成。
- 语音识别。

Decoder 通过 cross-attention 关注 Encoder 输出。

## 13. BERT

BERT 是双向 Encoder 模型。

特点：

- 适合理解任务。
- 使用 Masked Language Modeling 预训练。
- 可用于分类、匹配、实体识别。

Fine-tuning 时通常在 `[CLS]` 表示后接分类头。

## 14. GPT

GPT 是自回归 Decoder 模型。

训练目标：

```text
根据前文预测下一个 token
```

特点：

- 适合生成。
- 使用 causal mask。
- 是大语言模型的基础结构。

## 15. ViT

Vision Transformer 把图像切成 patch。

流程：

```text
图像 -> patch -> embedding -> position embedding -> Transformer Encoder -> 分类头
```

优点：

- 建模全局关系。
- 大规模预训练下效果强。

缺点：

- 小数据上可能不如 CNN 稳定。
- 训练成本较高。

## 16. Swin Transformer

Swin Transformer 使用窗口注意力。

特点：

- 在局部窗口内计算 attention。
- 通过 shifted window 进行跨窗口信息交互。
- 计算成本比全局 ViT 更低。

常用于视觉任务 backbone。

## 17. 计算复杂度

标准 self-attention 的复杂度与序列长度平方相关。

```text
O(n^2)
```

长序列会带来：

- 显存压力。
- 计算成本高。

因此有很多高效 attention 改进。

## 18. 论文中写 Transformer 的重点

需要说明：

- 输入如何 token 化。
- embedding 维度。
- attention head 数。
- Transformer 层数。
- 位置编码方式。
- 是否使用预训练。
- fine-tune 策略。
- 计算复杂度变化。

## 19. 记忆重点

- Attention 是动态加权汇总信息。
- Q、K、V 是理解 attention 的关键。
- Multi-Head Attention 可以学习多种关系。
- Transformer 需要位置编码。
- BERT 适合理解任务，GPT 适合生成任务。
- ViT 把图像 patch 当作 token。
- 标准 attention 对长序列计算成本高。

