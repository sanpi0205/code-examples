# -*- coding: utf-8 -*-
"""
Created on Wed Mar  2 06:09:08 2016

@author: zhangbo
"""

import numpy as np
from sklearn import datasets

from sklearn.linear_model import LogisticRegression

import matplotlib.pyplot as plt

digits = datasets.load_digits()

n_test = 100
X_train = digits.data[:-n_test]
X_test = digits.data[-n_test:]

y_train = digits.target[:-n_test]
y_test = digits.target[-n_test:]

clf = LogisticRegression(penalty = 'l2', C=0.1, random_state=100)

clf.fit(X_train, y_train)
clf.score(X_train, y_train)
clf.score(X_test, y_test)

train_score = np.array([])
test_score = np.array([])

#penalty_factor = 10 ** np.arange(2, -2, -0.1)
penalty_factor = np.logspace(2, -2, num=40, base=10)
for i,C in enumerate(penalty_factor):
    # 这里使用
    clf = LogisticRegression(penalty='l1', C=C, random_state=100)
    clf.fit(X_train, y_train)
    train_score = np.append(train_score, clf.score(X_train, y_train))
    test_score = np.append(test_score, clf.score(X_test, y_test))

scores = np.column_stack((train_score, test_score))
# scores = np.c_[train_score， test_score]
plt.plot(scores)
