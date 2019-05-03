#Question one a
p<-function(x1,x2){z<-exp(-16+1.4*x1+0.3*x2);return(z/(1+z))}
p(5,36)


#Question one b 
hours<-seq(5,10,0.25)
probs<-mapply(hours,18,FUN=p)
names(probs)<-paste0(hours,"h")
probs

#Question two a.
train<- "BankTrain.csv" %>%
  read_csv(col_names = TRUE)
glimpse(train)

Training<-train

md1 <- glm(y~x1+x3,family=binomial(link='logit'),data=train)
summary(md1)
plot(md1)


#Question two b.

bs <- function(formula, data, indices) {
  d <- data[indices,] # allows boot to select sample 
  fit <- glm(formula, data=d,family=binomial)
  return(coef(fit)) 
} 
# bootstrapping with 1000 replications 
results <- boot(data=train, statistic=bs, 
                R=1000, formula=y~x1+x3)
# view results
results
plot(results, index=1) # intercept 
plot(results, index=2) # x1 
plot(results, index=3) # x2

#Question two C(1).

colnames(Training) <- c("Variance", "","Kurtosis","","Banknote")
X <- Training[ , -4:-5]
X<- X[,-2]
y <- Training[,5]
dftrain<-cbind.data.frame(X,y)
plot( X$Variance,  X$Kurtosis, 
      xlab = "Variance", ylab = "Kurtosis",
      #legend("topleft", 
      #legend = c("Real_note", "Not_real "),
      col= c("cyan","magenta")[as.factor(y$Banknote)], 
      pch= c(16, 18)[as.factor(y$Banknote)],
      main= "Training data: In cyan real note , in magenta not real note")
slope <- coef(md1)[2]/(-coef(md1)[3])
intercept <- coef(md1)[1]/(-coef(md1)[3]) 
abline(intercept, slope, col = 'black', lwd = 2)

#Question 2 C(11) Using ?? = 0.5, compute the confusion matrix for the testing set and comment
#on your output.

test<- "BankTest.csv" %>%
  read_csv(col_names = TRUE)
glimpse(test)

testing<-test

#confusion matrix
fit.glm <- predict(md1, newdata=testing, type="response")
confmat<-table(testing$y, ifelse( fit.glm >= 0.5, "Forged", "Real"))
rownames(confmat) <- c("Real", "Forged")
confmat
pred_glm = 1*(fit.glm >= 0.5)
mean( testing$y == pred_glm )
mean(testing$y!= pred_glm)


#Question 2 C(11). Find a value of ?? that reduces the training error as much as possible. Compute
#the confusion matrix for the testing set using your best ?? value and comment
#on your output.

fit.glm2 <- predict(md1,  type="response")
optCutOff <- optimalCutoff(train$y, fit.glm2)[1]
optCutOff

fit.glm1 <- predict(md1, newdata=testing, type="response")
confmat<-table(testing$y, ifelse( fit.glm1 >= 0.41, "Yes", "No"))
rownames(confmat) <- c("No", "Yes")
pred_glm = 1*(fit.glm1 >= 0.41)
mean( testing$y == pred_glm )
mean(testing$y!= pred_glm)
mean(train$y !=pred_glm)
confmat

#Question 3

#In this question, you will fit linear discriminant analysis (LDA) and quadratic
#discriminant analysis (QDA) models to the training set from question 2 of this assignment.
#(a) Fit an LDA model to predict the probability of a banknote being forged using the
#predictors x1 and x3. Compute the training and test error (using the testing set
#                                                           from question 2).

#
fit.lda <- lda(y~ x1 + x3 , data = train)
fit.lda
test.predicted.lda <- predict(fit.lda, newdata = testing)
train.predicted.lda<-predict(fit.lda,newdata = train)
ldaaccuracytest<-mean(test.predicted.lda$class == testing$y)
ldaaccuracytrain<-mean(train.predicted.lda$class == train$y)
ldaerrortest<-mean(test.predicted.lda$class != testing$y)
ldaerrortrain<-mean(train.predicted.lda$class != train$y)

#(b) Repeat part (a) using QDA.

qda.fit <- qda(y ~ x1 + x3, data = train)
qda.fit
test.predicted.qda <- predict(qda.fit, newdata = testing)
train.predicted.qda<-predict(qda.fit,newdata = train)
QDAaccuracytest<-mean(test.predicted.qda$class == testing$y)
QDAaccuracytrain<-mean(train.predicted.qda$class == train$y)
QDAerrortest<-mean(test.predicted.qda$class != testing$y)

QDAerrortrain<-mean(train.predicted.qda$class != train$y)



#(c) Comment on your results from parts (a) and (b). Compare these methods with
#the logistic regression model from question 2. Which method would you recommend
#and why?

require(ROCR)

p1 <- prediction(fit.glm, testing$y) %>%
  performance(measure = "tpr", x.measure = "fpr")
plot(p1,col = "red")
p2 <- prediction(test.predicted.lda$posterior[,2], testing$y) %>%
  performance(measure = "tpr", x.measure = "fpr")
plot(p2,add = TRUE,col ="green")
p3 <- prediction(test.predicted.qda$posterior[,2], testing$y) %>%
  performance(measure = "tpr", x.measure = "fpr")
plot(p3,add = TRUE,col = "blue")


#

#4. Consider a binary classification problem Y ??? {0, 1} with one predictor X.
#Assume that X is normally distributed (X ??? N(µ, ??2)) in each class with X ??? N(0,4) in
#class 0 and X ??? N(2,4) in class 1. Calculate Bayes error rate when the prior probability
#of being in class 0 is ??0 = 0.4. (Bayes error rate is the test error rate using Bayes classifier.)


require(lattice)
#
set.seed(42)

# parameters for distribution of class 1
a <- 0
b <- 2
# parameters for distribution of class 2
c <- 2
d <- 2

c_1 <-function(x) dnorm(x1,a,b)*0.6
c_2 <-function(x) dnorm(x2,c,d)*0.4
x1 <- c(0:10,mean=a , sd=b)
x2<- c(0:10,mean=c,sd=d)
dat<-data.frame(x1,x2)

#y <- c((x[1:1000],mean=a,sd=b),(x[1001:2000],mean=c,sd=d))
labels <- factor(rep(c("class 1","class 2"),each=1000))
plot(c_1, dat, col="darkgreen",xlab="", ylab="Density", type="l",lwd=2, cex=2, main="PDF of Standard Normal", cex.axis=.8)
dat <- data.frame("x"=x,"density"=y,"groups"=labels)
xyplot(density~x,data=dat,groups=labels,type="b",auto.key=T)


x = seq(-4, 8, 0.1)
mean1 = 0
mean2 = 2
dat <- data.frame(x = x, y1 = dnorm(x, mean1, 2)*0.4, y2 = dnorm(x, mean2, 2)*0.6)
p<-ggplot(dat, aes(x = x)) +
  geom_line(aes(y = y1, colour = 'H0 is true'), size = 1.2) +
  geom_line(aes(y = y2, colour = 'H1 is true'), size = 1.2) +
  geom_area(aes(y = y1, x = ifelse(x > 0.189068, x, NA)), fill = 'blue') +
  geom_area(aes(y = y2, x = ifelse(x <= 0.189068, x, NA)), fill = 'red', alpha = 0.3) +
  xlab("") + ylab("") + theme(legend.title = element_blank()) +
  scale_colour_manual(breaks = c("Class0 is true", "Class1 is true"), values = c("blue", "red"))
p+geom_vline(xintercept = 0.189068,size = 1.5,linetype = 8)

