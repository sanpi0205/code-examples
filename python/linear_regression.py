#coding=utf-8
#!/usr/bin/python 

# python线性回归

from sklearn import datasets
from sklearn.cross_validation import cross_val_predict
from sklearn import linear_model
from ggplot import *
import pandas as pd

lr = linear_model.LinearRegression()
boston = datasets.load_boston()
y = boston.target

predicted = cross_val_predict(lr, boston.data, y, cv=5)

res = pd.DataFrame({'y':y, 'pre':predicted})
print ggplot(res, aes('y', 'pre')) + geom_point() + xlab('Measured') + ylab('Predicted')

