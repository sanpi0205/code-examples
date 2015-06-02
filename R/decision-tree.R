# 在R中决策树代码
set.seed(1234)
data(iris)
# 有放回抽样
index = sample(1:2, nrow(iris), replace=T, prob=c(0.7,0.3))
attach(iris)
trainData = iris[index==1,]
testData = iris[index==2,]

# Conditional Inference Trees
library('party')
# 定义模型
myFormula = Species~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width
iris_ctree = ctree(myFormula, data = trainData)
table(trainData$Species, predict(iris_ctree))
# 错误率
preMatrix = table(trainData$Species, predict(iris_ctree))
1 - sum(diag(preMatrix)) / sum(preMatrix)

print(iris_ctree)
plot(iris_ctree)

# 决策树(另一个R包)
library('rpart')
iris_tree = rpart(myFormula, data = trainData)
prediction = predict(iris_tree, newdata = trainData, type = 'class')
table(trainData$Species, prediction)

# 错误率
preMatrix = table(trainData$Species, prediction)
1 - sum(diag(preMatrix)) / sum(preMatrix)

print(iris_tree)
plot(iris_tree)