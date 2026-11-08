# ==============================================================================
# Script:      05_econometric_diagnostics.R
# Description: Econometric residual diagnostics: Durbin-Watson test for serial
#              autocorrelation and Goldfeld-Quandt test for heteroscedasticity.
# ==============================================================================

library(lmtest)

cat("\n========================================================================\n")
cat("  1. TIME-SERIES RESIDUAL AUTOCORRELATION (DURBIN-WATSON TEST)\n")
cat("========================================================================\n")

ts_data <- data.frame(
  t   = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
  x_t = c(10.0, 12.0, 13.4, 16.5, 18.4, 12.5, 14.6, 13.4, 19.2, 20.0),
  y_t = c(30.0, 35.0, 40.0, 44.0, 55.0, 42.0, 48.0, 40.0, 41.0, 52.0)
)

model_ts <- lm(y_t ~ x_t, data = ts_data)
dw_res <- dwtest(model_ts)
cat(sprintf("Durbin-Watson DW-Statistik: %.4f | p-Wert: %.4f\n",
            dw_res$statistic, dw_res$p.value))
if (dw_res$p.value < 0.05) {
  cat("[!] Statistische Evidenz für serielle Autokorrelation der Residuen (H0 verworfen).\n")
} else {
  cat("[+] Keine signifikante serielle Autokorrelation ersten Grades nachgewiesen.\n")
}

cat("\n========================================================================\n")
cat("  2. HETEROSCEDASTICITY DIAGNOSTICS (GOLDFELD-QUANDT TEST)\n")
cat("========================================================================\n")

firm_data <- data.frame(
  Productivity = c(9.26, 9.38, 12.11, 10.81, 9.35, 9.87, 8.17, 9.12, 5.88, 6.3, 6.22, 5.49, 6.5, 6.61, 4.32, 7.37, 7.02, 8.25, 8.15, 8.72, 6.64, 8.1, 5.52, 9.37, 13.17),
  FundYield = c(1.45, 1.3, 1.37, 1.65, 1.91, 1.68, 1.94, 1.89, 1.94, 2.06, 1.96, 1.02, 1.85, 0.88, 0.62, 1.09, 1.6, 1.53, 1.4, 2.22, 1.32, 1.48, 0.68, 2.3, 1.37),
  NonProductionExpenses = c(17.72, 18.39, 26.46, 22.37, 28.13, 17.55, 21.92, 19.52, 23.99, 21.76, 25.68, 18.13, 25.74, 21.21, 22.97, 16.38, 13.21, 14.48, 13.38, 13.69, 16.66, 15.06, 20.09, 15.98, 18.27),
  Profitability = c(13.26, 10.16, 13.72, 12.85, 10.63, 9.12, 25.83, 23.39, 14.68, 10.05, 13.99, 9.68, 10.03, 9.13, 5.37, 9.86, 12.62, 5.02, 21.18, 25.17, 19.4, 21, 6.57, 14.19, 15.81)
)

model_firm <- lm(Profitability ~ Productivity + FundYield + NonProductionExpenses, data = firm_data)
gq_res <- gqtest(model_firm, fraction = 0.5)

cat(sprintf("Goldfeld-Quandt GQ-Statistik: %.4f | p-Wert: %.4f\n",
            gq_res$statistic, gq_res$p.value))
if (gq_res$p.value < 0.05) {
  cat("[!] Statistische Evidenz für Heteroskedastizität der Fehlervarianz (H0 verworfen).\n")
} else {
  cat("[+] Homoskedastizitätsannahme der Fehlervarianz wird beibehalten.\n")
}
