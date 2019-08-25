#Cheryl Ngo
#Module 7 Data Assignment
#August 21, 2019

####Read in the data####

#Data Import and Variable Type Changes
setwd("C:\\Users\\chery\\Grad School\\BUAD 5122-ML1\\M7-Decision Trees, Bagging, and Random Forests\\Data Assignment")
data = read.csv("buad5122-m7-insurance-training.csv")
test = read.csv("buad5122-m7-insurance-test.csv")

#Convert appropriately to numerical and categorical
data$INDEX = as.factor(data$INDEX)
data$TARGET_FLAG = as.factor(data$TARGET_FLAG)

data$INCOME = suppressWarnings(as.numeric(gsub("[^0-9.]", "", data$INCOME))) #Remove non-numeric characters
data$PARENT1 = as.factor(data$PARENT1)
data$HOME_VAL = suppressWarnings(as.numeric(gsub("[^0-9.]", "", data$HOME_VAL))) #Remove non-numeric characters
data$MSTATUS = as.factor(data$MSTATUS)
data$DO_KIDS_DRIVE = as.factor(ifelse(data$KIDSDRIV > 0, 1, 0 )) #Factor, is KIDSDRIV >=1?
data$CAR_USE = as.factor(data$CAR_USE)
data$BLUEBOOK = suppressWarnings(as.numeric(gsub("[^0-9.]", "", data$BLUEBOOK))) #Remove non-numeric characters
data$OLDCLAIM = suppressWarnings(as.numeric(gsub("[^0-9.]", "", data$HOME_VAL))) #Remove non-numeric characters
data$OLDCLAIM = ifelse(is.na(data$OLDCLAIM),0,data$OLDCLAIM)
data$URBANICITY = ifelse(data$URBANICITY == "Highly Urban/ Urban", "Urban", "Rural")
data$URBANICITY = as.factor(data$URBANICITY)

str(data)

#Convert test data types
test$INDEX = as.factor(test$INDEX)
test$TARGET_FLAG=as.factor(test$TARGET_FLAG)

test$INCOME = suppressWarnings(as.numeric(gsub("[^0-9.]", "", test$INCOME))) #Remove non-numeric characters
test$PARENT1 = as.factor(test$PARENT1)
test$HOME_VAL = suppressWarnings(as.numeric(gsub("[^0-9.]", "", test$HOME_VAL))) #Remove non-numeric characters
test$MSTATUS = as.factor(test$MSTATUS)
test$DO_KIDS_DRIVE = as.factor(ifelse(test$KIDSDRIV > 0, 1, 0 )) #Factor, is KIDSDRIV >=1?
test$BLUEBOOK = suppressWarnings(as.numeric(gsub("[^0-9.]", "", test$BLUEBOOK))) #Remove non-numeric characters
test$OLDCLAIM = suppressWarnings(as.numeric(gsub("[^0-9.]", "", test$HOME_VAL))) #Remove non-numeric characters
test$OLDCLAIM = ifelse(is.na(test$OLDCLAIM),0,test$OLDCLAIM)
test$URBANICITY = ifelse(test$URBANICITY == "Highly Urban/ Urban", "Urban", "Rural")
test$URBANICITY = as.factor(test$URBANICITY)

str(test)

####Data Exploration ####

summary(data)

#Bar graph for factors
library(magrittr)
library(ggplot2)
library(gridExtra)

data %>% 
  ggplot(aes(TARGET_FLAG)) + ggtitle("Target Flag") +
  geom_bar(aes(fill = TARGET_FLAG))+ 
  scale_fill_discrete(name = "Crash", labels = c("No", "Yes"))

nrow(data[data$TARGET_FLAG==0,])/nrow(data) #73.6% are no crash

a=data %>% 
  ggplot(aes(CAR_TYPE)) + ggtitle("Type of Car") +
  geom_bar(aes(fill = TARGET_FLAG))+ 
  scale_fill_discrete(name = "Crash", labels = c("No", "Yes"))

b=data %>% 
  ggplot(aes(CAR_USE)) + ggtitle("Vehicle Use") +
  geom_bar(aes(fill = TARGET_FLAG))+
  scale_fill_discrete(name = "Crash", labels = c("No", "Yes"))

