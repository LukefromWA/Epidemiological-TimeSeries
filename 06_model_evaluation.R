########################################################################################################################
# Model Evaluation (RMSE Comparison)
# Back-transforms fitted values to the original case-count scale and compiles an RMSE comparison table across all SARIMAX and hybrid MSSA/SARIMAX/ARIMA models.
#
# Part of the Dengue-Climate SSA/MSSA/SARIMAX forecasting pipeline.
# Intended to be run in sequence (see main.R) within a single R session,
# as later steps depend on objects created in earlier scripts.
########################################################################################################################

###################################################################################################

# Log-transformed series used in fitting
log_dengue <- log1p(dng_ts)

# Fitted values on log scale
fitted_log <- fitted(fit_m)  # or any SARIMAX/MSSA fit

# Back-transform to original counts
pred_cases <- exp(fitted_log) - 1
obs_cases  <- dng_ts  # original case counts

# RMSE in cases
rmse_cases <- sqrt(mean((pred_cases - obs_cases)^2))
rmse_cases

# --- Original dengue series ---
obs_cases <- dng_ts  # original counts

# --- Function to calculate RMSE on original scale ---
rmse_cases <- function(fit, obs) {
  pred <- exp(fitted(fit)) - 1  # back-transform predictions
  sqrt(mean((pred - obs)^2))
}

# --- SARIMAX models ---
rmse_no_lag   <- rmse_cases(fit_no_lag, obs_cases)
rmse_lag1     <- rmse_cases(fit_m,      obs_cases)
rmse_lag1.5   <- rmse_cases(fit_lag15,  obs_cases)
rmse_lag2     <- rmse_cases(fit_m2,     obs_cases)

# --- Hybrid MSSA/SARIMAX ---
rmse_mssa_sarimax <- rmse_cases(sarimax_mssa, obs_cases)

# --- Hybrid MSSA/ARIMA (residual only) ---
rmse_mssa_arima <- rmse_cases(fit_mssa_resid_only, obs_cases)

# --- Compile table ---
rmse_table <- data.frame(
  Model = c(
    "SARIMAX No Lag",
    "SARIMAX 1 month lag",
    "SARIMAX 1.5 month lag",
    "SARIMAX 2 month lag",
    "Hybrid MSSA + SARIMAX",
    "Hybrid MSSA + ARIMA"
  ),
  RMSE_cases = c(
    rmse_no_lag,
    rmse_lag1,
    rmse_lag1.5,
    rmse_lag2,
    rmse_mssa_sarimax,
    rmse_mssa_arima
  )
)

print(rmse_table)
