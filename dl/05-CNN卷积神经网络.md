# CNN 卷积神经网络

## 1. CNN 适合什么任务

CNN 适合处理具有局部空间结构的数据。

常见任务：

- 图像分类。
- 目标检测。
- 语义分割。
- 医学影像分析。
- 遥感图像识别。
- 视频帧特征提取。

## 2. CNN 的核心思想

CNN 利用：

- 局部连接。
- 权重共享。
- 层级特征提取。

浅层卷积学习边缘、纹理等低级特征。

深层卷积学习形状、部件和语义特征。

## 3. 卷积层

卷积核在输入特征图上滑动，提取局部特征。

输入：

```text
N x C_in x H x W
```

输出：

```text
N x C_out x H_out x W_out
```

其中 C_out 等于卷积核个数。

## 4. 卷积参数

重要参数：

- kernel_size：卷积核大小。
- stride：步长。
- padding：边缘填充。
- dilation：空洞率。
- groups：分组卷积。

## 5. 输出尺寸

对于输入尺寸 W，卷积核 F，padding P，stride S：

```text
输出尺寸 = floor((W - F + 2P) / S) + 1
```

如果：

```text
W = 32, F = 3, P = 1, S = 1
```

则输出尺寸仍为 32。

## 6. Padding

padding 的作用：

- 控制输出尺寸。
- 保留边缘信息。
- 允许堆叠更多卷积层。

常见设置：

```text
3x3 卷积，padding = 1
5x5 卷积，padding = 2
```

## 7. Stride

stride 控制卷积核移动步长。

stride 越大：

- 输出尺寸越小。
- 计算量越低。
- 信息损失越多。

stride convolution 可以替代部分池化层。

## 8. 池化

池化用于下采样。

常见池化：

- Max Pooling。
- Average Pooling。
- Global Average Pooling。

作用：

- 降低空间尺寸。
- 减少计算量。
- 增大感受野。
- 提供一定平移不变性。

## 9. 最大池化

最大池化取局部窗口最大值。

适合保留最显著特征。

```text
2x2 window:
1 3
2 4

max pooling -> 4
```

## 10. 全局平均池化

Global Average Pooling 对每个通道整张特征图求平均。

例如：

```text
7 x 7 x 512 -> 1 x 1 x 512
```

优点：

- 减少参数量。
- 降低过拟合。
- 常用于分类头。

## 11. 感受野

感受野表示输出特征中一个位置对应输入图像的区域大小。

网络越深，感受野通常越大。

增加感受野的方法：

- 堆叠卷积层。
- 使用 pooling。
- 使用 stride convolution。
- 使用 dilated convolution。

## 12. 1x1 卷积

1x1 卷积常用于通道变换。

作用：

- 降维。
- 升维。
- 融合通道信息。
- 减少计算量。

ResNet bottleneck、Inception、MobileNet 中经常使用 1x1 卷积。

## 13. 空洞卷积

空洞卷积在卷积核元素之间插入间隔。

作用：

- 不增加参数量的情况下扩大感受野。

常用于：

- 语义分割。
- 密集预测任务。

## 14. 深度可分离卷积

Depthwise Separable Convolution 把普通卷积分成：

1. Depthwise convolution：每个通道单独卷积。
2. Pointwise convolution：1x1 卷积融合通道。

优点：

- 大幅减少参数量和计算量。

常用于 MobileNet。

## 15. CNN 分类模型基本结构

```text
输入图像
-> 多层 Conv + BN + ReLU
-> 下采样
-> 全局平均池化
-> 全连接层
-> Softmax
```

## 16. PyTorch 示例

```python
import torch.nn as nn

class SimpleCNN(nn.Module):
    def __init__(self, num_classes):
        super().__init__()
        self.features = nn.Sequential(
            nn.Conv2d(3, 32, kernel_size=3, padding=1),
            nn.BatchNorm2d(32),
            nn.ReLU(),
            nn.MaxPool2d(2),
            nn.Conv2d(32, 64, kernel_size=3, padding=1),
            nn.BatchNorm2d(64),
            nn.ReLU(),
            nn.MaxPool2d(2),
        )
        self.classifier = nn.Sequential(
            nn.AdaptiveAvgPool2d((1, 1)),
            nn.Flatten(),
            nn.Linear(64, num_classes),
        )

    def forward(self, x):
        x = self.features(x)
        x = self.classifier(x)
        return x
```

## 17. 记忆重点

- CNN 利用局部连接和权重共享。
- 卷积核个数决定输出通道数。
- padding 控制边缘和输出尺寸。
- stride 控制下采样。
- pooling 减少尺寸和计算量。
- 1x1 卷积用于通道变换。
- 深度可分离卷积可以显著减少计算量。