c= data %>% 
  ggplot(aes(EDUCATION)) + ggtitle("Max Education Level") +
  geom_bar(aes(fill = TARGET_FLAG))+
  scale_fill_discrete(name = "Crash", labels = c("No", "Yes"))

d= data %>% 
  ggplot(aes(JOB)) + ggtitle("Job Category") +
  geom_bar(aes(fill = TARGET_FLAG))+
  scale_fill_discrete(name = "Crash", labels = c("No", "Yes"))

grid.arrange(a,b,c, d, ncol=2) #CAR_TYPE, EDUCATION, and JOB contains >2 levels

e=data %>% 
  ggplot(aes(MSTATUS)) + ggtitle("Marital Status") +
  geom_bar(aes(fill = TARGET_FLAG))+
  scale_fill_discrete(name = "Crash", labels = c("No", "Yes"))

f=data %>% 
  ggplot(aes(PARENT1)) + ggtitle("Single Parent") +
  geom_bar(aes(fill = TARGET_FLAG))+
  scale_fill_discrete(name = "Crash", labels = c("No", "Yes"))

g=data %>% 
  ggplot(aes(RED_CAR)) + ggtitle("Red Car") +
  geom_bar(aes(fill = TARGET_FLAG))+
  scale_fill_discrete(name = "Crash", labels = c("No", "Yes"))

h=data %>% 
  ggplot(aes(REVOKED)) + ggtitle("License Revoked (Past 7 Years)") +
  geom_bar(aes(fill = TARGET_FLAG))+
  scale_fill_discrete(name = "Crash", labels = c("No", "Yes"))

grid.arrange(e,f,g, h, ncol=2)

i=data %>% 
  ggplot(aes(SEX)) + ggtitle("Gender") +
  geom_bar(aes(fill = TARGET_FLAG))+
  scale_fill_discrete(name = "Crash", labels = c("No", "Yes"))

j=data %>% 
  ggplot(aes(URBANICITY)) + ggtitle("Home/Work Area") +
  geom_bar(aes(fill = TARGET_FLAG))+
  scale_fill_discrete(name = "Crash", labels = c("No", "Yes"))

k=data %>%
  ggplot(aes(DO_KIDS_DRIVE)) + ggtitle("Do Kids Drive")+
  geom_bar(aes(fill=TARGET_FLAG))+
  scale_fill_discrete(name = "Crash", labels = c("No", "Yes"))

grid.arrange(i, j, k, ncol=1)

# Histograms for Numeric Variables

par(mfrow=c(1,2))
hist(data$AGE, col = "red", xlab = "Age", main = "AGE Hist")
data0<- subset(data, TARGET_FLAG == 1 )
boxplot(data$AGE, col = "red", main = "AGE BoxPlot")

par(mfrow=c(2,2))
hist(sqrt(data$BLUEBOOK), col = "green", xlab = "SQRT BLUEBOOK", main = "SQRT BLUEBOOK Hist")
hist((data$TIF), col = "blue", xlab = "TIF", main = "TIF Hist") #Skewed right
boxplot(sqrt(data$BLUEBOOK), col = "green", main = "SQRT BLUEBOOK BoxPlot")
boxplot((data$TIF), col = "blue", main = "TIF BoxPlot")

hist(data$CAR_AGE, col = "green", xlab = "CAR AGE", main = "CAR AGE Hist") #Possibly transform to binary--BI_CAR_AGE indicating if Car Age > 0
hist(data$CLM_FREQ, col = "blue", xlab = "Claim Frequency", main = "Claim Frequency Hist") #Transform into binary--BI_CLAIM indicating if Claim Frequency>0
boxplot(data$CAR_AGE, col = "green", main = "CAR AGE BoxPlot")
boxplot(data$CLM_FREQ, col = "blue", main = "Claim Frequency BoxPlot")

hist(data$HOMEKIDS, col = "green", xlab = "HOME KIDS", main = "HOME KIDS Hist") #Transform into binary--BI_HAS_KIDS
hist(data$HOME_VAL, col = "blue", xlab = "HOME VALUE", main = "HOME VALUE Hist")
boxplot(data$HOMEKIDS, col = "green", main = "HOME KIDS BoxPlot")
boxplot(data$HOME_VAL, col = "blue", main = "HOME VALUE BoxPlot")

