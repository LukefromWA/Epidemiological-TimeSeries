########################################################################################################################
# SARIMAX Models (Climate-Forced)
# Fits auto.arima SARIMAX models of log(1+dengue) against rainfall/temperature regressors at no-lag, 1-month, 1.5-month, and 2-month lags, with residual diagnostics.
#
# Part of the Dengue-Climate SSA/MSSA/SARIMAX forecasting pipeline.
# Intended to be run in sequence (see main.R) within a single R session,
# as later steps depend on objects created in earlier scripts.
########################################################################################################################





########################################################################################################################
############################################Monthly Sarimax Models#############################################################
########################################################################################################################

########################################################################################################################
############################################ Sarimax No Lag ############################################################
########################################################################################################################

rain_no_lag <- rain_ts
temp_no_lag <- temp_ts

xy_no_lag <- ts.intersect(
  y    = log1p(dng_ts),
  rain = rain_no_lag,
  temp = temp_no_lag
)

y_no_lag <- xy_no_lag[, "y"]
x_no_lag <- cbind(
  rain = xy_no_lag[, "rain"],
  temp = xy_no_lag[, "temp"]
)

fit_no_lag <- auto.arima(y_no_lag, xreg = x_no_lag, seasonal = TRUE)
summary(fit_no_lag)


########################################################################################################################
############################################# Sarimax Lag 1 ############################################################
########################################################################################################################


rain_lag_m <- stats::lag(rain_ts, -1)
temp_lag_m <- stats::lag(temp_ts, -1)

xy_m <- ts.intersect(y = log1p(dng_ts), rain = rain_lag_m, temp = temp_lag_m)
y_m    <- xy_m[, "y"]
x_m    <- cbind(rain = xy_m[, "rain"], temp = xy_m[, "temp"])

fit_m <- auto.arima(y_m, xreg = x_m, seasonal = TRUE)  
summary(fit_m)

tsdisplay(residuals(fit_m), main = "Monthly SARIMAX residuals(Lag 1)")
checkresiduals(fit_m)

########################################################################################################################
############################################# Sarimax Lag 2 ############################################################
########################################################################################################################

rain_lag_m2 <- stats::lag(rain_ts, -2)
temp_lag_m2 <- stats::lag(temp_ts, -2)

xy_m2 <- ts.intersect(y = log1p(dng_ts), rain = rain_lag_m2, temp = temp_lag_m2)
y_m2    <- xy_m2[, "y"]
x_m2    <- cbind(rain = xy_m2[, "rain"], temp = xy_m2[, "temp"])

fit_m2 <- auto.arima(y_m2, xreg = x_m2, seasonal = TRUE)  
summary(fit_m2)

tsdisplay(residuals(fit_m2), main = "Monthly SARIMAX residuals (Lag 2)")
checkresiduals(fit_m2)

########################################################################################################################
############################################# Sarimax Lag 1.5 ##########################################################
########################################################################################################################

rain_lag15 <- 0.5 * stats::lag(rain_ts, -1) + 0.5 * stats::lag(rain_ts, -2)
temp_lag15 <- 0.5 * stats::lag(temp_ts, -1) + 0.5 * stats::lag(temp_ts, -2)

xy_15 <- ts.intersect(y = log1p(dng_ts),
                      rain = rain_lag15,
                      temp = temp_lag15)

y_15 <- xy_15[, "y"]
X_15 <- cbind(rain = xy_15[, "rain"], temp = xy_15[, "temp"])

fit_lag15 <- auto.arima(y_15, xreg = X_15, seasonal = TRUE)
summary(fit_lag15)

tsdisplay(residuals(fit_lag15), main = "Residuals: SARIMAX with ~1.5-month lag")
checkresiduals(fit_lag15)

acc <- accuracy(fit_lag15)
cat("\nRMSE:", acc["Training set","RMSE"], "\nAIC:", AIC(fit_lag15), "\n")

par(mfrow = c(2,1), mar = c(4,4,2,2))

