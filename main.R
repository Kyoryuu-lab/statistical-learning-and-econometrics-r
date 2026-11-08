# ==============================================================================
# Project:     Statistical Learning & Econometrics Suite in R
# File:        main.R
# Author:      Yevhen Biezhyn
# Description: Automated master runner executing all 5 statistical learning,
#              shrinkage, clustering, and econometric diagnostic pipelines.
# ==============================================================================

# Automatische Installation fehlender Pakete
required_packages <- c("MASS", "class", "ISLR", "leaps", "glmnet", "pls",
                       "boot", "cluster", "lmtest")
missing_packages <- required_packages[!(required_packages %in% installed.packages()[, "Package"])]
if (length(missing_packages) > 0) {
  cat("[*] Installiere fehlende R-Pakete:", paste(missing_packages, collapse = ", "), "\n")
  install.packages(missing_packages, repos = "https://cloud.r-project.org")
}

run_module <- function(script_path, label) {
  cat("\n" + paste(rep("=", 80), collapse = "") + "\n")
  cat("  MODULE:", toupper(label), "\n")
  cat(paste(rep("=", 80), collapse = "") + "\n")
  source(script_path)
}

main <- function() {
  cat("\n================================================================================\n")
  cat("  ADVANCED STATISTICAL LEARNING & ECONOMETRIC DIAGNOSTICS IN R\n")
  cat("================================================================================\n")

  run_module("scripts/01_classification_benchmarks.R", "Classification Benchmarks (GLM, LDA, QDA, KNN)")
  run_module("scripts/02_model_selection_validation.R", "Model Selection & Resampling Validation")
  run_module("scripts/03_shrinkage_dimension_reduction.R", "Shrinkage & Dimension Reduction (Ridge, Lasso, PCR, PLS)")
  run_module("scripts/04_unsupervised_clustering.R", "Unsupervised Clustering & Silhouette Validation")
  run_module("scripts/05_econometric_diagnostics.R", "Econometric Hypotheses Testing (Durbin-Watson & Goldfeld-Quandt)")

  cat("\n================================================================================\n")
  cat("  ALL STATISTICAL SUITES EXECUTED SUCCESSFULLY.\n")
  cat("================================================================================\n\n")
}

main()
