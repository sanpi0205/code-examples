#!/usr/bin/python 
# -*- coding: utf8 -*-

import matplotlib.pyplot as plt
import numpy as np 
from sklearn.linear_model import MultiTaskLasso

rng = np.random.RandomState(42)

n_samples, n_features, n_tasks = 100, 30, 40
n_relevant_features = 5
coef = np.zeros((n_tasks, n_features))
#print coef.shape
times = np.linspace(0, 2*np.pi, n_tasks)
for k in range(n_relevant_features):
	coef[:, k] = np.sin(1. + rng.randn(1)) * times + 3 * rng.randn(1)
	
