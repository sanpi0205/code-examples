##### R 不同分类方法

library("ElemStatLearn")
data(spam)

# 构建训练集与测试集合
spam$spam = ifelse(spam$spam=="spam", 1, 0)
spam$spam = as.factor(spam$spam)

index =  sample(1:2, nrow(spam), replace=T, prob=c(0.7,0.3))
train_data = spam[index == 1,]
test_data = spam[index == 2, ]

# 构建模型
model = as.formula("spam~.")

# 错误率list
error_rate = list()

#### 决策树 Cart tree
library(rpart)
decision_tree = rpart(model, data = train_data)
prediction = predict(decision_tree, newdata = test_data, type = 'class')
error_rate["dicision_tree_erro"] = sum(test_data$spam != prediction) / length(prediction)

### 决策树 
library('party')
conditinal_inference_tree = ctree(model, data = train_data)
prediction = predict(conditinal_inference_tree, newdata = test_data)
error_rate["conditinal_inference_tree"] = sum(test_data$spam != prediction) / length(prediction)

### 广义线性模型
glm_model = earth(model, data = spam, glm=list(family = "binomial"))
# 由于数据存在的严重的共线性问题，导致无法估计

### AdaBoost
library("adabag")
adaboost_model = boosting(model, data = train_data, mfinal = 300)
prediction = predict(adaboost_model, newdata = test_data)
error_rate["adaboost"] = sum(test_data$spam != prediction$class) / length(prediction$class)

### GB