hist(sqrt(data$INCOME), col = "green", xlab = "INCOME", main = "SQRT INCOME Hist")
hist(data$KIDSDRIV, col = "blue", xlab = "KIDS DRIVE", main = "KIDS DRIVE Hist") #Transform into binary--BI_KIDSDRIV
boxplot(sqrt(data$INCOME), col = "green", main = "SQRT INCOME BoxPlot")
boxplot(data$KIDSDRIV, col = "blue", main = "KIDS DRIVE BoxPlot")

hist(data$MVR_PTS, col = "green", xlab = "RECORD POINTS", main = "RECORD POINTS Hist") #Transform into binary--BI_MVR_PTS
hist(data$OLDCLAIM, col = "blue", xlab = "OLD CLAIM TOTAL", main = "OLD CLAIM TOTAL Hist")
boxplot(data$MVR_PTS, col = "green", main = "RECORD POINTS BoxPlot")
boxplot(data$OLDCLAIM, col = "blue", main = "OLD CLAIM TOTAL BoxPlot")

hist(sqrt(data$TRAVTIME), col = "green", xlab = "SQRT TRAVTIME", main = "SQRT TRAVTIME Hist")
hist(data$YOJ, col = "blue", xlab = "YOJ", main = "YOJ Hist")
boxplot(sqrt(data$TRAVTIME), col = "green", main = "SQRT TRAVTIME BoxPlot")
boxplot(data$YOJ, col = "blue", main = "YOJ BoxPlot")

par(mfrow=c(1,1))

####Data Transformation####

outlier_flag=function(df,dftest,column){
  data_mean = mean(dftest[,column])
  data_std = sd(dftest[,column])
  cut_off = data_std * 3
  min = data_mean - cut_off
  max = data_mean + cut_off
  flgO=as.factor(ifelse(dftest[,column] %in% df[,column][df[,column]<min|df[,column]>max], 1, 0))
  impO=as.numeric(ifelse(dftest[,column] %in% df[,column][df[,column]<min|df[,column]>max], ifelse(df[,column][df[,column]>max], max,min), dftest[,column]))
  eval.parent(substitute(dftest[,column]<-impO))
  eval.parent(substitute(dftest$flag<-flgO))
}

#Create function to correct for missing values
missing_flag=function(df,dftest,column){
  flgM=as.factor(ifelse(is.na(dftest[,column]),1,0))
  eval.parent(substitute(dftest$flag<-flgM))
}

##Missing values
#Flag missing values
for (i in 4:26){
  if (class(data[,i])!="factor") {
    missing_flag(data,data,i)
    colnames(data)[ncol(data)]=paste("flagMissing",colnames(data)[i],sep="_")
    #data=data[,colSums(data!=0)>0|is.na(colSums(data!=0))]
  }
} #Missing value for factor JOB will be renamed 

#Flag missing values for the test data
for (i in 4:26){
  if (class(test[,i])!="factor") {
    missing_flag(data,test,i)
    colnames(test)[ncol(test)]=paste("flagMissing",colnames(test)[i],sep="_")
    #test=test[,colSums(test!=0)>0|is.na(colSums(test!=0))]
  }
} #Missing value for factor JOB will be renamed 

#Correct missing values and CAR_AGE
library(zoo)

#Change missing values for JOB to "Not Specified"
levels(data$JOB)[1]<-"Not Specified"
data$JOB[levels(data$JOB)=="Not Specified"]="Not Specified"

#Impute missing values with aggregate means
data$AGE= na.aggregate(data$AGE, data$EDUCATION, mean, na.rm = TRUE) #impute missing values of AGE with the average age for that education level
data$YOJ = na.aggregate(data$YOJ, data$JOB, mean, na.rm = TRUE) #impute missing values of YOJ with the average years on job for that job group
data$INCOME = na.aggregate(data$INCOME, data$JOB, mean, na.rm = TRUE) #impute missing values of INCOME with the average years on job for that job group
data$HOME_VAL = na.aggregate(data$HOME_VAL, data$EDUCATION, mean, na.rm = TRUE ) #Impute missing values of HOME_VAL by education
data$CAR_AGE = na.aggregate(data$CAR_AGE, data$CAR_TYPE, mean, na.rm = TRUE) #Impute missing values of CAR_AGE by CAR_TYPE

#Correct missing values--test data
levels(test$JOB)[1]<-"Not Specified"
test$JOB[levels(test$JOB)=="Not Specified"]="Not Specified"

