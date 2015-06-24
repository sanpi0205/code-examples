
# see the origin link http://www.jstatsoft.org/v36/i11/
# resource https://m2.icm.edu.pl/boruta/
# dataset: http://archive.ics.uci.edu/ml/datasets/Ozone+Level+Detection

library('mlbench')
library('Boruta')
data('Ozone')
Ozone <- na.omit(Ozone)
set.seed(1)

Boruta.Ozone <- Boruta(V4~., data = Ozone, doTrace = 2, ntree = 500)
plot(Boruta.Ozone)
plotImpHistory(Boruta.Ozone)
