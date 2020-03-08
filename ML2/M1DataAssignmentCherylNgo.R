#Cheryl Ngo
#Module 1 Data Assignment
#January 12, 2020

####Read in the data####

#Data Import and Variable Type Changes
setwd("C:\\Users\\chery\\Grad School\\BUAD 5132-ML2\\Module 1-Support Vector Machines\\Data Assignment")
data = read.csv("buad5132-m1-training-data.csv")
test = read.csv("buad5132-m1-test-data.csv")

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
data$MSTATUS = as.factor(data$MSTATUS)
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

# Plot of numeric variables colored with TARGET_FLAG
plot(data$AGE, data$BLUEBOOK, col=data$TARGET_FLAG, pch=19, xlab='AGE', ylab='BLUEBOOK', main='Crashes by Bluebook and Age')
plot(data$AGE, data$TIF, col=data$TARGET_FLAG, pch=19, xlab='AGE', ylab='TIF', main='Crashes by Time in Field and Age')
plot(data$AGE, data$CAR_AGE, col=data$TARGET_FLAG, pch=19, xlab='AGE', ylab='CAR_AGE', main='Crashes by Car Age and Age')
plot(data$CAR_AGE, data$TIF, col=data$TARGET_FLAG, pch=19, xlab='CAR_AGE', ylab='TIF', main='Crashes by Time in Field and Car Age')
plot(data$CAR_AGE, data$CLM_FREQ, col=data$TARGET_FLAG, pch=19, xlab='CAR_AGE', ylab='CLM_FREQ', main='Crashes by Time in Field and Claim Frequence')
plot(data$CAR_AGE, data$HOMEKIDS, col=data$TARGET_FLAG, pch=19, xlab='CAR_AGE', ylab='HOMEKIDS', main='Crashes by Time in Field and Number of Kids at Home')
plot(data$CLM_FREQ, data$HOMEKIDS, col=data$TARGET_FLAG, pch=19, xlab='CLM_FREQ', ylab='HOMEKIDS', main='Crashes by Kids at Home and Claim Frequency')
plot(data$CLM_FREQ, data$HOME_VAL, col=data$TARGET_FLAG, pch=19, xlab='CLM_FREQ', ylab='HOME_VAL', main='Crashes by Home Value and Claim Frequency')
plot(data$INCOME, data$HOME_VAL, col=data$TARGET_FLAG, pch=19, xlab='INCOME', ylab='HOME_VAL', main='Crashes by Home Value and Income')
plot(data$INCOME, data$KIDSDRIV, col=data$TARGET_FLAG, pch=19, xlab='INCOME', ylab='KIDS_DRIV', main='Crashes by Number of Kids Driving and Income')
plot(data$MVR_PTS, data$OLDCLAIM, col=data$TARGET_FLAG, pch=19, xlab='MVR_PTS', ylab='OLDCLAIM', main='Crashes by Old Claims and Motorist Points')
plot(data$MVR_PTS, data$INCOME, col=data$TARGET_FLAG, pch=19, xlab='MVR_PTS', ylab='INCOME', main='Crashes by Income and Motorist Points')
plot(data$TRAVTIME, data$YOJ, col=data$TARGET_FLAG, pch=19, xlab='TRAVTIME', ylab='YOJ', main='Crashes by Years on Job and Travel Time')
plot(data$TRAVTIME, data$CLM_FREQ, col=data$TARGET_FLAG, pch=19, xlab='TRAVTIME', ylab='CLM_fREQ', main='Crashes by Claim Frequency and Travel Time')
plot(data$TRAVTIME, data$INCOME, col=data$TARGET_FLAG, pch=19, xlab='TRAVTIME', ylab='INCOME', main='Crashes by Income and Travel Time')

#### Data Transformation ####

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

#Flag missing values
for (i in 2:26){
  if (class(data[,i])!="factor") {
    missing_flag(data,data,i)
    colnames(data)[ncol(data)]=paste("flagMissing",colnames(data)[i],sep="_")
    data=data[,colSums(data!=0)>0|is.na(colSums(data!=0))]
  }
} #Missing value for factor JOB will be renamed 