agg=aggregate(YOJ ~ AGE, data=data, mean)
for (i in 1:nrow(agg)){
  test = within(test, AGE[is.na(AGE) & EDUCATION == agg[i,1]] <- agg[i,2])
} #impute missing values of AGE with the average age for that education level
test$AGE[is.na(test$AGE)] =mean(data$AGE) #Impute last missing value

agg=aggregate(YOJ ~ JOB, data=data, mean)
for (i in 1:nrow(agg)){
  test = within(test, YOJ[is.na(YOJ) & JOB == agg[i,1]] <- agg[i,2])
} #impute missing values of YOJ with the average years on job for that job group

agg=aggregate(INCOME ~ JOB, data=data, mean)
for (i in 1:nrow(agg)){
  test = within(test, INCOME[is.na(INCOME) & JOB == agg[i,1]] <- agg[i,2])
} #impute missing values of INCOME with the average years on job for that job group

agg=aggregate(HOME_VAL ~ JOB, data=data, mean)
for (i in 1:nrow(agg)){
  test = within(test, HOME_VAL[is.na(HOME_VAL) & JOB == agg[i,1]] <- agg[i,2])
} #Impute missing values of HOME_VAL by education

agg=aggregate(CAR_AGE ~ JOB, data=data, mean)
for (i in 1:nrow(agg)){
  test = within(test, CAR_AGE[is.na(CAR_AGE) & JOB == agg[i,1]] <- agg[i,2])
} #Impute missing values of CAR_AGE by CAR_TYPE

test$OLDCLAIM <- ifelse(test$CAR_AGE < 5,0,test$OLDCLAIM)

#Fix outliers
for (i in 4:26){
  if (class(data[,i])!="factor") {
    outlier_flag(data,data,i)
    colnames(data)[ncol(data)]=paste("flagOutlier",colnames(data)[i],sep="_")
    #data=data[,colSums(data!=0)>0|is.na(colSums(data!=0))]
  }
}

#Correct the negative age to zero
data$flagOutlier_CAR_AGE=as.factor(ifelse(data$CAR_AGE<0,1,as.numeric(data$flagOutlier_CAR_AGE)-1))
data$CAR_AGE[data$CAR_AGE < 0 ] = 0

#Old claims should not exist for owners who have had their car for less than 5 years
data$OLDCLAIM = ifelse(data$CAR_AGE < 5 ,0,data$OLDCLAIM) 

#Fix outliers for the test data
for (i in 4:26){
  if (class(test[,i])!="factor") {
    outlier_flag(data,test,i)
    colnames(test)[ncol(test)]=paste("flagOutlier",colnames(test)[i],sep="_")
    #test=test[,colSums(test!=0)>0|is.na(colSums(test!=0))]
  }
}

#Check for outliers and missing values
summary(data) #No outliers for data
summary(test) #No outliers for data

#Varible transformations
plot(data$TRAVTIME)
plot(data$BLUEBOOK)
plot(data$INCOME)
# data$SQRT_TRAVTIME <- sqrt(data$TRAVTIME)
# data$SQRT_BLUEBOOK <- sqrt(data$BLUEBOOK)
# data$SQRT_INCOME <- sqrt(data$INCOME)

#Replace varaible with its transformation
data$TRAVTIME <- sqrt(data$TRAVTIME)
data$BLUEBOOK <- sqrt(data$BLUEBOOK)
data$INCOME <- sqrt(data$INCOME)

# #Create binary variables for CAR_AGE, CLAIM_FREQ, HOME_KIDS, KIDSDRIV, and MVR POINTS > 0 or 1
# data$BI_CAR_AGE=ifelse(data$CAR_AGE>1,1,0)
# data$BI_CLAIM_FREQ=ifelse(data$CLM_FREQ>0,1,0)
# data$BI_HOMEKIDS=ifelse(data$KIDSDRIV>0,1,0)
# data$BI_MVR_PTS=ifelse(data$MVR_PTS>0,1,0)

#Varible transformations--test
# test$SQRT_TRAVTIME <- sqrt(test$TRAVTIME)
# test$SQRT_BLUEBOOK <- sqrt(test$BLUEBOOK)
# test$SQRT_INCOME <- sqrt(test$INCOME)

