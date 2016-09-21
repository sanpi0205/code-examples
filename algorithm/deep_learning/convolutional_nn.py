# -*- coding: utf-8 -*-

import mxnet as mx
import numpy as np
import cv2

import matplotlib.pyplot as plt
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

''' the code is an example for 
convolutional deep neural network
the code is for 3d convolution and 3d pooling

'''

#reference:
#https://github.com/dmlc/mxnet/blob/master/example/image-classification/train_mnist.py

#define the model
data = mx.symbol.Variable('data')

#the first layer of convolution with default stride=1
conv1 = mx.symbol.Convolution(data=data, kernel=(5,5), num_filter=20)
act1 = mx.symbol.Activation(data=conv1, act_type='relu')
pool1 = mx.symbol.Pooling(data=act1, pool_type='max', kernel=(2,2), stride=(2,2))

#the second convolutional
conv2 = mx.symbol.Convolution(data=pool1, kernel=(2,2), num_filter=50)
act2 = mx.symbol.Activation(data=conv2, act_type='relu')
pool2 = mx.symbol.Pooling(data=act2, pool_type='max', kernel=(2,2), stride=(2,2))

#flatten the 3d pooling layer
flatten = mx.symbol.Flatten(data=pool2)
#first fully connected layer
fc1 = mx.symbol.FullyConnected(data=flatten, num_hidden=500)
act3 = mx.symbol.Activation(data=fc1, act_type='relu')

#second fully connected layer
fc2 = mx.symbol.FullyConnected(data=act3, num_hidden=10)

#output layer
conv_nn = mx.symbol.SoftmaxOutput(data=fc2, name='softmax')


#mx.viz.plot_network(conv_nn)


#load the data
train_set = mx.io.MNISTIter(image='../../data/mnist/train-images-idx3-ubyte',
                            label='../../data/mnist/train-labels-idx1-ubyte',
                            flat=False)

test_set = mx.io.MNISTIter(image='../../data/mnist/t10k-images-idx3-ubyte',
                           label='../../data/mnist/t10k-labels-idx1-ubyte',
                           flat=False)

#create a batch of data
batch_size = 100


#training the model
#train the feed forward neural network
model = mx.model.FeedForward(symbol=conv_nn, ctx=mx.gpu(0), num_epoch=10,
                             learning_rate=0.1, momentum=0.9, wd=0.00001)
                             
model.fit(X=train_set, eval_data=test_set,
          batch_end_callback=mx.callback.Speedometer(batch_size, 200))


'''something need to do next
1. load different type of input and transform it into the a suitable format 
2. save a model that could by load into a classify enginy
3. further more, build a web service for fun
'''