#Flag missing values for the test data
for (i in 3:26){
  if (class(test[,i])!="factor") {
    missing_flag(data,test,i)
    colnames(test)[ncol(test)]=paste("flagMissing",colnames(test)[i],sep="_")
    test=test[,colSums(test!=0)>0|is.na(colSums(test!=0))]
  }
} #Missing value for factor JOB will be renamed 

#Fix outliers
for (i in 2:26){
  if (class(data[,i])!="factor") {
    outlier_flag(data,data,i)
    colnames(data)[ncol(data)]=paste("flagOutlier",colnames(data)[i],sep="_")
    data=data[,colSums(data!=0)>0|is.na(colSums(data!=0))]
  }
}
#Fix outliers for the test data
for (i in 3:26){
  if (class(test[,i])!="factor") {
    outlier_flag(data,test,i)
    colnames(test)[ncol(test)]=paste("flagOutlier",colnames(test)[i],sep="_")
  }
}

#Correct missing values and CAR_AGE
library(zoo)

#Change missing values for JOB to "Not Specified"
levels(data$JOB)[1]<-"Not Specified"
data$JOB[levels(data$JOB)=="Not Specified"]="Not Specified"

#Impute missing values with aggregate means
data$AGE= na.aggregate(data$AGE, data$EDUCATION, mean, na.rm = "TRUE") #impute missing values of AGE with the average age for that education level
data$YOJ = na.aggregate(data$YOJ, data$JOB, mean, na.rm = TRUE) #impute missing values of YOJ with the average years on job for that job group
data$INCOME = na.aggregate(data$INCOME, data$JOB, mean, na.rm = TRUE) #impute missing values of INCOME with the average years on job for that job group
data$HOME_VAL = na.aggregate(data$HOME_VAL, data$EDUCATION, mean, na.rm = TRUE ) #Impute missing values of HOME_VAL by education
data$CAR_AGE = na.aggregate(data$CAR_AGE, data$CAR_TYPE, mean, na.rm = TRUE) #Impute missing values of CAR_AGE by CAR_TYPE

#Correct the negative age to zero
data$flagOutlier_CAR_AGE=as.factor(ifelse(data$CAR_AGE<0,1,as.numeric(data$flagOutlier_CAR_AGE)-1))
data$CAR_AGE[data$CAR_AGE < 0 ] = 0

#Old claims should not exist for owners who have had their car for less than 5 years
data$OLDCLAIM = ifelse(data$CAR_AGE < 5 ,0,data$OLDCLAIM) 

#Correct missing values and outliers--test data
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

#Check for outliers and missing values
summary(data) #No outliers for data
summary(test) #No outliers for data

#Varible transformations
data$SQRT_TRAVTIME <- sqrt(data$TRAVTIME)
data$SQRT_BLUEBOOK <- sqrt(data$BLUEBOOK)
data$SQRT_INCOME <- sqrt(data$INCOME)

 
#Varible transformations--test
test$SQRT_TRAVTIME <- sqrt(test$TRAVTIME)
test$SQRT_BLUEBOOK <- sqrt(test$BLUEBOOK)
test$SQRT_INCOME <- sqrt(test$INCOME)

# numeric = subset(data, select = c(AGE, HOMEKIDS, YOJ, SQRT_INCOME, HOME_VAL, SQRT_TRAVTIME, SQRT_BLUEBOOK, TIF,
#                                   CLM_FREQ, MVR_PTS, CAR_AGE, KIDSDRIV, OLDCLAIM), na.rm = TRUE)
# 
# library(corrplot)
# c <- cor(numeric)
# corrplot(c, method = "square")
# #The predictors OLDCLAIM and HOME_VAL are highly positively correlated. HOMEKIDS and AGE are the most negatively correlated.

####Model Development####
#Model Development for TARGET_FLAG
set.seed(58)
train=sample (1: 8161, 4081)
testing=(-train)

