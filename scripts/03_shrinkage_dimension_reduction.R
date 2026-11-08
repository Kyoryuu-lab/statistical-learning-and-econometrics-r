# ==============================================================================
# Script:      03_shrinkage_dimension_reduction.R
# Description: Regularized shrinkage models (Ridge, Lasso via glmnet) and latent
#              dimension reduction techniques (PCR, PLS via pls) on College data.
# ==============================================================================

library(ISLR)
library(glmnet)
library(pls)

data("College")
set.seed(123)

n <- nrow(College)
train_idx <- sample(1:n, size = round(0.7 * n))
train <- College[train_idx, ]
test  <- College[-train_idx, ]

x_train <- model.matrix(Apps ~ . - 1, data = train)
y_train <- train$Apps
x_test  <- model.matrix(Apps ~ . - 1, data = test)
y_test  <- test$Apps

cat("\n========================================================================\n")
cat("  SHRINKAGE & DIMENSION REDUCTION BENCHMARK (COLLEGE: APPS TARGET)\n")
cat("========================================================================\n")

# 1. OLS Baseline
ols_fit <- lm(Apps ~ ., data = train)
ols_pred <- predict(ols_fit, newdata = test)
ols_rmse <- sqrt(mean((ols_pred - y_test)^2))

# 2. Ridge Regression (alpha = 0)
cv_ridge <- cv.glmnet(x_train, y_train, alpha = 0)
ridge_pred <- predict(cv_ridge, s = "lambda.min", newx = x_test)
ridge_rmse <- sqrt(mean((ridge_pred - y_test)^2))

# 3. Lasso Regression (alpha = 1)
cv_lasso <- cv.glmnet(x_train, y_train, alpha = 1)
lasso_pred <- predict(cv_lasso, s = "lambda.min", newx = x_test)
lasso_rmse <- sqrt(mean((lasso_pred - y_test)^2))
lasso_nonzero <- sum(coef(cv_lasso, s = "lambda.min") != 0) - 1

# 4. Principal Components Regression (PCR)
pcr_fit <- pcr(Apps ~ ., data = train, scale = TRUE, validation = "CV")
opt_pcr_m <- which.min(pcr_fit$validation$MSEP)
pcr_pred <- predict(pcr_fit, newdata = test, ncomp = opt_pcr_m)
pcr_rmse <- sqrt(mean((pcr_pred - y_test)^2))

# 5. Partial Least Squares (PLS)
pls_fit <- plsr(Apps ~ ., data = train, scale = TRUE, validation = "CV")
opt_pls_m <- which.min(pls_fit$validation$MSEP)
pls_pred <- predict(pls_fit, newdata = test, ncomp = opt_pls_m)
pls_rmse <- sqrt(mean((pls_pred - y_test)^2))

# Zusammenfassung
cat(sprintf("  %-25s | Test-RMSE: %10.2f\n", "OLS Linear Regression", ols_rmse))
cat(sprintf("  %-25s | Test-RMSE: %10.2f (lambda: %.2f)\n", "Ridge Regression", ridge_rmse, cv_ridge$lambda.min))
cat(sprintf("  %-25s | Test-RMSE: %10.2f (lambda: %.2f, Non-Zero: %d)\n", "Lasso Regression", lasso_rmse, cv_lasso$lambda.min, lasso_nonzero))
cat(sprintf("  %-25s | Test-RMSE: %10.2f (Opt. Komponenten M: %d)\n", "PCR (Principal Components)", pcr_rmse, opt_pcr_m))
cat(sprintf("  %-25s | Test-RMSE: %10.2f (Opt. Komponenten M: %d)\n", "PLS (Partial Least Squares)", pls_rmse, opt_pls_m))
