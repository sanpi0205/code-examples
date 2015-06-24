
# Page47 脊柱数据
# 数据介绍: http://archive.ics.uci.edu/ml/datasets/vertebral+column
# 数据下载: http://archive.ics.uci.edu/ml/machine-learning-databases/00212/

dat1 = read.table("column_2C.dat")
# 应用数据挖掘方法一定要进行异常值检验
# 可以先从数据散点图开始
pairs(dat1) # 发现所有变量都对V6数据偏态分布
boxplot(dat1[,'V6'])
which.max(dat1[,'V6'])
summary(dat1[,'V6'])
# 用回归的方法对数据进行插补
data_model = lm(V6~., dat1[-116,])
dat1[116,6] = predict(data_model,dat1[116,-6])

# 构建logistic模型
logistic_model = glm(V7~., dat1, family = 'binomial')
selected_logistic = step(logistic_model)
# 拟合原始数据
model_result = (predict(selected_logistic, dat1, type = 'response') > 0.5 )
n = dim(dat1)
predict_result = rep('AB',n[1])
predict_result[model_result] = 'NO'
# 比较分类对错
predict_table = table(dat1[,7],predict_result)
# 判错率
(sum(predict_table) - sum(diag(predict_table)) )/sum(predict_table)


# 使用LDA模型进行分类
library(MASS)
lda_model = lda(V7~., dat1)
print(lda_model)
lda_result = predict(lda_model, dat1)
predict_lda_table = table(dat1[,7],lda_result$class)
(sum(predict_lda_table) - sum(diag(predict_lda_table)) )/sum(predict_lda_table)

# 对因变量为3个水平的数据建模
library(MASS)
dat1 = read.table("column_3C.dat")
data_model = lm(V6~., dat1[-116,])
dat1[116,6] = predict(data_model,dat1[116,-6])

lda_model = lda(V7~., dat1)
print(lda_model)
lda_result = predict(lda_model, dat1)
predict_lda_table = table(dat1[,7],lda_result$class)
predict_lda_table
(sum(predict_lda_table) - sum(diag(predict_lda_table)) )/sum(predict_lda_table)

################# 以上模型可用交叉验证的方法进行测试，特别是logistic模型和lda判别
################# 以上模型还可用QDA模型，以及MDA模型进行验证

######## 以下为机器学习方法，LDA和QDA等经典方法对数据分布有很强假定，通常为正态分布
######## 这时，如果自变量中含有分类变量，则这些方法就不在适用，应当用机器学习方法

## 以下使用胎心宫缩监护数据
## 数据下载： http://archive.ics.uci.edu/ml/datasets.html
library(xlsx)
dat = read.xlsx()