#Model 0: Linear Regression
lm.train=lm(TARGET_FLAG~ KIDSDRIV +AGE+ HOMEKIDS+ YOJ + PARENT1+
              HOME_VAL +MSTATUS+SEX+ EDUCATION+JOB+ CAR_USE+TIF+CAR_TYPE+RED_CAR+
              OLDCLAIM+REVOKED+URBANICITY+ CAR_AGE+
              SQRT_TRAVTIME+SQRT_BLUEBOOK+SQRT_INCOME+CLM_FREQ+
              MVR_PTS+flagMissing_AGE+flagMissing_YOJ+
              flagMissing_INCOME+flagMissing_HOME_VAL+flagMissing_CAR_AGE,data=data,subset=train)
lm.predict=predict(lm.train,data[testing,])
summary(lm.predict)
lm.predict2=factor(ifelse(lm.predict<1.418,0,1)) #Set values in the first three quartiles to zero and others to one
table(lm.predict2,data[testing,2])
mean(lm.predict2==data[testing,2]) #Predictions are accurate 77.77% of the time

#Model 1: KNN
library(class)
attach(data)
train.X=cbind(PARENT1,MSTATUS,EDUCATION,JOB,CAR_USE,TIF,CAR_TYPE,REVOKED,URBANICITY,
              SQRT_TRAVTIME,SQRT_BLUEBOOK,SQRT_INCOME,CLM_FREQ,
              MVR_PTS)[train,]
test.X=cbind(PARENT1,MSTATUS,EDUCATION,JOB,CAR_USE,TIF,CAR_TYPE,REVOKED,URBANICITY,
             SQRT_TRAVTIME,SQRT_BLUEBOOK,SQRT_INCOME,CLM_FREQ,
             MVR_PTS)[testing,]
train.y=TARGET_FLAG[train]
test.y=TARGET_FLAG[testing]

#Make predictions
set.seed(1)
knn.pred=knn(train.X,test.X,train.y,k=30)
table(knn.pred,test.y)
mean(knn.pred==test.y) #73.67 are correctly predicted

#Model 2: Logistic regression
library(car)
library(caret)

#Keeping only significant variables from the full model
attach(data)
logistic.train=glm(TARGET_FLAG~ PARENT1+MSTATUS+EDUCATION+JOB+CAR_USE+TIF+CAR_TYPE+REVOKED+URBANICITY+flagMissing_AGE+
             flagOutlier_OLDCLAIM+flagOutlier_MVR_PTS+SQRT_TRAVTIME+SQRT_BLUEBOOK+SQRT_INCOME+CLM_FREQ+
             MVR_PTS,data=data, family=binomial,subset=train)
summary(logistic.train)

vif(logistic.train) #No evidence of multicollinearity

logistic.predict=predict(logistic.train,data[testing,],type='response')
cutoff=.5
logistic.class.predict=as.factor(ifelse(logistic.predict>cutoff,1,0))
confusionMatrix(data=data[testing,2], reference=logistic.class.predict) #78.77% accuracy

#Model 3: Support Vector Machine
library(e1071)

#Model 3A
#Support vector classifier
svc.train=svm(TARGET_FLAG ~AGE+ BLUEBOOK+ TIF+ CAR_AGE+ CLM_FREQ+ HOMEKIDS+ HOME_VAL+
                INCOME+ KIDSDRIV+ MVR_PTS+ OLDCLAIM+ SQRT_TRAVTIME+ YOJ+
                CAR_TYPE+ CAR_USE+ EDUCATION+ JOB+ MSTATUS+ PARENT1+ RED_CAR+
                REVOKED+ SEX+ URBANICITY+ DO_KIDS_DRIVE, data=data, subset=train, kernel="linear", scale=TRUE)
summary(svc.train)

