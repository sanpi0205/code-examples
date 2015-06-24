############################################################
## 不同方法比较
#机器学习方法

# 读取数据
w = read.table('mg')
wd = NULL
wd = cbind(wd, w[,1])
# 处理原始数据，使之成为data.frame格式
for(i in 2:7){
  a = w[,i]
  a = as.character(a)
  z = strsplit(a,":")
  n = length(z)
  tmp = NULL
  for(j in 1:n){
    tmp = c(tmp,as.double( z[[j]][2] ) )
  }
  wd = cbind(wd, tmp)
}
colnames(wd)=c('y',paste('x',1:6,sep = ""))
wd = as.data.frame(wd)
##  注意此时数据是经过标准化处理后的数据
##  当然也可以是非标准化数据，需要格外注意

# 构造训练集与测试集
n = dim(wd)[1] # n 为数据量
zz1 = 1:n  #所有数据下标
k = 5 # 五折交叉验证
zz2 = rep(1:k, ceiling(n/k))[1:n]
set.seed(444)
zz2 = sample(zz2, n)

# 方法比较
training_NMSE = NULL # 记录不同方法训练集NMSE
testing_NMSE = NULL  # 记录不同方法测试集NMSE

## 方法1：简单线性回归
MSE1 = rep(0, k) # k fold validation 训练集 MSE
MSE2 = MSE1     # 记录 k fold 模型测试集 MSE
for(i in 1:k){
  m = zz1[zz2==i]  #测试集下标，建模型时不使用这部分数据
  # 模型部分，这部分为简单线性模型
  a = lm(y~., wd[-m,]) 
  y1 = predict(a, wd[-m,]) # 训练集yhat，即训练集y的预测值
  y2 = predict(a, wd[m,])  # 测试集yhat，即测试集y的预测值
  # 训练集MSE
  MSE1[i] = sum( (wd$y[-m]-y1)^2 ) / sum( ( wd$y[-m]-mean(wd$y[-m]) )^2 )
  # 测试集MSE
  MSE2[i] = sum( (wd$y[m]-y2)^2 ) / sum( ( wd$y[m]-mean(wd$y[m]) )^2 )
}
# 将该方法结果保存于 NMSE 中
training_NMSE = c(training_NMSE, mean(MSE1))
testing_NMSE = c(testing_NMSE, mean(MSE2))

## 方法2：决策树
library('rpart')
MSE1 = rep(0, k) # k fold validation 训练集 MSE
MSE2 = MSE1     # 记录 k fold 模型测试集 MSE
for(i in 1:k){
  m = zz1[zz2==i]  #测试集下标，建模型时不使用这部分数据
  # 模型部分，决策树
  a = rpart(y~., wd[-m,]) 
  y1 = predict(a, wd[-m,]) # 训练集yhat，即训练集y的预测值
  y2 = predict(a, wd[m,])  # 测试集yhat，即测试集y的预测值
  # 训练集MSE
  MSE1[i] = sum( (wd$y[-m]-y1)^2 ) / sum( ( wd$y[-m]-mean(wd$y[-m]) )^2 )
  # 测试集MSE
  MSE2[i] = sum( (wd$y[m]-y2)^2 ) / sum( ( wd$y[m]-mean(wd$y[m]) )^2 )
}
# 将该方法结果保存于 NMSE 中
training_NMSE = c(training_NMSE, mean(MSE1))
testing_NMSE = c(testing_NMSE, mean(MSE2))

## 方法3：boosting方法
library('party')
library('mboost')
MSE1 = rep(0, k) # k fold validation 训练集 MSE
MSE2 = MSE1     # 记录 k fold 模型测试集 MSE
for(i in 1:k){
  m = zz1[zz2==i]  #测试集下标，建模型时不使用这部分数据
  # 模型部分，boosting方法 基本学习器为 决策树
  a = mboost(y~btree(x1,x2,x3,x4,x5,x6), wd[-m,]) 
  y1 = predict(a, wd[-m,]) # 训练集yhat，即训练集y的预测值
  y2 = predict(a, wd[m,])  # 测试集yhat，即测试集y的预测值
  # 训练集MSE
  MSE1[  i] = sum( (wd$y[-m]-y1)^2 ) / sum( ( wd$y[-m]-mean(wd$y[-m]) )^2 )
  # 测试集MSE
  MSE2[i] = sum( (wd$y[m]-y2)^2 ) / sum( ( wd$y[m]-mean(wd$y[m]) )^2 )
}
# 将该方法结果保存于 NMSE 中
training_NMSE = c(training_NMSE, mean(MSE1))
testing_NMSE = c(testing_NMSE, mean(MSE2))

