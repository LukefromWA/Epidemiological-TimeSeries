########################################################################################################################
# Climate Cross-Correlation Analysis
# Differences rainfall/temperature series, computes cross-correlation functions (CCF) between dengue and climate drivers at monthly and daily resolution, identifies max-correlation lags, and fits exploratory linear/polynomial/interaction regressions on SSA residuals.
#
# Part of the Dengue-Climate SSA/MSSA/SARIMAX forecasting pipeline.
# Intended to be run in sequence (see main.R) within a single R session,
# as later steps depend on objects created in earlier scripts.
########################################################################################################################


par(mfrow = c(1,1), mar = c(5, 5, 3, 3))

########################################################################################################################
##########################Differencing Climate Variables################################################################
########################################################################################################################

rain_diff12 <- diff(rain_ts, lag = 12)
temp_diff12 <- diff(temp_ts,  lag = 12)



########################################################################################################################
###############################################Monthly CCF #############################################################
########################################################################################################################

par(mfrow = c(2,1), mar = c(5, 5, 3, 3))

xy <- na.omit(ts.intersect(resid = resid, rain = rain_diff12))
ccf(xy[, "resid"], xy[, "rain"], lag.max = 24,
    main = "Cross-correlation: Dengue Residuals vs. Rainfall",
    xlab = "Lag (months)",
    ylab = "Correlation")

xy_temp <- na.omit(ts.intersect(resid = resid, temp = temp_diff12))
ccf(xy_temp[, "resid"], xy_temp[, "temp"], lag.max = 24,
    main = "Cross-correlation: Dengue residuals  vs. Temperature (Monthly)")

#Stabilized dengue log(1+dengue) CCFs

ccf(stab_dng, rain_ts, lag.max = 24,
    main = "Cross-correlation: Dengue(Log(1+cases)) vs Rainfall (Monthly)", xlab = "Lag (months)")
ccf(stab_dng, temp_ts, lag.max = 24,
    main = "CCF: Dengue (Log(1+cases) vs Temperature (Monthly)", xlab = "Lag (months)")


par(mfrow = c(2,1), mar = c(5, 5, 3, 3))

########################################################################################################################
#################################################Daily CCF #############################################################
########################################################################################################################


# Daily Rainfall ccf
ccf(dailydenguerecon$season1, daily_rainfall_ts, lag.max = 90,
    main = "CCF: Seasonal Dengue Component vs Rainfall", xlab = "Lag (days)")

# Daily Temp CCF
ccf(dailydenguerecon$season1, daily_temp_ts, lag.max = 90,
    main = "CCF: Seasonal Dengue Component vs Temperature", xlab = "Lag (days)")

Max_ccf <- function(a,b)
{
  d <- ccf(a, b, plot = FALSE)
  cor = d$acf[,,1]
  lag = d$lag[,,1]
  res = data.frame(cor,lag)
  res_max = res[which.max(res$cor),]
  return(res_max)
}

########################################################################################################################
##################################################Monthly Max CCF#######################################################
########################################################################################################################

Max_ccf(stab_dng, rain_ts)
Max_ccf(stab_dng, temp_ts)

Max_ccf(rain_diff12, resid)
Max_ccf(temp_diff12, resid)

########################################################################################################################
#################################################Daily Max ccf lag#########################################################
########################################################################################################################


Max_ccf(dailydenguerecon$season1, daily_rainfall_ts)
Max_ccf(dailydenguerecon$season1, daily_temp_ts)




xy_both <- na.omit(ts.intersect(resid = resid,
                                rain = stats::lag(rain_diff12, -1),
                                temp = stats::lag(temp_diff12,  0)))


fit <- lm(scale(resid) ~ scale(rain) + scale(temp), data = as.data.frame(xy_both))
summary(fit)

fit_poly <- lm(scale(resid) ~ poly(scale(rain), 2) + poly(scale(temp), 2), 
               data = as.data.frame(xy_both))
summary(fit_poly)

fit_inter <- lm(scale(resid) ~ scale(rain) * scale(temp),
                data = as.data.frame(xy_both))
summary(fit_inter)

par(mfrow = c(2,1), mar = c(4,4,2,2))
