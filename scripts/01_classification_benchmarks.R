# ==============================================================================
# Script:      01_classification_benchmarks.R
# Description: Supervised classification benchmarks comparing Logistic GLM,
#              Linear Discriminant Analysis (LDA), Quadratic Discriminant
#              Analysis (QDA), and K-Nearest Neighbors (KNN).
# ==============================================================================

library(MASS)
library(class)
library(ISLR)

# ------------------------------------------------------------------------------
# Teil 1: Kriminalitätsklassifikation auf dem Boston-Datensatz
# ------------------------------------------------------------------------------
cat("\n========================================================================\n")
cat("  1. BOSTON DATASET: CRIME RATE CLASSIFICATION (ABOVE/BELOW MEDIAN)\n")
cat("========================================================================\n")

data(Boston)
boston_df <- Boston
boston_df$CrimeAboveMedian <- ifelse(boston_df$crim > median(boston_df$crim), 1, 0)

set.seed(123)
train_idx <- sample(1:nrow(boston_df), 0.7 * nrow(boston_df))
train_b <- boston_df[train_idx, ]
test_b  <- boston_df[-train_idx, ]

# Modelle trainieren (ohne crim und Zielvariable als Prädiktoren)
pred_vars <- names(boston_df)[!names(boston_df) %in% c("crim", "CrimeAboveMedian")]
form <- as.formula(paste("CrimeAboveMedian ~", paste(pred_vars, collapse = " + ")))

logit_m <- glm(form, data = train_b, family = "binomial")
lda_m   <- lda(form, data = train_b)
knn_pred <- knn(train = scale(train_b[, pred_vars]),
                test  = scale(test_b[, pred_vars]),
                cl    = train_b$CrimeAboveMedian, k = 5)

# Vorhersagen
logit_pred <- ifelse(predict(logit_m, newdata = test_b, type = "response") > 0.5, 1, 0)
lda_pred   <- predict(lda_m, newdata = test_b)$class

acc_logit <- mean(logit_pred == test_b$CrimeAboveMedian)
acc_lda   <- mean(lda_pred == test_b$CrimeAboveMedian)
acc_knn   <- mean(knn_pred == test_b$CrimeAboveMedian)

cat(sprintf("Test-Genauigkeit (Accuracy) - GLM: %.4f | LDA: %.4f | KNN (k=5): %.4f\n",
            acc_logit, acc_lda, acc_knn))

# ------------------------------------------------------------------------------
# Teil 2: Markttrend-Klassifikation auf dem Weekly-Datensatz
# ------------------------------------------------------------------------------
cat("\n========================================================================\n")
cat("  2. WEEKLY DATASET: S&P STOCK DIRECTION (UP / DOWN)\n")
cat("========================================================================\n")

data("Weekly")
train_w <- Weekly[Weekly$Year <= 2009, ]
test_w  <- Weekly[Weekly$Year > 2009, ]

glm_w <- glm(Direction ~ Lag2, data = train_w, family = binomial)
lda_w <- lda(Direction ~ Lag2, data = train_w)
qda_w <- qda(Direction ~ Lag2, data = train_w)
knn_w <- knn(train = as.matrix(train_w$Lag2), test = as.matrix(test_w$Lag2),
             cl = train_w$Direction, k = 1)

glm_w_pred <- ifelse(predict(glm_w, test_w, type = "response") > 0.5, "Up", "Down")
lda_w_pred <- predict(lda_w, test_w)$class
qda_w_pred <- predict(qda_w, test_w)$class

cat(sprintf("Test-Genauigkeit - GLM: %.4f | LDA: %.4f | QDA: %.4f | KNN (k=1): %.4f\n",
            mean(glm_w_pred == test_w$Direction),
            mean(lda_w_pred == test_w$Direction),
            mean(qda_w_pred == test_w$Direction),
            mean(knn_w == test_w$Direction)))