cost=list(c(.1,1,3,5,7,10))
tune.svc.train=tune(svm,TARGET_FLAG ~AGE+ BLUEBOOK+ TIF+ CAR_AGE+ CLM_FREQ+ HOMEKIDS+ HOME_VAL+
                      INCOME+ KIDSDRIV+ MVR_PTS+ OLDCLAIM+ SQRT_TRAVTIME+ YOJ+
                      CAR_TYPE+ CAR_USE+ EDUCATION+ JOB+ MSTATUS+ PARENT1+ RED_CAR+
                      REVOKED+ SEX+ URBANICITY+ DO_KIDS_DRIVE, data=data[train,], kernel="linear", scale=TRUE, ranges=cost)

best.svc.train=tune.svc.train$best.model
summary(best.svc.train) #Cost is 1

svc.train.predict=predict(best.svc.train, data[testing,])
table(predict=svc.train.predict, truth=data[testing,2])
mean(svc.train.predict==data[testing,2]) #Accuracy is 78.48%

#Model 3A Revisited
#Support vector classifier with all variables
cost2=list(c(.1,1,3,5))
svc2.train=svm(TARGET_FLAG ~.-INDEX-TRAVTIME-BLUEBOOK-INCOME, data=data, subset=train, scale=TRUE, kernel="linear")
summary(svc2.train)

tune.svc2.train=tune(svm,TARGET_FLAG ~.-INDEX-TRAVTIME-BLUEBOOK-INCOME, data=data[train,], scale=TRUE, kernel="linear", ranges=cost2)

best.svc2.train=tune.svc2.train$best.model
summary(best.svc2.train) #Cost is 1

svc2.train.predict=predict(best.svc2.train, data[testing,])
table(predict=svc2.train.predict, truth=data[testing,2])
mean(svc2.train.predict==data[testing,2]) #Accuracy is 78.8%--slightly better than without the extra variables

#Model 3B
#Support vector machine: Radial
svm.r.train=svm(TARGET_FLAG ~AGE+ BLUEBOOK+ TIF+ CAR_AGE+ CLM_FREQ+ HOMEKIDS+ HOME_VAL+
                INCOME+ KIDSDRIV+ MVR_PTS+ OLDCLAIM+ SQRT_TRAVTIME+ YOJ+
                CAR_TYPE+ CAR_USE+ EDUCATION+ JOB+ MSTATUS+ PARENT1+ RED_CAR+
                REVOKED+ SEX+ URBANICITY+ DO_KIDS_DRIVE, data=data, subset=train, scale=TRUE, kernel="radial")
summary(svm.r.train)

tune.svm.r.train=tune(svm,TARGET_FLAG ~AGE+ BLUEBOOK+ TIF+ CAR_AGE+ CLM_FREQ+ HOMEKIDS+ HOME_VAL+
                      INCOME+ KIDSDRIV+ MVR_PTS+ OLDCLAIM+ SQRT_TRAVTIME+ YOJ+
                      CAR_TYPE+ CAR_USE+ EDUCATION+ JOB+ MSTATUS+ PARENT1+ RED_CAR+
                      REVOKED+ SEX+ URBANICITY+ DO_KIDS_DRIVE, data=data[train,], scale=TRUE, kernel="radial", ranges=cost)

best.svm.r.train=tune.svm.r.train$best.model
summary(best.svm.r.train) #Cost is 1

svm.r.train.predict=predict(best.svm.r.train, data[testing,])
table(predict=svm.r.train.predict, truth=data[testing,2])
mean(svm.r.train.predict==data[testing,2]) #Accuracy is 78.6

#Model 3B Revisited
#Support vector machine: Radial with significant variables from logistic regression
svm.r2.train=svm(TARGET_FLAG~ PARENT1+MSTATUS+EDUCATION+JOB+CAR_USE+TIF+CAR_TYPE+REVOKED+URBANICITY+flagMissing_AGE+
                   flagOutlier_OLDCLAIM+flagOutlier_MVR_PTS+SQRT_TRAVTIME+SQRT_BLUEBOOK+SQRT_INCOME+CLM_FREQ+
                   MVR_PTS, data=data, subset=train, scale=TRUE, kernel="radial")
summary(svm.r2.train)

