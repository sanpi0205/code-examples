

# ¾ö²ßÊ÷
set.seed(1234)

index = sample(1:2, nrow(iris), replace=T, prob=c(0.7,0.3))
attach(iris)
trainData = iris[index==1,]
testData = iris[index==2,]

library('party')

myFormula = Species~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width
iris_ctree = ctree(myFormula, data = trainData)
table(predict(iris_ctree), trainData$Species)
print(iris_ctree)
