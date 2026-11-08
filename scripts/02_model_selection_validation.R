# ==============================================================================
# Script:      02_model_selection_validation.R
# Description: Exhaustive, Forward, and Backward subset selection, LOOCV /
#              k-Fold Cross-Validation, and repeated Validation Set splitting.
# ==============================================================================

library(leaps)
library(boot)
library(ISLR)

# ------------------------------------------------------------------------------
# Teil 1: Best-Subset-, Forward- und Backward-Selektion
# ------------------------------------------------------------------------------
cat("\n========================================================================\n")
cat("  1. SUBSET SELECTION: EXHAUSTIVE, FORWARD & BACKWARD (CP, BIC, ADJ-R2)\n")
cat("========================================================================\n")

set.seed(123)
n <- 100
X <- rnorm(n)
eps <- rnorm(n)
Y <- 1 - X + 3 * X^2 + 2 * X^3 + eps
poly_data <- data.frame(Y = Y, X = X, X2 = X^2, X3 = X^3, X4 = X^4,
                        X5 = X^5, X6 = X^6, X7 = X^7, X8 = X^8, X9 = X^9, X10 = X^10)

exhaustive_fit <- regsubsets(Y ~ ., data = poly_data, nvmax = 10, method = "exhaustive")
forward_fit    <- regsubsets(Y ~ ., data = poly_data, nvmax = 10, method = "forward")
backward_fit   <- regsubsets(Y ~ ., data = poly_data, nvmax = 10, method = "backward")

ex_summary <- summary(exhaustive_fit)
cat("Exhaustive Selection Optimale Variablenanzahl:\n")
cat("  - Min Mallows' Cp :", which.min(ex_summary$cp), "Variablen\n")
cat("  - Min BIC         :", which.min(ex_summary$bic), "Variablen\n")
cat("  - Max Adjustiertes R²:", which.max(ex_summary$adjr2), "Variablen\n")

# ------------------------------------------------------------------------------
# Teil 2: Resampling & Validierung auf dem Default-Datensatz
# ------------------------------------------------------------------------------
cat("\n========================================================================\n")
cat("  2. VALIDATION SET APPROACH ON DEFAULT DATASET (3 RANDOM SEEDS)\n")
cat("========================================================================\n")

data(Default)
calc_default_err <- function(seed_val) {
  set.seed(seed_val)
  t_idx <- sample(1:nrow(Default), 0.7 * nrow(Default))
  tr <- Default[t_idx, ]
  te <- Default[-t_idx, ]
  fit <- glm(default ~ income + balance, data = tr, family = "binomial")
  preds <- ifelse(predict(fit, te, type = "response") > 0.5, "Yes", "No")
  return(mean(preds != te$default))
}

seeds <- c(123, 456, 789)
err_rates <- sapply(seeds, calc_default_err)
for (i in seq_along(seeds)) {
  cat(sprintf("  Seed %d -> Test-Fehlerrate: %.4f (%.2f %%)\n", seeds[i], err_rates[i], err_rates[i] * 100))
}
cat(sprintf("  Mittlere Test-Fehlerrate: %.4f\n", mean(err_rates)))

# ------------------------------------------------------------------------------
# Teil 3: Kreuzvalidierung polynomialer Grade (cv.glm)
# ------------------------------------------------------------------------------
cat("\n========================================================================\n")
cat("  3. POLYNOMIAL CROSS-VALIDATION (DEGREES 1 TO 4)\n")
cat("========================================================================\n")

set.seed(1)
x_sim <- rnorm(100)
y_sim <- 1 * x_sim^4 - 1 * x_sim^3 + 3 * x_sim^2 + 2 * x_sim + rnorm(100)
cv_data <- data.frame(x = x_sim, y = y_sim)

cv_errors <- numeric(4)
for (d in 1:4) {
  glm_poly <- glm(y ~ poly(x, d), data = cv_data, family = "gaussian")
  cv_errors[d] <- cv.glm(cv_data, glm_poly)$delta[1]
  cat(sprintf("  Grad %d -> CV-Fehler (MSE): %.4f\n", d, cv_errors[d]))
}
cat("  Optimaler polynomialer Grad laut CV:", which.min(cv_errors), "\n")
