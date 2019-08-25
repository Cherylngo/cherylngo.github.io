#Cheryl Ngo
#Module 6 Data Assignment
#August 11, 2019

####Read in the data####
setwd("C:\\Users\\chery\\Grad School\\BUAD 5122-ML1\\M6-Regression and Classification for Counting Situations\\Data Assignment")
wine = read.csv("buad5122-m6-wine-training.csv")
test_wine = read.csv("buad5122-m6-wine-test.csv")

#Examine the data
summary(wine)
str(wine)

####Data Exploration####

library(ggplot2)
#Graphically examine data
par(mfrow=c(2,2))
for (i in 2:16){
  hist(wine[,i], col = "steel blue", xlab = paste(colnames(wine[i])), main = paste("Histogram of",colnames(wine[i]))) 
  boxplot(wine[,i], col = "dark blue", main = paste("Boxplot of",colnames(wine[i])))
}

#View AcidIndex transformed for normality
hist(sqrt(wine$AcidIndex), col = "steel blue", xlab = "AcidIndex", main = "Histogram of AcidIndex")
boxplot(sqrt(wine$AcidIndex), col = "dark blue", main = "Boxplot of AcidIndex")
par(mfrow=c(1,1))

#Examine correlation
wine_clean = na.omit(wine)
cor(wine_clean[sapply(wine, is.numeric)]) #TARGET is most correlated with STARS and LabelAppeal

####Data Transformation####
#Change index to a factor

outlier_impute=function(df,dftest,column){
  data_mean = mean(dftest[,column])
  data_std = sd(dftest[,column])
  cut_off = data_std * 3
  min = data_mean - cut_off
  max = data_mean + cut_off
  flgO=as.factor(ifelse(dftest[,column] %in% df[,column][df[,column]<min|df[,column]>max], 1, 0))
  impO=as.numeric(ifelse(dftest[,column]%in% df[,column][df[,column]<min],min,ifelse(dftest[,column]%in% df[,column][df[,column]>max], max, dftest[,column])))
  eval.parent(substitute(dftest[,column]<-impO))
  eval.parent(substitute(dftest$flag<-flgO))
}

#Create function to correct for missing values
missing_impute=function(df,dftest,column){
  flgM=as.factor(ifelse(is.na(dftest[,column]),1,0))
  impM=as.numeric(ifelse(is.na(dftest[,column]),median(df[,column],na.rm=TRUE),dftest[,column]))
  eval.parent(substitute(dftest$flag<-flgM))
  eval.parent(substitute(dftest[,column]<-impM))
}

for (i in 2:16){
  missing_impute(wine,wine,i)
  colnames(wine)[2*(i-1)+15]=paste("flagMissing",colnames(wine)[i],sep="_")
  outlier_impute(wine,wine,i)
  colnames(wine)[2*(i-1)+16]=paste("flagOutlier",colnames(wine)[i],sep="_")
}
wine=wine[,colSums(wine!=0)>0|is.na(colSums(wine!=0))] #Remove missing value or outlier flag for variables with no missing values or outliers

#Perform squareroot transformation for AcidIndex
wine$sqrt_AcidIndex=sqrt(wine$AcidIndex)

#Assuming normalized values of FixedAcidity and VolatileAcidity, summary looks good
summary(wine)

#make new indicator that indicates red vs white based on volatile acidity
wine$VolatileAcidity_REDFLAG = ifelse(wine$VolatileAcidity > mean(wine$VolatileAcidity),1,0)
wine$ResidualSugar_REDFLAG = ifelse(wine$ResidualSugar < mean(wine$ResidualSugar),1,0)
wine$TotalSulfurDioxide_REDFLAG = ifelse(wine$TotalSulfurDioxide < mean(wine$TotalSulfurDioxide),1,0)
wine$Density_REDFLAG = ifelse(wine$Density > mean(wine$Density),1,0)
wine$TallyUp = wine$VolatileAcidity_REDFLAG + wine$ResidualSugar_REDFLAG + wine$TotalSulfurDioxide_REDFLAG + wine$Density_REDFLAG
wine$Final_REDFLAG = ifelse(wine$TallyUp > mean(wine$TallyUp),1,0)

####Model 1: Linear Regression####
set.seed(1)
train=sample(12795,6398)
test=-train

attach(wine)
m1.lm = glm(TARGET~ .-INDEX, data = wine,subset=train)

