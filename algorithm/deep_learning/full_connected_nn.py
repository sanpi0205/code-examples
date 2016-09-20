# -*- coding: utf-8 -*-

import mxnet as mx
import numpy as np
import cv2

import matplotlib.pyplot as plt
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

#reference:
#https://github.com/dmlc/mxnet-gtc-tutorial/blob/master/tutorial.ipynb

#define the model
data = mx.symbol.Variable('data')
#first full connected layer with the formula y = wx + b
#where y stands for the first hiden layer units which is about 128 
#and the raw input of image have 784 input variable or dimension
fc1 = mx.symbol.FullyConnected(data=data, name='fc1', num_hidden=128)

#first layer's activation function
#here we use relu activation fuction which is y = max(X, 0)
act1 = mx.symbol.Activation(data=fc1, name='relu1', act_type='relu')

#second layer's defination
fc2 = mx.symbol.FullyConnected(data=act1, name='fc2', num_hidden=64)
act2 = mx.symbol.Activation(data=fc2, name='relu2', act_type='relu')

#third layer
fc3 = mx.symbol.FullyConnected(data=act2, name='fc3', num_hidden=10)

#output layer
mlp = mx.symbol.SoftmaxOutput(data=fc3, name='softmax')

mx.viz.plot_network(mlp)


#load the data
from sklearn.datasets import fetch_mldata
mnist = fetch_mldata('MNIST original')

#random permutation array
np.random.seed(1234)
p = np.random.permutation(mnist.data.shape[0])

#new X and Y for the model
X = mnist.data[p]
Y = mnist.target[p]

#change the type of the data
#the default is int type, but in hte model training process
#we need the float type

#rescale the data into [0, 1]
X = X.astype(np.float32) / 255

train_X = X[:60000]
train_Y = Y[:60000]

test_X = X[60000:]
test_Y = Y[60000:]

#create a batch of data
batch_size = 100
train_iteration = mx.io.NDArrayIter(train_X, train_Y, batch_size=batch_size)
test_iteration = mx.io.NDArrayIter(test_X, test_Y, batch_size=batch_size)


#training the model
#train the feed forward neural network
model = mx.model.FeedForward(symbol=mlp, ctx=mx.gpu(0), num_epoch=10,
                             learning_rate=0.1, momentum=0.9, wd=0.00001)
                             
model.fit(X=train_iteration, eval_data=test_iteration,
          batch_end_callback=mx.callback.Speedometer(batch_size, 200))


#test the 
plt.imshow((test_X[0].reshape((28,28))*255).astype(np.uint8), cmap='Greys_r')
plt.show()
print 'Result:', model.predict(test_X[0:1])[0].argmax()

#the overall error rate on test data set
model.score(test_iteration)

