# -*- coding: utf-8 -*-
"""
Created on Fri Mar  4 12:29:39 2016

@author: zhangbo

代码示例来源于 scikit-learn

http://scikit-learn.org/stable/auto_examples/linear_model/plot_lasso_model_selection.html#example-linear-model-plot-lasso-model-selection-py

在sklearn中Lasso算法的默认解法是coordinate descent,
而Lasso的另一个解法来源于Lars算法（最小角度回归）

本示例中以diabetes数据为例

"""

import numpy as np
from sklearn import linear_model
from sklearn import datasets
import matplotlib.pyplot as plt

# 提取数据
diabetes = datasets.load_diabetes()
X = diabetes.data
y = diabetes.target

n_samples, n_features = X.shape

# 设定随机种子
rng = np.random.RandomState(42)


