# KNN 与朴素贝叶斯

## 1. 为什么学习这两个模型

KNN 和朴素贝叶斯都是经典机器学习模型。

它们的价值：

- 思想简单，适合理解分类问题。
- 常作为 baseline。
- 在部分任务上仍然有效。
- 能帮助理解距离度量和概率建模。

## 2. KNN

KNN 全称 K-Nearest Neighbors，K 近邻算法。

核心思想：

```text
一个样本的类别由离它最近的 K 个训练样本决定
```

## 3. KNN 分类流程

1. 计算测试样本和所有训练样本的距离。
2. 找到距离最近的 K 个样本。
3. 统计这 K 个样本的类别。
4. 投票得到预测类别。

回归任务中，通常取 K 个邻居标签值的平均。

## 4. 距离度量

### 4.1 欧氏距离

最常用距离。

```text
d(x, y) = sqrt(sum((x_i - y_i)^2))
```

### 4.2 曼哈顿距离

```text
d(x, y) = sum(|x_i - y_i|)
```

### 4.3 余弦相似度

常用于文本向量。

关注方向相似度，而不是绝对大小。

## 5. K 的影响

K 太小：

- 模型复杂。
- 容易受噪声影响。
- 可能过拟合。

K 太大：

- 决策边界更平滑。
- 可能欠拟合。
- 少数类容易被多数类淹没。

常用方法：

- 交叉验证选择 K。
- K 通常取奇数，减少投票平局。

## 6. KNN 的优点

- 思想简单。
- 不需要显式训练过程。
- 可以处理非线性边界。
- 适合作为小数据 baseline。

## 7. KNN 的缺点

- 预测速度慢。
- 存储训练数据成本高。
- 对特征尺度敏感。
- 高维数据中距离度量效果变差。
- 对类别不平衡敏感。

## 8. KNN 使用注意

必须考虑特征缩放。

例如年龄范围是 0 到 100，收入范围是 0 到 100000，如果不标准化，收入会主导距离计算。

推荐使用 Pipeline：

```python
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier

model = Pipeline(
    steps=[
        ("scaler", StandardScaler()),
        ("knn", KNeighborsClassifier(n_neighbors=5)),
    ]
)
```

## 9. 朴素贝叶斯

朴素贝叶斯是一类基于贝叶斯公式的分类模型。

贝叶斯公式：

```text
P(y|x) = P(x|y) * P(y) / P(x)
```

分类时选择后验概率最大的类别：

```text
预测类别 = argmax P(y|x)
```

## 10. 朴素的含义

“朴素”指特征条件独立假设。

给定类别 y 后，假设各个特征相互独立：

```text
P(x1, x2, ..., xn | y) = P(x1|y) * P(x2|y) * ... * P(xn|y)
```

这个假设现实中通常不完全成立，但模型依然经常有效。

## 11. 朴素贝叶斯分类公式

因为 P(x) 对所有类别相同，分类时可以忽略：

```text
预测类别 = argmax P(y) * P(x1|y) * P(x2|y) * ... * P(xn|y)
```

实际计算中常用 log，避免概率连乘下溢：

```text
log P(y) + sum(log P(x_i|y))
```

## 12. 常见朴素贝叶斯模型

### 12.1 GaussianNB

假设连续特征服从正态分布。

适合：

- 连续数值特征。

### 12.2 MultinomialNB

适合离散计数特征。

常用于：

- 文本分类。
- 词频特征。
- TF-IDF 特征。

### 12.3 BernoulliNB

适合二值特征。

例如：

- 某个词是否出现。
- 某个事件是否发生。

## 13. 拉普拉斯平滑

如果某个词在某个类别中从未出现，概率会变成 0，导致整个类别概率为 0。

拉普拉斯平滑用于避免零概率：

```text
P = (count + alpha) / (total + alpha * 类别数)
```

alpha 通常取 1。

## 14. 朴素贝叶斯优点

- 简单快速。
- 小数据上表现稳定。
- 适合高维稀疏文本特征。
- 对缺失部分特征不太敏感。
- 可解释性较好。

## 15. 朴素贝叶斯缺点

- 条件独立假设较强。
- 特征高度相关时效果可能下降。
- 不能很好学习复杂特征交互。
- 输出概率可能校准不好。

## 16. 文本分类示例

```python
from sklearn.pipeline import Pipeline
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB

model = Pipeline(
    steps=[
        ("tfidf", TfidfVectorizer()),
        ("clf", MultinomialNB(alpha=1.0)),
    ]
)

model.fit(train_texts, train_labels)
preds = model.predict(test_texts)
```

## 17. KNN 和朴素贝叶斯对比

| 项目 | KNN | 朴素贝叶斯 |
| --- | --- | --- |
| 思想 | 看邻居 | 看概率 |
| 训练成本 | 几乎没有 | 低 |
| 预测成本 | 高 | 低 |
| 是否依赖特征缩放 | 是 | 通常不强 |
| 适合数据 | 小规模、低维 | 文本、高维稀疏 |
| 主要问题 | 高维距离失效 | 条件独立假设过强 |

## 18. 论文中如何使用

KNN 和朴素贝叶斯通常适合作为 baseline。

论文写法可以是：

```text
为验证所提方法的有效性，本文选取 KNN、朴素贝叶斯、逻辑回归、随机森林等传统方法作为对比基线。
```

注意：

- baseline 要使用合理参数。
- 不能故意让 baseline 很弱。
- 所有方法应使用相同训练集和测试集。

## 19. 记忆重点

- KNN 基于距离，必须重视特征缩放。
- K 越小模型越复杂，K 越大模型越平滑。
- 朴素贝叶斯基于贝叶斯公式。
- 朴素贝叶斯的核心假设是特征条件独立。
- MultinomialNB 常用于文本分类。
- 拉普拉斯平滑用于避免零概率。