#Replace variables with their transformations
test$TRAVTIME <- sqrt(test$TRAVTIME)
test$BLUEBOOK <- sqrt(test$BLUEBOOK)
test$INCOME <- sqrt(test$INCOME)

# #Create binary variables for CAR_AGE, CLAIM_FREQ, HOME_KIDS, KIDSDRIV, and MVR POINTS > 0
# test$BI_CAR_AGE=ifelse(test$CAR_AGE>1,1,0)
# test$BI_CLAIM_FREQ=ifelse(test$CLM_FREQ>0,1,0)
# test$BI_HOMEKIDS=ifelse(test$KIDSDRIV>0,1,0)
# test$BI_MVR_PTS=ifelse(test$MVR_PTS>0,1,0)

#Consolidate EDUCATION, CAR_TYPE, and JOB into one binary variable each
#Combine levels of variables EDUCATION, JOB, and, CAR_TYPE
levels(data$EDUCATION) <- c("No College", "College", "College", "College", "No College")
levels(data$JOB) <- c("Not Manager", "Not Manager", "Not Manager", "Not Manager", "Not Manager", "Manager",
                      "Not Manager", "Not Manager", "Not Manager")
levels(data$CAR_TYPE) <- c("Other", "Other", "Other", "Other", "Other", "SUV")

#Combine levels of variables EDUCATION, JOB, and, CAR_TYPE--test data
levels(test$EDUCATION) <- c("No College", "College", "College", "College", "No College")
levels(test$JOB) <- c("Not Manager", "Not Manager", "Not Manager", "Not Manager", "Not Manager", "Manager",
                      "Not Manager", "Not Manager", "Not Manager")
levels(test$CAR_TYPE) <- c("Other", "Other", "Other", "Other", "Other", "SUV")

for (i in 1:53){
  levels(test[,i]) = levels(data[,i])
}

# for(i in 1:ncol(test)){
#   levels(test[,i]) <- levels(data[,i])
# }

numeric = subset(data, select = c(AGE, HOMEKIDS, YOJ, INCOME, HOME_VAL, TRAVTIME, BLUEBOOK, TIF,
                                  CLM_FREQ, MVR_PTS, CAR_AGE, KIDSDRIV, OLDCLAIM), na.rm = TRUE)

library(corrplot)
c <- cor(numeric)
corrplot(c, method = "square")
#The predictors OLDCLAIM and HOME_VAL are highly positively correlated. HOMEKIDS and AGE are the most negatively correlated.

####Model Development####

####Fitting Trees and Pruned Trees####
library(tree)

##Classification tree
set.seed(10)
train=sample(1:nrow(data),4081)
data.test=data[-train,]
y.test=data[-train,2]
attach(data)
tree.data=tree(TARGET_FLAG~ .-TARGET_AMT-INDEX,data=data,subset=train)
plot(tree.data)
text(tree.data,pretty=0)
tree.pred=predict(tree.data,data.test,type="class")
table(tree.pred,y.test)
(2528+482)/4080 #73.77% accuracy

##Pruned classification tree
#cv.data=cv.tree(tree.data)
set.seed(10)
cv.data=cv.tree(tree.data,FUN=prune.misclass)
par(mfrow=c(1,2))
plot(cv.data$size,cv.data$dev,type="b")
plot(cv.data$k,cv.data$dev,type="b") #Optimal number of nodes is 5
par(mfrow=c(1,1))
prune.data=prune.misclass(tree.data,best=5)
plot(prune.data)
text(prune.data,pretty=0)
prune.pred=predict(prune.data,data.test,type="class")
table(prune.pred,y.test)
(2528+482)/4080 #73.77% accuracy--Cross-validated tree pruining results in the same misclassification rate with less nodes

###Fitting Regression Trees

##Fit a regression tree
tree.data=tree(TARGET_AMT~.-INDEX-TARGET_FLAG,data,subset=train)
summary(tree.data) #Three variables used
plot(tree.data)
text(tree.data,pretty=0)

#Regression tree fit
yhat=predict(tree.data,newdata=data.test)
y2.test=data[-train,"TARGET_AMT"]
plot(yhat,y2.test)
abline(0,1)
mean((yhat-y2.test)^2) #18172571

