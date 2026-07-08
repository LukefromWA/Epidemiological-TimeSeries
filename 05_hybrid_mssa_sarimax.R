########################################################################################################################
# Hybrid MSSA + SARIMAX Models
# Fits SARIMAX to the MSSA-derived dengue residual series using MSSA-extracted rain/temp seasonal components as exogenous regressors (single- and dual-season variants), plus an MSSA-residual-only benchmark.
#
# Part of the Dengue-Climate SSA/MSSA/SARIMAX forecasting pipeline.
# Intended to be run in sequence (see main.R) within a single R session,
# as later steps depend on objects created in earlier scripts.
########################################################################################################################

############################################################################################################################
########################################### Hybrid MSSA/Sarimax ############################################################
############################################################################################################################


x_mssa <- cbind(
  rain_mssa = rain_seas1,
  temp_mssa = temp_seas1
)

sarimax_mssa <- auto.arima(
  dng_mssa_resid,
  xreg     = x_mssa,
  seasonal = TRUE
)

summary(sarimax_mssa)

tsdisplay(residuals(sarimax_mssa),
          main = "Hybrid MSSA + SARIMAX Residuals")
checkresiduals(sarimax_mssa)



#########################################
#   Hybrid season 1 and 2 components #
#########################################

x_mssa2 <- cbind(
  rain1 = rain_seas1,
  temp1 = temp_seas1,
  rain2 = mssa_rec$season2[, 2],
  temp2 = mssa_rec$season2[, 3]
)

fit_mssa2 <- auto.arima(dng_mssa_resid,
                        xreg = x_mssa2,
                        seasonal = TRUE)

summary(fit_mssa2)
checkresiduals(fit_mssa2)
AIC(fit_mssa2); accuracy(fit_mssa2)

######## MSSA Resid model ###########

fit_mssa_resid_only <- auto.arima(
  dng_mssa_resid, 
  seasonal = TRUE
)

summary(fit_mssa_resid_only)
checkresiduals(fit_mssa_resid_only)
AIC(fit_mssa_resid_only) 
accuracy(fit_mssa_resid_only)

