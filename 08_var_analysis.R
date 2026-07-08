########################################################################################################################
# VAR / Impulse-Response Analysis
# Fits a VAR model on differenced rainfall, temperature, and log-dengue series; runs portmanteau, ARCH, normality, and stability diagnostics; computes impulse response functions and forecast error variance decomposition.
#
# Part of the Dengue-Climate SSA/MSSA/SARIMAX forecasting pipeline.
# Intended to be run in sequence (see main.R) within a single R session,
# as later steps depend on objects created in earlier scripts.
########################################################################################################################

########################################################################################################################
###############################################Varima Model#############################################################
########################################################################################################################



Model_mat <- 
  cbind(as.numeric(rain_ts), as.numeric(temp_ts), as.numeric(stab_dng)
  )

data_differencing <- diff(Model_mat)

lagselect <- VARselect(data_differencing, lag.max = 6, type = "const")
lagselect$selection

var_fit <- VAR(data_differencing, p = lagselect$selection["AIC(n)"], type = "const")

summary(var_fit)

# Portmanteau test
serial.test(var_fit, lags.pt = 16, type = "PT.asymptotic")

# ARCH Test
arch.test(var_fit, lags.multi = 5)

# Check for normality of residuals
normality.test(var_fit)

plot(resid(var_fit), main = "VAR Residuals by Variable")
acf(resid(var_fit)[, "y3"], main = "ACF of Dengue Residuals")  # For dengue variable

stability <- stability(var_fit, type = "OLS-CUSUM")
plot(stability)

irf_temp <- irf(var_fit, impulse = "y2", response = "y3", n.ahead = 12, boot = TRUE)
plot(irf_temp, main = "Impulse Response: Temperature → Dengue")

irf_rain <- irf(var_fit, impulse = "y1", response = "y3", n.ahead = 12, boot = TRUE)
plot(irf_rain, main = "Impulse Response: Rainfall → Dengue")

fevd_dng <- fevd(var_fit, n.ahead = 12)
plot(fevd_dng, main = "Forecast Error Variance Decomposition (Dengue)")