##Pruned regression tree
set.seed(18)
cv.data=cv.tree(tree.data)
plot(cv.data$size,cv.data$dev,type='b') #Optimal number of nodes is 5
prune.data=prune.tree(tree.data,best=5)
plot(prune.data)
text(prune.data,pretty=0)
prune.pred=predict(prune.data,data.test)
mean((prune.pred-y2.test)^2) #18146352--Pruned regression tree performs better

#####Bagging and Random Forests####
library(randomForest)

##Bagging for regression
set.seed(1)
attach(data)
bag.data=randomForest(TARGET_AMT~.-TARGET_FLAG-INDEX,data=data,subset=train,mtry=24,importance=TRUE)
bag.data
yhat.bag = predict(bag.data,newdata=data[-train,])
plot(yhat.bag, data.test[,3])
abline(0,1)
mean((yhat.bag-data.test[,3])^2) #17728691--worse than pruned regression tree

#For classification
set.seed(1)
bag.class=randomForest(TARGET_FLAG~.-TARGET_AMT-INDEX,data=data,subset=train,mtry=24,importance=TRUE)
bag.class
yhat.bag = predict(bag.class,newdata=data[-train,],type="class")
table(yhat.bag,y.test)
(2771+415)/4080 #78.09--better than pruned classiciation tree

# #Specify number of trees to grow
# bag.data=randomForest(TARGET_AMT~.-TARGET_FLAG,data=data,subset=train,mtry=24,ntree=25)
# yhat.bag = predict(bag.data,newdata=data[-train,])
# mean((yhat.bag-data.test[,3])^2) #19667800--worse than full bagged tree

##Random Forest using default mtry=p/3 for regression
set.seed(1)
# rf.data=randomForest(TARGET_AMT~.-TARGET_FLAG-INDEX,data=data,subset=train,importance=TRUE)
# yhat.rf = predict(rf.data,newdata=data[-train,])
# importance(rf.data)
# varImpPlot(rf.data)

#Using the most important predictors
#rf.data=randomForest(TARGET_AMT~.-INDEX-TARGET_FLAG,data=data,subset=train,importance=TRUE)
rf.data=randomForest(TARGET_AMT~AGE+URBANICITY+INCOME+PARENT1+MSTATUS+
                       OLDCLAIM+HOME_VAL+CAR_AGE+HOMEKIDS+DO_KIDS_DRIVE+JOB+
                       MVR_PTS+CLM_FREQ+KIDSDRIV+BLUEBOOK+TRAVTIME+YOJ+TIF+CAR_USE+
                       EDUCATION+MSTATUS,
                     data=data,subset=train,importance=TRUE)
yhat.rf = predict(rf.data,newdata=data[-train,])
mean((yhat.rf-y2.test)^2) #17348998 best regression performance
importance(rf.data)
varImpPlot(rf.data)

#For classification
set.seed(1)
#rf.data=randomForest(TARGET_FLAG~.-TARGET_AMT-INDEX,data=data,subset=train,importance=TRUE)
rf.data=randomForest(TARGET_FLAG~URBANICITY+CLM_FREQ+INCOME+MVR_PTS+
                       HOME_VAL+OLDCLAIM+CAR_USE+KIDSDRIV+PARENT1+REVOKED+EDUCATION+
                       +DO_KIDS_DRIVE+MSTATUS+BLUEBOOK+TRAVTIME+AGE+CAR_AGE+YOJ+
                       TIF+flagOutlier_MVR_PTS+HOMEKIDS+JOB+SEX+flagOutlier_MVR_PTS,
                     data=data,subset=train,importance=TRUE)
varImpPlot(rf.data)
yhat.rf = predict(rf.data,newdata=data[-train,],type="class")
table(yhat.rf,y.test)
(2821+356)/4080 #77.9--better than bagging

#####Boosting####
library(gbm)

##Boosting for Regression
set.seed(1)
attach(data)

# boost.data=gbm(TARGET_AMT~.-TARGET_AMT-INDEX,
#                data=data[train,],distribution="gaussian",n.trees=5000,interaction.depth=4)
# summary(boost.data)

