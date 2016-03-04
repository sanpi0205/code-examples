# -*- coding: utf-8 -*-
"""
Created on Wed Mar  2 17:25:41 2016

@author: zhangbo

代码示例来源于 scikit-learn

http://scikit-learn.org/stable/auto_examples/linear_model/plot_lasso_and_elasticnet.html#example-linear-model-plot-lasso-and-elasticnet-py

"""

import numpy as np
import matplotlib.pyplot as plt

from sklearn import  linear_model
from sklearn.metrics import r2_score

##################################
# 设定随机数种子

np.random.seed(42)

n_samples, n_features = 50, 200

X = np.random.randn(n_samples, n_features)
coef = 3 * np.random.randn(n_features)
inds = np.arange(n_features)
np.random.shuffle(inds)

#coef[inds[3:]] = 0
y = np.dot(X, coef)

# 增加误差项
y += 0.01 * np.random.randn(n_samples)

#训练集与测试集
split_point = n_samples / 2
X_train, y_train = X[:split_point], y[:split_point]
X_test, y_test = X[split_point:], y[split_point:]

#Lasso模型
alpha = 0.1
clf_lasso = linear_model.Lasso(alpha = alpha)
clf_lasso.fit(X_train, y_train)

y_hat = clf_lasso.predict(X_test)
r2_score_lasso = r2_score(y_test, y_hat)

#打印结果
print(clf_lasso)
print("lasso model r^2 on the test data is : %.4f" % r2_score_lasso)

#Elastic模型
alpha = 0.1
l1_ratio = 0.7
clf_elastic = linear_model.ElasticNet(alpha=alpha, l1_ratio=l1_ratio)
clf_elastic.fit(X_train, y_train)

y_hat_elastic = clf_elastic.predict(X_test)

r2_score_elastic = r2_score(y_test, y_hat_elastic)

print(clf_elastic)
print("elastic model r^2 on the test data is : %f" % r2_score_elastic)

plt.plot(clf_elastic.coef_, label='Elastic net coefficients')
plt.plot(clf_lasso.coef_, label='Lasso coefficients')
plt.plot(coef, '--', label='original coefficients')
plt.legend(loc='best')
plt.title("Lasso R^2: %f, Elastic Net R^2: %f" % (r2_score_lasso, r2_score_elastic))
plt.show()