tune.svm.r2.train=tune(svm,TARGET_FLAG~ PARENT1+MSTATUS+EDUCATION+JOB+CAR_USE+TIF+CAR_TYPE+REVOKED+URBANICITY+flagMissing_AGE+
                         flagOutlier_OLDCLAIM+flagOutlier_MVR_PTS+SQRT_TRAVTIME+SQRT_BLUEBOOK+SQRT_INCOME+CLM_FREQ+
                         MVR_PTS, data=data[train,], scale=TRUE, kernel="radial", ranges=cost)

best.svm.r2.train=tune.svm.r2.train$best.model
summary(best.svm.r2.train) #Cost is 1

svm.r2.train.predict=predict(best.svm.r.train, data[testing,])
table(predict=svm.r2.train.predict, truth=data[testing,2])
mean(svm.r2.train.predict==data[testing,2]) #Accuracy is 78.5--no better than just using the original variables


#Model 3C
#Support vector machine: Polynomial
svm.p.train=svm(TARGET_FLAG ~AGE+ BLUEBOOK+ TIF+ CAR_AGE+ CLM_FREQ+ HOMEKIDS+ HOME_VAL+
                INCOME+ KIDSDRIV+ MVR_PTS+ OLDCLAIM+ SQRT_TRAVTIME+ YOJ+
                CAR_TYPE+ CAR_USE+ EDUCATION+ JOB+ MSTATUS+ PARENT1+ RED_CAR+
                REVOKED+ SEX+ URBANICITY+ DO_KIDS_DRIVE, data=data, subset=train, scale=TRUE, kernel="polynomial")
summary(svm.p.train)

tune.svm.p.train=tune(svm,TARGET_FLAG ~AGE+ BLUEBOOK+ TIF+ CAR_AGE+ CLM_FREQ+ HOMEKIDS+ HOME_VAL+
                      INCOME+ KIDSDRIV+ MVR_PTS+ OLDCLAIM+ SQRT_TRAVTIME+ YOJ+
                      CAR_TYPE+ CAR_USE+ EDUCATION+ JOB+ MSTATUS+ PARENT1+ RED_CAR+
                      REVOKED+ SEX+ URBANICITY+ DO_KIDS_DRIVE, data=data[train,], scale=TRUE, kernel="polynomial", ranges=cost)

best.svm.p.train=tune.svm.p.train$best.model
summary(best.svm.p.train) #Cost is 1

svm.p.train.predict=predict(best.svm.p.train, data[testing,])
table(predict=svm.p.train.predict, truth=data[testing,2])
mean(svm.p.train.predict==data[testing,2]) #Accuracy is 76.1%

####Model Selection####
#Accuracy and confusion matrices

#ROC and AUC
rocplot <- function(pred, truth, ...){
  predob = prediction(pred, truth)
  perf = performance(predob, "tpr", "fpr")
  plot(perf,...)
  return(performance(predob, measure="auc")@y.values[[1]])}

library(ROCR)

#par(mfrow=c(1,1))

#Model 0: Linear Regression
rocplot(lm.predict,data$TARGET_FLAG[testing], main= "ROC Derived from Linear Regression (Test Data)") 
#AUC .8022

#Model 1: KNN
knn.pred=knn(train.X,test.X,train.y,k=30, prob=TRUE)
knn.prob.roc=attr(knn.pred,"prob")
knn.prob2=1-knn.prob.roc
rocplot(knn.prob2,data$TARGET_FLAG[testing], main="ROC from KNN (Test Data") #AUC .5973

#Model 2: Logistic Regression
rocplot(logistic.predict,data$TARGET_FLAG[testing]) 
#AUC .8004

#Model 3: Support Vector Machines

#3A: Support Vector Classifier with all predictors
svc.roc.train=svm(TARGET_FLAG ~.-INDEX-TRAVTIME-BLUEBOOK-INCOME, data=data, subset=train, kernel="linear", cost=1, decision.values=TRUE)