#Using non-zero predictors from non-cross validated results
set.seed(1)
boost.data=gbm(TARGET_AMT~BLUEBOOK+INCOME+AGE+TRAVTIME+
               HOME_VAL+CAR_AGE+MVR_PTS+YOJ+TIF+OLDCLAIM+
                 CAR_USE+CLM_FREQ+MSTATUS+HOMEKIDS+SEX+
                 PARENT1+URBANICITY+RED_CAR+EDUCATION+
                 flagOutlier_MVR_PTS+KIDSDRIV+DO_KIDS_DRIVE+
                 REVOKED+CAR_TYPE+flagMissing_INCOME+
                 flagMissing_HOME_VAL+flagMissing_YOJ+flagMissing_CAR_AGE,
                 data=data[train,],distribution="gaussian",n.trees=5000,interaction.depth=4)
summary(boost.data)

#Partial dependence plots
plot(boost.data,i="BLUEBOOK")
plot(boost.data,i="INCOME")
plot(boost.data,i="AGE")

#Prediction
set.seed(1)
yhat.boost=predict(boost.data,newdata=data[-train,],n.trees=5000)
mean((yhat.boost-data.test[,3])^2) #24340336 #Boosted regression tree performs worse than random forest

# #Try boosting with lambda=.2
# set.seed(1)
# boost.data=gbm(TARGET_AMT~.-TARGET_FLAG-INDEX,data=data[train,],distribution="gaussian",n.trees=5000,interaction.depth=4,shrinkage=0.2)
# yhat.boost=predict(boost.data,newdata=data[-train,],n.trees=5000)
# mean((yhat.boost-data.test[,3])^2) #27625267 performs worse than default lambda

##Boosting for Classification
attach(data)
set.seed(1)
boost.data=gbm((unclass(TARGET_FLAG)-1)~.-TARGET_AMT-INDEX,data=data[train,],distribution="bernoulli",n.trees=5000,interaction.depth=4)
summary(boost.data)
#Partial dependence plots
plot(boost.data,i="URBANICITY")
plot(boost.data,i="INCOME")
plot(boost.data,i="CLM_FREQ")
yhat.boost=predict(boost.data,newdata=data[-train,],n.trees=5000,type="response")
boost_class = yhat.boost > 0.5
table(boost_class,y.test)
(2612+480)/4080 #75.7%--Best classification performance

# #Try boosting with lambda=.2
# boost.data=gbm((unclass(TARGET_FLAG)-1)~.-TARGET_AMT-INDEX,data=data[train,],distribution="bernoulli",n.trees=5000,interaction.depth=4,shrinkage=.2)
# yhat.boost=predict(boost.data,newdata=data[-train,],n.trees=5000,type="response")
# boost_class = yhat.boost > 0.5
# table(boost_class,y.test)
# (2592+473)/4080 #75.12%--performs worse than default lambda

########### STAND ALONE SCORING PROGRAM ###############

#Final model for regression
set.seed(1)

#test=test[,c(1:2,4:53)]

final.regres=randomForest(TARGET_AMT~AGE+URBANICITY+INCOME+PARENT1+MSTATUS+
                            OLDCLAIM+HOME_VAL+CAR_AGE+HOMEKIDS+DO_KIDS_DRIVE+JOB+
                            MVR_PTS+CLM_FREQ+KIDSDRIV+BLUEBOOK+TRAVTIME+YOJ+TIF+CAR_USE+
                            EDUCATION+MSTATUS,data=data,importance=TRUE)

final.regres.predict=predict(final.regres,newdata=test)
test$P_TARGET_AMT = final.regres.predict

#Final model for classification
set.seed(1)
final.class=randomForest(TARGET_FLAG~URBANICITY+CLM_FREQ+INCOME+HOME_VAL+CAR_USE+
                           OLDCLAIM+MVR_PTS+PARENT1+BLUEBOOK+TRAVTIME+AGE+HOME_VAL+
                           CAR_AGE+YOJ+KIDSDRIV+EDUCATION+CLM_FREQ+TIF+flagOutlier_MVR_PTS,data=data,importance=TRUE)
final.class.predict = predict(final.class,newdata=test,type="class")

#final.class=boost.data=gbm((unclass(TARGET_FLAG)-1)~.-TARGET_AMT-INDEX,data=data,distribution="bernoulli",n.trees=5000,interaction.depth=4)

test$P_TARGET_FLAG <- final.class.predict

#Prediction File 
prediction <- test[c("INDEX","P_TARGET_FLAG","P_TARGET_AMT")]
write.csv(prediction, file = "M7OutputCherylNgo.csv",row.names = FALSE)
