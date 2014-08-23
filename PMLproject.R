setwd("C:\\Users\\PE10309\\Downloads\\PracticalMachineLearning\\project")
library(caret)

pml.tr <- read.csv("pml-training.csv", na.strings=c("", "NA"))
pml.tr <- pml.tr[,colSums(is.na(pml.tr)) == 0]    #remove columns with NA
pml.tr <- pml.tr[,-c(1,2,5:7)]

inTrain <- createDataPartition(y=pml.tr$classe, p=0.7, list=FALSE)
training <- pml.tr[inTrain,]
test <- pml.tr[-inTrain,]

#################trees######################################
library(tree)
tree1 <- tree(classe ~ ., data=training)
plot(tree1)
text(tree1, cex=0.5)

        #### predict with original tree ####
pred <- predict(tree1, test, type="class")
t <- table(observed=test[,55], predict=pred)
t <- table(observed=test[,55], predict=pred)
round((prop.table(t,1)), 2)

        #### perform a cross validation and prune the tree ####
par(mfrow=c(1,2))
plot(cv.tree(tree1))
tree2 <- prune.tree(tree1, best=8)
plot(tree2)
text(tree2, cex=0.5)

        #### predict with the pruned tree ####
pred <- predict(tree2, test, type="class")
t <- table(observed=test[,55], predict=pred)
t <- table(observed=test[,55], predict=pred)
round((prop.table(t,1)), 2)

###### randomForest package ###############
set.seed(33833)
library(randomForest)
ranfor <- randomForest(classe ~ ., data=training, prox=TRUE, ntree=200, importance=T)
plot(ranfor$err.rate[,1], main="Error Rate Compared With Number Of Trees",
     xlab="Trees", ylab="Error Rate", type="l")
#plot(ranfor, main="'Activity' Random Forest Error Rates")
varImpPlot(ranfor)

pred <- predict(ranfor, test)
t <- table(observed=test[,55], predict=pred)
round((prop.table(t,1)), 2)


################ Predict testing data 
pml.ts <- read.csv("pml-testing.csv", na.strings=c("", "NA"))
pml.ts <- pml.ts[,colSums(is.na(pml.ts)) == 0]    #remove columns with NA
pml.ts <- pml.ts[,-c(1,2,5:7)]
pred <- predict(ranfor, pml.ts)



