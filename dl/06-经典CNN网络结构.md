# 经典 CNN 网络结构

## 1. 为什么学习经典网络

经典 CNN 网络体现了深度学习模型结构演化。

学习这些网络可以理解：

- 为什么网络越来越深。
- 如何解决梯度消失。
- 如何减少参数量。
- 如何提升计算效率。
- 论文中常见 backbone 的来源。

## 2. LeNet

LeNet 是早期 CNN，主要用于手写数字识别。

结构：

```text
Conv -> Pool -> Conv -> Pool -> FC -> FC
```

意义：

- 证明卷积和池化适合图像识别。
- 奠定 CNN 基本结构。

## 3. AlexNet

AlexNet 推动深度学习在图像识别中爆发。

关键点：

- 使用 ReLU。
- 使用 Dropout。
- 使用数据增强。
- 使用 GPU 训练。
- 网络比 LeNet 更深更宽。

意义：

- 显著提升 ImageNet 图像分类效果。
- 证明深层 CNN 的强大能力。

## 4. VGG

VGG 使用大量 3x3 卷积堆叠。

特点：

- 结构规整。
- 主要使用 3x3 卷积。
- 深度较大。

为什么用多个 3x3：

- 两个 3x3 感受野接近 5x5。
- 三个 3x3 感受野接近 7x7。
- 参数更少。
- 非线性更多。

缺点：

- 参数量大。
- 计算成本高。

## 5. Inception

Inception 的思想是在同一层使用多种尺度卷积。

例如：

```text
1x1 conv
3x3 conv
5x5 conv
pooling
```

然后把结果在通道维度拼接。

作用：

- 同时捕捉不同尺度特征。
- 使用 1x1 卷积减少计算量。

## 6. ResNet

ResNet 引入残差连接，解决深层网络训练困难问题。

残差结构：

```text
y = F(x) + x
```

意义：

- 梯度更容易传播。
- 可以训练非常深的网络。
- 成为很多视觉任务的常用 backbone。

## 7. 为什么残差连接有效

没有残差时，网络需要直接学习目标映射 H(x)。

有残差后，网络学习：

```text
F(x) = H(x) - x
```

如果最优映射接近恒等映射，残差学习更容易。

## 8. DenseNet

DenseNet 让每一层都连接到后面所有层。

特点：

- 特征复用。
- 梯度传播更顺畅。
- 参数利用效率高。

缺点：

- 特征拼接导致显存占用较高。

## 9. MobileNet

MobileNet 面向移动端和轻量化部署。

核心：

- 深度可分离卷积。

优点：

- 参数少。
- 计算量低。
- 适合边缘设备。

## 10. EfficientNet

EfficientNet 提出复合缩放策略。

同时缩放：

- 网络深度。
- 网络宽度。
- 输入分辨率。

目标是在精度和效率之间取得更好平衡。

## 11. ConvNeXt

ConvNeXt 是现代化 CNN 结构。

它吸收了 Transformer 时代的一些设计经验，例如：

- 更大的卷积核。
- LayerNorm。
- GELU。
- 更现代的训练策略。

意义：

- 说明 CNN 经过现代化设计后仍然有竞争力。

## 12. 常用 Backbone 选择

图像分类：

- ResNet。
- EfficientNet。
- ConvNeXt。
- ViT。

目标检测：

- ResNet。
- ResNeXt。
- Swin Transformer。

语义分割：

- ResNet。
- HRNet。
- DeepLab 系列。
- SegFormer。

轻量部署：

- MobileNet。
- ShuffleNet。
- EfficientNet-lite。

## 13. 论文中如何描述 Backbone

写法示例：

```text
本文采用 ResNet-50 作为特征提取主干网络，并移除原始分类头，将最后一层卷积特征输入后续模块。
```

如果使用预训练模型，需要说明：

- 预训练数据集。
- 是否冻结参数。
- fine-tune 策略。
- 输入分辨率。

## 14. 网络结构对比

| 网络 | 核心思想 | 优点 | 缺点 |
| --- | --- | --- | --- |
| LeNet | 卷积 + 池化 | 简单 | 能力有限 |
| AlexNet | 深层 CNN + ReLU | 开创性强 | 参数较多 |
| VGG | 堆叠 3x3 卷积 | 结构清晰 | 计算重 |
| Inception | 多尺度卷积 | 多尺度特征 | 结构复杂 |
| ResNet | 残差连接 | 可训练很深 | 仍有计算成本 |
| DenseNet | 密集连接 | 特征复用 | 显存占用高 |
| MobileNet | 深度可分离卷积 | 轻量 | 精度可能受限 |
| EfficientNet | 复合缩放 | 精度效率平衡 | 结构调参复杂 |

## 15. 记忆重点

- LeNet 奠定 CNN 基础结构。
- AlexNet 证明深度 CNN 的效果。
- VGG 使用大量 3x3 卷积。
- Inception 使用多尺度分支。
- ResNet 的残差连接解决深层网络训练问题。
- MobileNet 用深度可分离卷积降低计算量。
- backbone 选择要考虑精度、速度、显存和任务类型。

