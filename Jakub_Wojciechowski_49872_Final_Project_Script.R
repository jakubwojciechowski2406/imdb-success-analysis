# Final Project Script
# Objective: Identify factors associated with IMDb movie success.
# Success definition: success = 1 if IMDB_Rating >= 8, else 0.
# Full interpretation of results is provided in the report.

# 1. Loading and checking dataset
# Loaded the IMDb Top 1000 dataset and checked its structure.
df <- read.csv('imdb_top_1000.csv', stringsAsFactors = FALSE)
str(df)
dim(df)
names(df)
head(df, 3)
colSums(is.na(df))

# 2. Dependent variable
# Created binary success variable based on IMDb rating.
df$success <- ifelse(df$IMDB_Rating >= 8, 1, 0)
table(df$success)
prop.table(table(df$success))

# 3. Independent variables
# Converted runtime and release year to numeric.
df$Runtime_num <- as.numeric(gsub(" min", "", df$Runtime))
summary(df$Runtime_num)
df$Released_Year_num <- as.numeric(df$Released_Year)
summary(df$Released_Year_num)

# Idea suggested by AI:
# Log-transformed number of votes to reduce skewness.
df$log_votes <- log(df$No_of_Votes + 1)
summary(df$log_votes)

# Removed rows with missing release year.
df <- df[!is.na(df$Released_Year_num), ]
nrow(df)

# 4. Exploratory Data Analysis
# Checked distributions and differences between success groups.
hist(df$IMDB_Rating,
     main = "Distribution of IMDb ratings",
     xlab = "IMDb rating")
abline(v = 8, lty = 2)
hist(df$log_votes,
     main = "Log-transformed number of votes",
     xlab = "log(Number of votes)")
hist(df$Runtime_num,
     main = "Runtime distribution",
     xlab = "Runtime (minutes)")
boxplot(log_votes ~ success,
        data = df,
        names = c("Rating < 8", "Rating ≥ 8"),
        main = "Popularity (log votes) vs IMDb success",
        ylab = "log(Number of votes)")
wilcox.test(log_votes ~ success, data = df)
boxplot(Runtime_num ~ success,
        data = df,
        names = c("Rating < 8", "Rating ≥ 8"),
        main = "Runtime vs IMDb success",
        ylab = "Runtime (minutes)")
wilcox.test(Runtime_num ~ success, data = df)
boxplot(Released_Year_num ~ success,
        data = df,
        names = c("Rating < 8", "Rating ≥ 8"),
        main = "Release year vs IMDb success",
        ylab = "Release year")
wilcox.test(Released_Year_num ~ success, data = df)

# 5. Logistic regression models
# Fitted baseline and extended logistic regression models.
model_1 <- glm(success ~ log_votes,
               data = df,
               family = binomial)
summary(model_1)
exp(coef(model_1))
model_2 <- glm(success ~ log_votes + Runtime_num + Released_Year_num,
               data = df,
               family = binomial)
summary(model_2)

# Compared models.
anova(model_1, model_2, test = "Chisq")

# 6. Model diagnostics
# Checked multicollinearity using VIF.
library(car)
vif(model_2)

# Odds ratios with confidence intervals.
exp(cbind(OR = coef(model_2),
          confint(model_2)))

# 7. Predicted probabilities
# Computed predicted success probabilities.
df$predicted_p <- predict(model_2, type = "response")
summary(df$predicted_p)

# Assisted by AI:
# Created prediction grid for visualization.
log_votes_seq <- seq(min(df$log_votes),
                     max(df$log_votes),
                     length.out = 100)

newdata <- data.frame(
  log_votes = log_votes_seq,
  Runtime_num = median(df$Runtime_num),
  Released_Year_num = median(df$Released_Year_num)
)

newdata$predicted_p <- predict(model_2,
                               newdata = newdata,
                               type = "response")
plot(newdata$log_votes,
     newdata$predicted_p,
     type = "l", lwd = 2,
     ylim=c(0,1),
     xlab = "log(Number of votes)",
     ylab = "Predicted probability of success",
     main = "Predicted probability of IMDb success vs popularity")
newdata[c(1, 50, 100), c("log_votes", "predicted_p")]

# 8. Model performance
# Idea suggested by AI:
# Used 0.5 threshold to compute confusion matrix and metrics.
df$pred_class_05 <- ifelse(df$predicted_p >= 0.5, 1, 0)
tab_05 <- table(Predicted = df$pred_class_05, Actual = df$success)
tab_05
TN <- tab_05["0","0"]
FP <- tab_05["1","0"]
FN <- tab_05["0","1"]
TP <- tab_05["1","1"]
accuracy <- (TP + TN) / (TP + TN + FP + FN)
sensitivity <- TP / (TP + FN)
specificity <- TN / (TN + FP)
c(accuracy = accuracy,
  sensitivity = sensitivity,
  specificity = specificity)