#!/usr/bin/python 
# -*- coding: utf8 -*-


# python线性回归

from sklearn import datasets, linear_model
from sklearn.cross_validation import cross_val_predict
from ggplot import *
import numpy as np
import pandas as pd


lr = linear_model.LinearRegression()
boston = datasets.load_boston()
y = boston.target

predicted = cross_val_predict(lr, boston.data, y, cv=5)

res = pd.DataFrame({'y':y, 'pre':predicted})
# print ggplot(res, aes('y', 'pre')) + geom_point() + xlab('Measured') + ylab('Predicted')

# 另一例： http://scikit-learn.org/stable/auto_examples/linear_model/plot_ols.html#example-linear-model-plot-ols-py
# 加载数据
import matplotlib.pyplot as plt

diabetes = datasets.load_diabetes()
print("X的维度为: ")
print(diabetes.data.shape)

# 建立模型
model = linear_model.LinearRegression()
model.fit(diabetes.data, diabetes.target)

print('Coefficients: \n', model.coef_)
print("Residual sum of squares: %.2f"
      % np.mean((model.predict(diabetes.data) - diabetes.target) ** 2))

# 作图输出
#plt.scatter(diabetes.data[:,1], diabetes.target,  color='black')
plt.plot(diabetes.target, model.predict(diabetes.data), color='blue', linewidth=3)
plt.xticks(())
plt.yticks(())
plt.show()