## 方法4：bagging方法
library('ipred')
MSE1 = rep(0, k) # k fold validation 训练集 MSE
MSE2 = MSE1     # 记录 k fold 模型测试集 MSE
for(i in 1:k){
  m = zz1[zz2==i]  #测试集下标，建模型时不使用这部分数据
  # 模型部分，boosting方法 基本学习器为 决策树
  a = bagging(y~., data=wd[-m,], coob=TRUE) 
  y1 = predict(a, wd[-m,]) # 训练集yhat，即训练集y的预测值
  y2 = predict(a, wd[m,])  # 测试集yhat，即测试集y的预测值
  # 训练集MSE
  MSE1[  i] = sum( (wd$y[-m]-y1)^2 ) / sum( ( wd$y[-m]-mean(wd$y[-m]) )^2 )
  # 测试集MSE
  MSE2[i] = sum( (wd$y[m]-y2)^2 ) / sum( ( wd$y[m]-mean(wd$y[m]) )^2 )
}
# 将该方法结果保存于 NMSE 中
training_NMSE = c(training_NMSE, mean(MSE1))
testing_NMSE = c(testing_NMSE, mean(MSE2))

## 方法5：random forest 方法
library('randomForest')
MSE1 = rep(0, k) # k fold validation 训练集 MSE
MSE2 = MSE1     # 记录 k fold 模型测试集 MSE
for(i in 1:k){
  m = zz1[zz2==i]  #测试集下标，建模型时不使用这部分数据
  # 模型部分，boosting方法 基本学习器为 决策树
  a = randomForest(y~., data=wd[-m,], importance=TRUE, proximity=TRUE) 
  y1 = predict(a, wd[-m,]) # 训练集yhat，即训练集y的预测值
  y2 = predict(a, wd[m,])  # 测试集yhat，即测试集y的预测值
  # 训练集MSE
  MSE1[  i] = sum( (wd$y[-m]-y1)^2 ) / sum( ( wd$y[-m]-mean(wd$y[-m]) )^2 )
  # 测试集MSE
  MSE2[i] = sum( (wd$y[m]-y2)^2 ) / sum( ( wd$y[m]-mean(wd$y[m]) )^2 )
}
# 将该方法结果保存于 NMSE 中
training_NMSE = c(training_NMSE, mean(MSE1))
testing_NMSE = c(testing_NMSE, mean(MSE2))

## 方法6：神经网络方法
library('nnet')
MSE1 = rep(0, k) # k fold validation 训练集 MSE
MSE2 = MSE1     # 记录 k fold 模型测试集 MSE
for(i in 1:k){
  m = zz1[zz2==i]  #测试集下标，建模型时不使用这部分数据
  # 模型部分，boosting方法 基本学习器为 决策树
  a = nnet(y~., data=wd[-m,], size=5, rang=0.1, decay = 5e-4, maxit = 200) 
  y1 = predict(a, wd[-m,]) # 训练集yhat，即训练集y的预测值
  y2 = predict(a, wd[m,])  # 测试集yhat，即测试集y的预测值
  # 训练集MSE
  MSE1[  i] = sum( (wd$y[-m]-y1)^2 ) / sum( ( wd$y[-m]-mean(wd$y[-m]) )^2 )
  # 测试集MSE
  MSE2[i] = sum( (wd$y[m]-y2)^2 ) / sum( ( wd$y[m]-mean(wd$y[m]) )^2 )
}
# 将该方法结果保存于 NMSE 中
training_NMSE = c(training_NMSE, mean(MSE1))
testing_NMSE = c(testing_NMSE, mean(MSE2))

## 方法7：支持向量机
library('rminer')
MSE1 = rep(0, k) # k fold validation 训练集 MSE
MSE2 = MSE1     # 记录 k fold 模型测试集 MSE
for(i in 1:k){
  m = zz1[zz2==i]  #测试集下标，建模型时不使用这部分数据
  # 模型部分，boosting方法 基本学习器为 决策树
  a = fit(y~., data=wd[-m,], model='svm' ) 
  y1 = predict(a, wd[-m,]) # 训练集yhat，即训练集y的预测值
  y2 = predict(a, wd[m,])  # 测试集yhat，即测试集y的预测值
  # 训练集MSE
  MSE1[  i] = sum( (wd$y[-m]-y1)^2 ) / sum( ( wd$y[-m]-mean(wd$y[-m]) )^2 )
  # 测试集MSE
  MSE2[i] = sum( (wd$y[m]-y2)^2 ) / sum( ( wd$y[m]-mean(wd$y[m]) )^2 )
}
# 将该方法结果保存于 NMSE 中
training_NMSE = c(training_NMSE, mean(MSE1))
testing_NMSE = c(testing_NMSE, mean(MSE2))

# 方法比较
res = data.frame(train = training_NMSE, test = testing_NMSE)
row.names(res) = c('linear','tree','boosting','bagging','randomForest','NNet','SVM')
res
barplot(t(res),beside = T)