summary(m1.lm)
coefficients(m1.lm)
m1.pred=predict(m1.lm,wine[test,],type="response")
m1.MSE=mean((TARGET[test]-m1.pred)^2) #1.75338

m1.lm = step(m1.lm, direction="both",subset=train) #AIC 21319.06
summary(m1.lm)

# m1.lm = glm(TARGET ~ ResidualSugar + Chlorides + FreeSulfurDioxide + 
#                Density + Alcohol + LabelAppeal + AcidIndex + STARS + flagOutlier_VolatileAcidity + 
#                flagOutlier_CitricAcid + flagOutlier_ResidualSugar + flagOutlier_Density + 
#                flagOutlier_Alcohol + flagOutlier_AcidIndex + flagOutlier_STARS + 
#                sqrt_AcidIndex + VolatileAcidity_REDFLAG + ResidualSugar_REDFLAG + 
#                TotalSulfurDioxide_REDFLAG + Density_REDFLAG, data = wine, 
#              subset = train)

summary(m1.lm)
logLik(m1.lm) #-10635.53 (df=24)
m1.pred=predict(m1.lm,wine[test,],type="response")
m1.MSE=mean((TARGET[test]-m1.pred)^2) #1.748784

####Model 2: Poisson Regression####
m2.poisson = glm(TARGET ~ .,
                 family="poisson"(link="log"), data=wine, subset=train)

summary(m2.poisson) #AIC: 22781
logLik(m2.poisson) #-11348.45 (df=42)
coef(m2.poisson) 
m2.pred=predict(m2.poisson,wine[test,],type="response")
hist(m2.pred)
m2.MSE=mean((TARGET[test]-m2.pred)^2) #1.779

#Bootstrap Forward Selection Poisson
library(FWDselect) #https://cran.r-project.org/web/packages/FWDselect/FWDselect.pdf
#m2.poisson.boot=test(wine[train,c(3:14,16:43)], wine[train,2], method = "glm", family="poisson", nboot = 50,speedup=TRUE) #Results in q=10 for full data and 6 for training data
m2.poisson.fwd = selection(wine[train,c(3:14,16:43)], wine[train,2], q =10, nfolds=10,method = "glm",family="poisson")
 #Dev: 1312.304

#From Poisson forward selection q=10
m2.poisson.fwd = glm(TARGET ~ flagMissing_STARS+STARS+LabelAppeal+TallyUp+sqrt_AcidIndex+
                   AcidIndex+ResidualSugar+Alcohol+FreeSulfurDioxide+Chlorides,
                family="poisson"(link="log"), data=wine, subset=train) #AIC 22742.84
logLik(m2.poisson.fwd)#-11367.76 (df=11)
m2.pred.fwd=predict(m2.poisson.fwd,wine[test,],type="response")
m2.MSE.fwd=mean((TARGET[test]-m2.pred.fwd)^2) #1.774612

#####Model 3: Negative Binomial#####
library(MASS)
m3.nbr=glm.nb(TARGET ~ flagMissing_STARS+STARS+LabelAppeal+AcidIndex+TallyUp+sqrt_AcidIndex+
                ResidualSugar+Alcohol+FreeSulfurDioxide+Chlorides, data=wine,subset=train) #AIC 22745.04

summary(m3.nbr)
logLik(m3.nbr) #-11348.63 (df=42)

m3.pred=predict(m3.nbr, newdata = wine[test,], type = "response")
hist(m3.pred)
m3.MSE=mean((TARGET[test]-m3.pred)^2) #1.774615

####Model 4: Zero Inflated Poisson####
library(pscl)
m4.zi.poisson=zeroinfl(TARGET ~ flagMissing_STARS+STARS+LabelAppeal+AcidIndex+TallyUp+sqrt_AcidIndex+
                         ResidualSugar+Alcohol+FreeSulfurDioxide+Chlorides, data=wine,subset=train) #lokLik -10218.31

summary(m4.zi.poisson)
logLik(m4.zi.poisson) #-10237.1 (df=28)
m4.pred = predict(m4.zi.poisson,wine[test,], type = "response")
hist(m4.pred)
m4.MSE=mean((TARGET[test]-m4.pred)^2) #1.646077

