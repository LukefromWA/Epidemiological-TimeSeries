########################################################################################################################
# Univariate Singular Spectrum Analysis (SSA)
# Fits 1D-SSA (and Toeplitz-SSA) to the log-stabilized monthly and daily dengue series, diagnoses eigentriples, reconstructs trend/seasonal components, and inspects residuals.
#
# Part of the Dengue-Climate SSA/MSSA/SARIMAX forecasting pipeline.
# Intended to be run in sequence (see main.R) within a single R session,
# as later steps depend on objects created in earlier scripts.
########################################################################################################################

########################################################################################################################
###############################################Stabilized SSA Monthly And Daily#########################################
########################################################################################################################

stabdngssa <- ssa(stab_dng, L = 36, kind = "1d-ssa")
ssa_daily <- ssa(stab_daily_dng, L = 90, kind = "1d-ssa")

########################################################################################################################
################################################Daily Component SSA##################################################### 
########################################################################################################################

plot(ssa_daily, type = "values", main = "Daily Component Norms")
plot(ssa_daily, type = "paired", main = "Daily SSA Paired Eigenvectors")
plot(ssa_daily, type = "vectors", main = "Daily SSA Eigenvectors")
plot(wcor(ssa_daily), main = "Daily SSA W-correlation Matrix")


########################################################################################################################
#################################################Monthly Component SSA##################################################
########################################################################################################################


plot(stabdngssa, type = "values", main = "Monthly Component Norms")
plot(stabdngssa, type = "paired", main = "Monthly Paired Eigenvectors") 
plot(stabdngssa, type = "vectors", main = "Monthly Eigenvectors" ) 
plot(wcor(stabdngssa)) 


########################################################################################################################
#################################################Reconstruction#########################################################
########################################################################################################################

denguerecon <- reconstruct(stabdngssa, groups = list(trend = 1, season = 2:3))
dailydenguerecon <- reconstruct(ssa_daily, groups = list(trend = 1, season1 = 2:3, season2 = 4:5))


par(mfrow = c(3,1))

########################################################################################################################
##############################################Monthly SSA Plots#########################################################
########################################################################################################################

plot(stab_dng, main = "log(1+Dengue)", ylab = "")
plot(denguerecon$trend, main = "SSA Trend Component", ylab = "")
plot(denguerecon$season, main = "SSA Seasonal Component", ylab = "")

########################################################################################################################
##############################################Daily SSA plots ##########################################################
########################################################################################################################

par(mfrow = c(4,1), mar = c(4,4,2,1))
plot(stab_daily_dng,            main = "log(1 + Daily Dengue)",            ylab = "")
plot(dailydenguerecon$trend,    main = "Daily SSA Trend",                   ylab = "")
plot(dailydenguerecon$season1,  main = "Daily SSA Seasonal 1 (2–3)",       ylab = "")
plot(dailydenguerecon$season2,  main = "Daily SSA Seasonal 2 (4–5)",       ylab = "")
par(mfrow = c(2,1))

########################################################################################################################
############################################################Resid#######################################################
########################################################################################################################


resid <- stab_dng - denguerecon$trend - denguerecon$season
resid_daily   <- stab_daily_dng - dailydenguerecon$trend -
  dailydenguerecon$season1 - dailydenguerecon$season2


########################################################################################################################
####################################################Monthly Residual plots##############################################
########################################################################################################################

plot(resid, main = "SSA Residual", ylab = "residual")
acf(resid, main = "Series Residual", ylab = "ACF")

########################################################################################################################
####################################################Daily Residual Plots################################################
########################################################################################################################

plot(resid_daily, main = "SSA Residual (Daily)", ylab = "residual")
acf(resid_daily, main = "Series Residual (Daily)", ylab = "ACF")

########################################################################################################################
########################################################################################################################
###############################################toeplitz SSA + Hybrid####################################################
########################################################################################################################



#  Toeplitz SSA on monthly dengue
tssa <- ssa(stab_dng, L = 36, kind = "toeplitz")

plot(tssa, type = "values", main = "Toeplitz SSA Component Norms")
plot(tssa, type = "paired", main = "Toeplitz SSA Paired Eigenvectors")
plot(wcor(tssa), main = "Toeplitz SSA W-correlation Matrix")

tssa_rec <- reconstruct(tssa, groups = list(
  trend = 1,
  season = 2:3
))

# Plots
par(mfrow=c(3,1))
plot(stab_dng, main="Raw log(1 + Dengue)")
plot(tssa_rec$trend, main="T-SSA Trend")
plot(tssa_rec$season, main="T-SSA Seasonality")

