# 协同过滤算法

协同过滤算法是推荐算法中常用的算法之一，协同过滤算法本身也多个变化，如基于基于物品的协同过滤、基于用户的协同过滤、以及Alternating Least Square (ALS)算法。
每个算法都有各自适应的场合：

1. 当用户数量的增长或基数较大，而物品基数相对稳定时，比较适用基于物品的协同过滤算法，通过构造物品相似性矩阵，给用户推荐相应的物品，如在电商的推荐中较为常见
此类算法；

2. ALS模型更加适用于分布式计算，由于其可以通过矩阵运算来实现，相比于基于梯度的优化算法，其并适用于并行计算，因而在SPARK MLlib中关于协同过滤也仅是ALS算法；

3. 基于用户的协同过滤，更加适用于具有相同兴趣的用户之间推荐物品，更加适用的场景如社交网络等用户强相关的场景。



[参考文献][参考文献]

[code][code]


[参考文献]: http://danielnee.com/2016/09/collaborative-filtering-using-alternating-least-squares/#fnref-366-1
[code]: https://github.com/danielnee/Notebooks/blob/master/ALS/ALS_Explicit.ipynb
