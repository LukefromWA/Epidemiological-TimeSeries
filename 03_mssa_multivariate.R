########################################################################################################################
# Multivariate SSA (Dengue + Rainfall + Temperature)
# Jointly decomposes standardized dengue, rainfall, and temperature series via MSSA, extracts shared trend/seasonal/outbreak components, visualizes phase-space and 3D trajectories, and evaluates group-wise reconstruction error.
#
# Part of the Dengue-Climate SSA/MSSA/SARIMAX forecasting pipeline.
# Intended to be run in sequence (see main.R) within a single R session,
# as later steps depend on objects created in earlier scripts.
########################################################################################################################



#############################################################################################################################
##################################################MSSA#######################################################################
#############################################################################################################################



########################################################################################################################
##########################################################  MSSA: Dengue + Rain + Temp  ###############################
########################################################################################################################


################################# Align monthly series on common time base ####################################################

aln <- ts.intersect(
  dng  = stab_dng,   # log(1 + dengue)
  rain = rain_ts,
  temp = temp_ts
)

dng_m  <- aln[, "dng"]
rain_m <- aln[, "rain"]
temp_m <- aln[, "temp"]

################################# Scale data and form MSSA input matrix #######################################################

dng_sc   <- scale(as.numeric(dng_m))
rain_sc  <- scale(as.numeric(rain_m))
temp_sc  <- scale(as.numeric(temp_m))


YXT_matrix <- as.matrix(cbind(dng_sc, rain_sc, temp_sc)) 

# This ensures YXT retains time series attributes needed for MSSA
YXT <- ts(YXT_matrix, start = start(dng_m), frequency = frequency(dng_m)) 

# 3. Re-create the MSSA object
n <- NROW(YXT)
L <- min(36, n - 1)
mobj <- ssa(YXT, kind = "mssa", L = L)

################################# Basic MSSA diagnostics ######################################################################

plot(mobj, type = "values", main = "MSSA: Component Norms")
plot(mobj, type = "paired", main = "MSSA: Paired Eigentriples")
plot(wcor(mobj),           main = "MSSA: W-Correlation Matrix")

############################### Define groups (trend + seasonal pairs) ######################################################

mssa_groups <- list(
  trend   = 5:6,
  season1 = 1:2,
  season2 = 3:4,
  outbreak = 7:8
)

mssa_rec <- reconstruct(mobj, groups = mssa_groups)

############################### Extract Dengue / Rain / Temp components #####################################################

## Dengue components (column 1)
dng_trend <- ts(mssa_rec$trend[  , 1],
                start = start(stab_dng), frequency = 12)
dng_seas1 <- ts(mssa_rec$season1[, 1],
                start = start(stab_dng), frequency = 12)
dng_seas2 <- ts(mssa_rec$season2[, 1],
                start = start(stab_dng), frequency = 12)
dng_outbreak <- ts(mssa_rec$outbreak[, 1],
                   start = start(stab_dng), frequency = 12)

## Rain components (column 2)
rain_trend <- ts(mssa_rec$trend[  , 2],
                 start = start(rain_ts), frequency = 12)
rain_seas1 <- ts(mssa_rec$season1[, 2],
                 start = start(rain_ts), frequency = 12)
rain_seas2 <- ts(mssa_rec$season2[, 2],
                 start = start(rain_ts), frequency = 12)
rain_seas3 <- ts(mssa_rec$outbreak[, 2],
                 start = start(rain_ts), frequency = 12)

## Temp components (column 3)
temp_trend <- ts(mssa_rec$trend[  , 3],
                 start = start(temp_ts), frequency = 12)
temp_seas1 <- ts(mssa_rec$season1[, 3],
                 start = start(temp_ts), frequency = 12)
temp_seas2 <- ts(mssa_rec$season2[, 3],
                 start = start(temp_ts), frequency = 12)
temp_outbreak <- ts(mssa_rec$outbreak[, 3],
                    start = start(temp_ts), frequency = 12)


################################# Dengue MSSA component plots #################################################################

par(mfrow = c(5,1), mar = c(4,4,2,1))
plot(stab_dng,  main = "log(1 + Dengue) (Monthly)", ylab = "")
plot(dng_trend, main = "MSSA Dengue Trend(5-6)",          ylab = "")
plot(dng_seas1, main = "MSSA Dengue Seasonality 1 (1–2)", ylab = "")
plot(dng_seas2, main = "MSSA Dengue Seasonality 2 (3–4)", ylab = "")
plot(dng_outbreak, main = "MSSA Dengue Outbreak 2 (7–8)", ylab = "")
par(mfrow = c(1,1))

########################## Residual after MSSA (for hybrid SARIMAX) ####################################################

dng_mssa_fit   <- dng_trend + dng_seas1 + dng_seas2
dng_mssa_resid <- stab_dng - dng_mssa_fit

par(mfrow = c(2,1), mar = c(4,4,2,1))
plot(dng_mssa_resid, main = "MSSA Dengue Residuals", ylab = "residual")
acf(dng_mssa_resid,  main = "ACF: MSSA Dengue Residuals")
par(mfrow = c(1,1))


############################ Cross-correlations between MSSA components ##################################################

par(mfrow = c(1,1), mar = c(5,5,4,1))
ccf(dng_seas1, rain_seas1,
    main = "CCF: Dengue MSSA (Season1) vs Rain MSSA (Season1)")
ccf(dng_seas1, temp_seas1,
    main = "CCF: Dengue MSSA (Season1) vs Temp MSSA (Season1)")



############################## Phase plots: Dengue vs Rain/Temp in Season1 ###############################################

plot(dng_seas1, rain_seas1, type = "l",
     main = "Phase Plot: Dengue vs Rain (Season1)",
     xlab = "Dengue Season1", ylab = "Rain Season1")
text(dng_seas1, rain_seas1,
     labels = round(time(dng_seas1), 2),
     cex = 0.5, pos = 3)

plot(dng_seas1, temp_seas1, type = "l",
     main = "Phase Plot: Dengue vs Temp (Season1)",
     xlab = "Dengue Season1", ylab = "Temp Season1")
text(dng_seas1, temp_seas1,
     labels = round(time(dng_seas1), 2),
     cex = 0.5, pos = 3)

############################# 3D MSSA trajectory: Dengue / Rain / Temp (Season1) #########################################

dng_s  <- as.numeric(dng_seas1)
rain_s <- as.numeric(rain_seas1)
temp_s <- as.numeric(temp_seas1)

open3d()
plot3d(
  x = dng_s,
  y = rain_s,
  z = temp_s,
  type = "l",
  xlab = "Dengue Season1",
  ylab = "Rain Season1",
  zlab = "Temp Season1",
  col  = "blue"
)
title3d(main = "3D MSSA Trajectory: Dengue-Rain-Temp")

####################################################Error Plot###############################################################

errors <- sapply(mssa_rec, function(x) mean((stab_dng - x[, 1])^2))
barplot(errors, main = "Group-wise MSE vs Original Dengue",
        ylab = "MSE", xlab = "Group")


