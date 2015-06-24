## chapter2 简单线性回归
w=read.table("cofreewy.txt",header=T)
a=lm(CO~.,w) # 简单线性回归
summary(a)   # 展示结果

b=step(a, direction="backward")  # 逐步向后回归
summary(b)

pairs(w)  # 观察变量两两之间的关系

attach(w)
zz = cbind(CO, Traffic, Tsq=Traffic^2, Tcub=Traffic^3, Hour, Hsq=Hour^2, Hcub=Hour^3, 
           Wind, Wsq=Wind^2, Wcub=Wind^3)
b1=lm(CO~Traffic+Wind+I(Wind^2)+cos((2*pi/24)*Hour)+cos((4*pi/24)*Hour))
summary(b1)
anova(b1)

# 对残差进行正态性检验
qqnorm(b1$residuals)
qqline(b1$residuals)
shapiro.test(b1$residuals)

## 分位回归
library(quantreg)
data(engel)

par(mfrow=c(1,2))
plot(engel)
plot(log10(foodexp)~log10(income), data=engel)
# 之所以用到对数是因为，收入和食品支出都呈现右尾分布特征，
# 通过对数变化可以将数据转变为近似正态分布。
# 可以通过直方图观察 hist(engel$income) 与 hist(engel$foodexp)
# 进一步可以做正态性检验 shapiro.test

taus = c(0.15, 0.25, 0.50, 0.75, 0.95, 0.99)
rqs = as.list(taus)
for(i in seq(along.with = taus)){
  rqs[[i]]=rq(log10(foodexp)~log10(income), data=engel, tau=taus[i])
  lines(log10(engel$income), fitted(rqs[[i]]), col = i+1)
}

legend("bottomright",paste("tau=",taus), inset = 0.04, col=2:(length(taus)+1), lty=1)

# 随着tau的变大，回归直线斜率从小逐渐增大。


##  处理复杂线性模型
w=read.csv("pharynx.csv")
w=w[,-c(1,11)]
w=w[w$COND!=9&w$GRADE!=9,]
w$COND[w$COND==3|w$COND==4]=2
w$COND[w$COND==0]=1

u = w
x=1:11
x=x[-c(5, 11)]
for(i in x){
  u[,i]=factor(u[,i])
}
a=lm(TIME~., data=u)
summary(a)

# 如果不满足正态性要求，处理时就需要对因变量
# 进行正态变换，通常做法是进行Box-Cox变换，
# 具体公式参加教材
# 对TIME数据进行Box-Cox变换
library(MASS)
zz = boxcox(TIME~., data=u)

# 选择使极大似然最大的lambda值
lambda = zz$x[which.max(zz$y)]


############################################
## 生存分析中的 Cox 回归模型





###########################################
## 多重共线性问题


library(lars)
library(car)
data(diabetes)
x = diabetes$x
x2 = diabetes$x2
y = diabetes$y
test = data.frame(cbind(diabetes$y, diabetes$x2))
colnames(test) = c('y',colnames(diabetes$x2))


## 岭回归
library(ridge)
a = linearRidge(y~., test)
summary(a)


## lasso回归
laa = lars(x2, y)
plot(laa) # 较为耗时
summary(laa)
# 可以通过Cp值选择对应的方程系数
indicator = which.min(laa$Cp)
# 获取模型系数
cp_best_coef = laa$beta[indicator,] # 注意最小值可能不止一个，需要确定

# lasso 十折交叉验证，只用于选择合适的模型
cva = cv.lars(x2, y , K=10)
best = cva$index[which.min(cva$cv)]
cv_best_coef = coef.lars(laa, s=best, mode="fraction")
# 具体可参见lars函数

# 比较cp和cv的系数
sum(cp_best_coef != 0)
sum(cv_best_coef != 0)
rbind(cp_best_coef,cv_best_coef)

## 适应性 lasso
library(msgps)
# 为什么gamma为1以及lambda为0，需要进一步确定，可以考虑使用cv选择gamma
ala = msgps(x2, y, penalty = 'alasso', gamma = 1, lambda = 0)
summary(ala)
plot(ala)

# 提取参数，通过Cp. AICC, GCV, BIC
ala_coef = coef(ala)[,1]

## 总结
# ridge, lasso, adaptive lasso, SCAN方法都是对惩罚函数的修正，
# 在惩罚函数中加入对参数的控制，达到降维和消除共线性的效果。
# 其中涉及到调整参数的选择，如lambda, tau等系数，通常方法包括
# 两大类，1是统计量指标，如Cp准则,BIC准则等；2是使用交叉验证的
# 方法，对于每个lambda分量，计算K折均方误差的均值，从所有lambda
# 分量中选出，均方误差最小的lambda，以及对应的系数。显然， adaptive
# lasso例子中，lambda也可以通过K折交叉验证的方法求得。

## 偏最小二乘回归
library(lars)
library(pls)

ap = plsr(y~x2, 64, validation = "CV")
# CV准则下，不同评价指标
validationplot(ap)
# 不同准则
RMSEP(ap)
MSEP(ap)
R2(ap)


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
set.seed(400)
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
barplot(t(res),beside = T)
