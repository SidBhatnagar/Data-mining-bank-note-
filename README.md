Suppose we collect data for a group of students that have taken STAT318 with variables X1 = hours spent studying per week, X2 = number of classes attended and Y = ( 1 if the student received a GPA value ≥ 7 in STAT318 0 otherwise. We fit a logistic regression model and find the estimated coefficients to be βˆ 0 = −16, βˆ 1 = 1.4 and βˆ 2 = 0.3.
Estimate the probability of a student getting a GPA value ≥ 7 in STAT318 if they study for 5 hours per week and attend all 36 classes. 
		
If a student attends 18 classes, how many hours do they need to study per week to have a 50% chance of getting a GPA value ≥ 7 in STAT318?

In this question, you will fit a logistic regression model to predict the probability of a banknote being forged using the Banknote data set. This data has been divided into training and testing sets: BankTrain.csv and BankTest.csv (download these sets from Learn). The response variable is y (the fifth column), where y = 1 denotes a forged banknote and y = 0 denotes a genuine banknote. Although this data set has four predictors, you will be using x1 and x3 to fit your model . 
Perform multiple logistic regression using the training data. Comment on the model obtained. 
Estimate the standard errors for βˆ 1 and βˆ 2 (regression coefficients for x1 and x3) using the bootstrap. 
Suppose we classify observations using f(x) = ( forged banknote if Pr(Y = 1|X = x) > θ genuine banknote otherwise. 
i. Plot the training data (using a different symbol for each class) and the decision boundary for θ = 0.5 on the same figure
ii. Using θ = 0.5, compute the confusion matrix for the testing set and comment on your output. 
iii. Find a value of θ that reduces the training error as much as possible. Compute the confusion matrix for the testing set using your best θ value and comment on your output.

3.  In this question, you will fit linear discriminant analysis (LDA) and quadratic discriminant analysis (QDA) models to the training set from question 2 of this assignment. 
 Fit an LDA model to predict the probability of a banknote being forged using the predictors x1 and x3. Compute the training and test error (using the testing set from question 2).
Repeat part (a) using QDA.
Comment on your results from parts (a) and (b). Compare these methods with the logistic regression model from question 2. Which method would you recommend and why? 

4.  Consider a binary classification problem Y ∈ {0, 1} with one predictor X. Assume that X is  normally distributed (X ∼ N(µ, σ2 )) in each class with X ∼ N(0,4) in class 0 and X ∼ N(2,4) in class 1. Calculate Bayes error rate when the prior probability of being in class 0 is π0 = 0.4. (Bayes error rate is the test error rate using Bayes classifier.) 
