# CNN 卷积神经网络与池化

## 1. CNN 是什么

CNN 全称 Convolutional Neural Network，卷积神经网络。

它特别适合处理具有空间结构的数据，例如：

- 图像。
- 视频帧。
- 医学影像。
- 遥感图像。

CNN 的核心组件：

- 卷积层。
- 激活函数。
- 池化层。
- 全连接层。

## 2. 为什么图像适合 CNN

图像具有局部相关性：

- 相邻像素之间关系强。
- 局部纹理和边缘很重要。
- 同一个特征可能出现在图像不同位置。

CNN 利用两个重要思想：

- 局部连接。
- 权重共享。

## 3. 卷积

卷积层使用卷积核在图像上滑动，提取局部特征。

卷积核可以学习：

- 边缘。
- 角点。
- 纹理。
- 局部形状。

浅层卷积通常学习低级特征，深层卷积学习更抽象的语义特征。

## 4. 卷积核

卷积核也叫 filter 或 kernel。

例如一个 3x3 卷积核：

```text
1 0 -1
1 0 -1
1 0 -1
```

这个卷积核可能对垂直边缘敏感。

实际 CNN 中，卷积核参数是训练出来的。

## 5. 通道

彩色图像通常有 3 个通道：

```text
H x W x C
高度 x 宽度 x 通道数
```

例如：

```text
224 x 224 x 3
```

卷积层输出的通道数等于卷积核个数。

如果一个卷积层有 64 个卷积核，输出 feature map 就有 64 个通道。

## 6. stride

stride 表示卷积核每次滑动的步长。

```text
stride = 1：每次移动 1 个像素
stride = 2：每次移动 2 个像素
```

stride 越大，输出尺寸越小，计算量越低，但信息损失也更大。

## 7. padding

padding 是在图像边缘补值。

常见类型：

- valid padding：不补边，输出尺寸变小。
- same padding：补边，让输出尺寸尽量保持不变。

padding 的作用：

- 控制输出尺寸。
- 保留边缘信息。
- 让网络可以堆叠更多卷积层。

## 8. 输出尺寸计算

对于输入尺寸 W，卷积核大小 F，padding P，stride S：

```text
输出尺寸 = floor((W - F + 2P) / S) + 1
```

例如：

```text
输入 32x32
卷积核 3x3
padding = 1
stride = 1

输出 = (32 - 3 + 2*1) / 1 + 1 = 32
```

## 9. 感受野

感受野表示输出特征中的一个位置能看到输入图像中的多大区域。

网络越深，感受野通常越大。

浅层关注局部细节，深层关注更大范围的语义。

## 10. 池化

池化用于下采样，减少特征图尺寸和计算量。

池化层通常没有可学习参数。

常见池化：

- 最大池化 Max Pooling。
- 平均池化 Average Pooling。
- 全局平均池化 Global Average Pooling。

## 11. 最大池化

最大池化取局部窗口中的最大值。

例子：

```text
2x2 max pooling

1 3
2 4

输出 4
```

作用：

- 保留最显著特征。
- 减少特征图尺寸。
- 增强一定的平移不变性。

## 12. 平均池化

平均池化取局部窗口中的平均值。

例子：

```text
2x2 average pooling

1 3
2 4

输出 2.5
```

特点：

- 更平滑。
- 保留整体统计信息。

## 13. 全局平均池化

Global Average Pooling 对每个通道的整个特征图求平均。

例如输入：

```text
7 x 7 x 512
```

经过全局平均池化后：

```text
1 x 1 x 512
```

优点：

- 减少参数量。
- 降低过拟合。
- 常用于替代全连接层。

## 14. 池化的作用

池化主要作用：

- 降低空间尺寸。
- 减少计算量。
- 减少参数量。
- 扩大后续层感受野。
- 提供一定的平移不变性。

注意：

- 池化会丢失位置信息。
- 现代 CNN 有时用 stride convolution 替代池化。

## 15. 卷积层和全连接层对比

| 项目 | 卷积层 | 全连接层 |
| --- | --- | --- |
| 连接方式 | 局部连接 | 全部连接 |
| 权重共享 | 是 | 否 |
| 参数量 | 少 | 多 |
| 适合数据 | 图像、空间结构数据 | 普通向量 |
| 是否保留空间结构 | 保留 | 通常打平后丢失 |

## 16. 常见 CNN 结构

### 16.1 LeNet

早期 CNN，常用于手写数字识别。

结构特点：

- 卷积。
- 池化。
- 全连接。

### 16.2 AlexNet

推动深度学习在图像任务中爆发。

特点：

- ReLU。
- Dropout。
- 数据增强。
- GPU 训练。

### 16.3 VGG

使用大量 3x3 卷积堆叠。

特点：

- 结构规整。
- 参数量大。
- 容易理解。

### 16.4 ResNet

引入残差连接，解决深层网络训练困难问题。

核心：

```text
输出 = F(x) + x
```

残差连接让梯度更容易传播。

## 17. CNN 示例

```python
import torch
import torch.nn as nn

class SimpleCNN(nn.Module):
    def __init__(self, num_classes):
        super().__init__()
        self.features = nn.Sequential(
            nn.Conv2d(3, 32, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2),
            nn.Conv2d(32, 64, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2),
        )
        self.classifier = nn.Sequential(
            nn.Flatten(),
            nn.Linear(64 * 56 * 56, 128),
            nn.ReLU(),
            nn.Linear(128, num_classes),
        )

    def forward(self, x):
        x = self.features(x)
        x = self.classifier(x)
        return x
```

如果输入是 224x224，经过两次 2x2 max pooling 后，空间尺寸变成 56x56。

## 18. 常见问题

### 18.1 为什么 3x3 卷积常用

原因：

- 参数量较小。
- 多个 3x3 堆叠可以获得更大感受野。
- 增加非线性层数。

两个 3x3 卷积的感受野相当于一个 5x5，但参数更少。

### 18.2 池化会不会损失信息

会。池化本质是下采样，一定会丢失部分细节。

但它能降低计算量，并保留主要特征。

### 18.3 stride convolution 和 pooling 的区别

stride convolution 有可学习参数，可以学习如何下采样。

pooling 没有可学习参数，规则固定。

## 19. 记忆重点

- CNN 适合图像，因为它利用局部连接和权重共享。
- 卷积核用于提取局部特征。
- stride 控制滑动步长。
- padding 控制边缘和输出尺寸。
- 池化用于下采样，减少计算量。
- 最大池化保留最显著特征。
- 全局平均池化常用于减少全连接层参数。
- ResNet 的残差连接缓解深层网络训练困难。