svc.roc.fitted =attributes(predict(svc.roc.train, data[testing, ], decision.values=TRUE))$decision.values
rocplot(svc.roc.fitted,data[testing, 2], main="ROC from SVC (Test Data)") 
#AUC .8023

#3B: Radial kernel
svm.r.roc=svm(TARGET_FLAG ~AGE+ BLUEBOOK+ TIF+ CAR_AGE+ CLM_FREQ+ HOMEKIDS+ HOME_VAL+
                  INCOME+ KIDSDRIV+ MVR_PTS+ OLDCLAIM+ SQRT_TRAVTIME+ YOJ+
                  CAR_TYPE+ CAR_USE+ EDUCATION+ JOB+ MSTATUS+ PARENT1+ RED_CAR+
                  REVOKED+ SEX+ URBANICITY+ DO_KIDS_DRIVE, data=data, subset=train, kernel="radial", cost=1, decision.values=TRUE)
svm.r.fitted =attributes(predict(svm.r.roc, data[testing, ], decision.values=TRUE))$decision.values
rocplot(svm.r.fitted,data[testing, 2], main="ROC from Radial Kernel SVM (Test Data)") 
#AUC .794

#3C: Polynomial kernel
svm.p.roc=svm(TARGET_FLAG ~AGE+ BLUEBOOK+ TIF+ CAR_AGE+ CLM_FREQ+ HOMEKIDS+ HOME_VAL+
                  INCOME+ KIDSDRIV+ MVR_PTS+ OLDCLAIM+ SQRT_TRAVTIME+ YOJ+
                  CAR_TYPE+ CAR_USE+ EDUCATION+ JOB+ MSTATUS+ PARENT1+ RED_CAR+
                  REVOKED+ SEX+ URBANICITY+ DO_KIDS_DRIVE, data=data, subset=train, kernel="polynomial", cost=1, decision.values=TRUE)
svm.p.fitted =attributes(predict(svm.p.roc, data[testing, ], decision.values=TRUE))$decision.values
rocplot(svm.p.fitted,data[testing, 2], main="ROC from Polynomial Kernel SVM (Test Data)") 
#AUC .7624


########### STAND ALONE SCORING PROGRAM ###############

#Model 4 predictions
full.data=as.data.frame(rbind(data,test))
test=full.data[8162:10302,]
test$TARGET_FLAG=NULL

#Final SVC model
final.model=svm(TARGET_FLAG ~
                 KIDSDRIV+ AGE+ HOMEKIDS + YOJ + PARENT1 +
                 HOME_VAL + MSTATUS + SEX + EDUCATION + JOB +
                 CAR_USE + TIF + CAR_TYPE + RED_CAR + OLDCLAIM +
                 CLM_FREQ + REVOKED + MVR_PTS + CAR_AGE + URBANICITY + DO_KIDS_DRIVE +
                 flagMissing_AGE + flagMissing_CAR_AGE + flagMissing_HOME_VAL + 
                 flagMissing_INCOME + flagMissing_YOJ + flagOutlier_AGE + flagOutlier_BLUEBOOK + 
                 flagOutlier_CAR_AGE + flagOutlier_CLM_FREQ + flagOutlier_HOME_VAL + 
                 flagOutlier_HOMEKIDS + flagOutlier_INCOME + flagOutlier_KIDSDRIV + 
                 flagOutlier_MVR_PTS + flagOutlier_OLDCLAIM + flagOutlier_TIF+ flagOutlier_TRAVTIME + 
                 flagOutlier_YOJ + SQRT_BLUEBOOK + SQRT_INCOME + SQRT_TRAVTIME, data=data, 
               scale=TRUE, kernel="linear", cost=1)
summary(final.model)

final.model.predict=predict(final.model, newdata=test)

test$TARGET_FLAG=final.model.predict

#Prediction File 
prediction <- test[c("INDEX","TARGET_FLAG")]
names(prediction)=c("INDEX","P_TARGET_FLAG")
write.csv(prediction, file = "M1OutputCherylNgo.csv",row.names = FALSE)
