# -*- coding: utf-8 -*-
"""
Created on Mon Sep 19 17:09:01 2016

@author: zhangbo
"""

import dlib
import os
import dlib
import glob
from skimage import io

predictor_path = '/home/zhangbo/software/shape_predictor_68_face_landmarks.dat'
faces_file_path = '/home/zhangbo/Desktop/face/zw6.jpg'

detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor(predictor_path)

img = io.imread(faces_file_path)
dets = detector(img, 1)
kk = [x for x in dets]
shape = predictor(img, kk[0])

#人脸检测点分布: http://stackoverflow.com/questions/36310147/landmarks-detection-using-dlib
