#!/usr/bin/python 
# -*- coding: utf8 -*-

import numpy as np
import matplotlib.pyplot as plt 
from sklearn import linear_model

X = 1. /(np.arange(1, 11) + np.arange(0, 10)[:, np.newaxis])
y = np.ones(10)

n_alpha = 200
alphas = np.logspace(-10, 2, n_alpha)
clf = linear_model.Ridge(fit_intercept=False)

coefs = []
for a in alphas:
	clf.set_params(alpha = a)
	clf.fit(X, y)
	coefs.append(clf.coef_)

#print coefs

ax = plt.gca()
ax.set_color_cycle(['b', 'r', 'g', 'c', 'k', 'y', 'm'])

ax.plot(alphas, coefs)
ax.set_xscale('log')
ax.set_xlim(ax.get_xlim()[::-1])  # reverse axis
plt.xlabel('alpha')
plt.ylabel('weights')
plt.title('Ridge coefficients as a function of the regularization')
plt.axis('tight')
plt.show()