####Model 5: Zero-Inflated Negative Binomial Regression####
m5.zi.nbr=zeroinfl(TARGET ~ flagMissing_STARS+STARS+LabelAppeal+AcidIndex+TallyUp+sqrt_AcidIndex+
                     ResidualSugar+Alcohol+FreeSulfurDioxide+Chlorides, data=wine, dist = "negbin", EM=TRUE, subset=train)

summary(m5.zi.nbr)
logLik(m5.zi.nbr) #-10218.35 (df=23)
m5.pred = predict(m5.zi.nbr,wine[test,], type = "response")
hist(m5.pred)
m5.MSE=mean((TARGET[test]-m5.pred)^2) #1.643069

# #ROC Curves
# wine$TARGET_Flag <- ifelse(wine$TARGET >0,1,0)
# par(mfrow=c(2,1))
# library(ROCR)
# 
# #Model 1 ROC
# m1.sale = ifelse(m1.pred >=1,1,0)
# m1.prediction=prediction(m1.sale,wine$TARGET_Flag[test])
# m1.perf=performance(m1.prediction,"tpr","fpr")
# plot(glm1.perf)
# m1.auc=performance(m1.prediction, measure = "auc")@y.values[[1]]
# 
# #Model 2 ROC
# m2.sale = ifelse(m2.pred >=1,1,0)
# m2.prediction=prediction(m1.sale,wine$TARGET_Flag[test])
# m2.perf=performance(m2.prediction,"tpr","fpr")
# plot(m2.perf)
# m2.auc=performance(m2.prediction, measure = "auc")@y.values[[1]]
# 
# #Model 5 ROC
# m5.sale = ifelse(m5.pred >=1,1,0)
# m5.prediction=prediction(m5.sale,wine$TARGET_Flag[test])
# m5.perf=performance(m5.prediction,"tpr","fpr")
# plot(m5.perf)
# m5.auc=performance(m5.prediction, measure = "auc")@y.values[[1]]

####Test File####

####Data Transformation Code#####

for (i in 2:16){
  missing_impute(wine,test_wine,i)
  colnames(test_wine)[2*(i-1)+15]=paste("flagMissing",colnames(test_wine)[i],sep="_")
  outlier_impute(wine,test_wine,i)
  colnames(test_wine)[2*(i-1)+16]=paste("flagOutlier",colnames(test_wine)[i],sep="_")
}
test_wine=test_wine[,colSums(test_wine!=0)>0|is.na(colSums(test_wine!=0))] #Remove missing value or outlier flag for variables with no missing values or outliers

#Perform squareroot transformation for AcidIndex
test_wine$sqrt_AcidIndex=sqrt(test_wine$AcidIndex)

#make new indicator that indicates red vs white based on volatile acidity
test_wine$VolatileAcidity_REDFLAG = ifelse(test_wine$VolatileAcidity > mean(test_wine$VolatileAcidity),1,0)
test_wine$ResidualSugar_REDFLAG = ifelse(test_wine$ResidualSugar < mean(test_wine$ResidualSugar),1,0)
test_wine$TotalSulfurDioxide_REDFLAG = ifelse(test_wine$TotalSulfurDioxide < mean(test_wine$TotalSulfurDioxide),1,0)
test_wine$Density_REDFLAG = ifelse(test_wine$Density > mean(test_wine$Density),1,0)
test_wine$TallyUp = test_wine$VolatileAcidity_REDFLAG + test_wine$ResidualSugar_REDFLAG + test_wine$TotalSulfurDioxide_REDFLAG + test_wine$Density_REDFLAG
test_wine$Final_REDFLAG = ifelse(test_wine$TallyUp > mean(test_wine$TallyUp),1,0)

# Again, double-checking to make sure we don't have any NA's in our Test Data Set
summary(test_wine)

####Choose Model####
#Chose zero-inflated negative binomial regression
final.model=zeroinfl(TARGET ~ flagMissing_STARS+STARS+LabelAppeal+AcidIndex+TallyUp+sqrt_AcidIndex+
                       ResidualSugar+Alcohol+FreeSulfurDioxide+Chlorides, data=wine, dist = "negbin", EM=TRUE)

test_wine$TARGET = predict(final.model, newdata = test_wine, type = "response")

select = dplyr::select

# Scored Data File
scores = test_wine[c("INDEX","TARGET")]
write.csv(scores, file = "M6OutputCherylNgo.csv",row.names=FALSE)