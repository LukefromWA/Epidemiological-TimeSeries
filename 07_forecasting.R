########################################################################################################################
# Forecasting
# Builds future exogenous regressor matrices and generates 12/24/36-month-ahead forecasts for each fitted SARIMAX/hybrid model, with comparison plots.
#
# Part of the Dengue-Climate SSA/MSSA/SARIMAX forecasting pipeline.
# Intended to be run in sequence (see main.R) within a single R session,
# as later steps depend on objects created in earlier scripts.
########################################################################################################################




#######################################################################################################
###############################################Forecasting############################################
#####################################################################################################

##################################################################
## Make X reg ##
##################################################################


make_future_xreg <- function(xreg_mat, h) {
  k  <- nrow(xreg_mat)
  L  <- 12L
  last12 <- tail(xreg_mat, L)
  reps   <- ceiling(h / L)
  tmp    <- do.call(rbind, replicate(reps, last12, simplify = FALSE))
  tmp[1:h, , drop = FALSE]
}
##################################################################
#Standard Sarimax XREG#
##################################################################

h12 <- 12
h24 <- 24
h36 <- 36

x_m_12   <- make_future_xreg(x_m,   h12)
x_m_24   <- make_future_xreg(x_m,   h24)
x_m_36   <- make_future_xreg(x_m,   h36)

X_m2_12  <- make_future_xreg(X_15,  h12)
x_m2_24  <- make_future_xreg(x_m2,  h24)
x_m2_36  <- make_future_xreg(x_m2,  h36)

X_15_12  <- make_future_xreg(X_15,  h12)
X_15_24  <- make_future_xreg(X_15,  h24)
X_15_36  <- make_future_xreg(X_15,  h36)

x_mssa_12 <- make_future_xreg(x_mssa, h12)
x_mssa_24 <- make_future_xreg(x_mssa, h24)
x_mssa_36 <- make_future_xreg(x_mssa, h36)



## Lag 1 SARIMAX

fc_m_12 <- forecast(fit_m,   h = h12, xreg = x_m_12)
fc_m_24 <- forecast(fit_m,   h = h24, xreg = x_m_24)
fc_m_36 <- forecast(fit_m,   h = h36, xreg = x_m_36)

## Lag 2 SARIMAX

fc_m2_12 <- forecast(fit_m2,  h = h12, xreg = X_m2_12)
fc_m2_24 <- forecast(fit_m2,  h = h24, xreg = x_m2_24)
fc_m2_36 <- forecast(fit_m2,  h = h36, xreg = x_m2_36)

## Lag 1.5 SARIMAX

fc_15_12 <- forecast(fit_lag15, h = h12, xreg = X_15_12)
fc_15_24 <- forecast(fit_lag15, h = h24, xreg = X_15_24)
fc_15_36 <- forecast(fit_lag15, h = h36, xreg = X_15_36)

# Hybrid MSSA Sarimax

xreg_mssa_12 <- matrix(0, nrow = h12, ncol = ncol(x_mssa))
colnames(xreg_mssa_12) <- colnames(x_mssa)

xreg_mssa_24 <- matrix(0, nrow = h24, ncol = ncol(x_mssa))
colnames(xreg_mssa_24) <- colnames(x_mssa)

xreg_mssa_36 <- matrix(0, nrow = h36, ncol = ncol(x_mssa))
colnames(xreg_mssa_36) <- colnames(x_mssa)

fc_mssa_12 <- forecast(sarimax_mssa,
                       xreg = xreg_mssa_12, h = h24)

fc_mssa_24 <- forecast(sarimax_mssa,
                       xreg = xreg_mssa_24, h = h24)
fc_mssa_36 <- forecast(sarimax_mssa,
                       xreg = xreg_mssa_36, h = h36)


#################################################
                     # Plot #
#################################################


par(mfrow = c(2,2), mar = c(5,5,4,2))


plot(fc_m_12,       main = "12-mo Forecast: SARIMAX Lag 1")
plot(fc_m2_12,      main = "12-mo Forecast: SARIMAX Lag 2")
plot(fc_15_12,   main = "12-mo Forecast: SARIMAX Lag 1.5")
plot(fc_mssa_12,    main = "12-mo Forecast: Hybrid MSSA + SARIMAX")



plot(fc_m_24,       main = "24-mo Forecast: SARIMAX Lag 1")
plot(fc_m2_24,      main = "24-mo Forecast: SARIMAX Lag 2")
plot(fc_15_24,   main = "24-mo Forecast: SARIMAX Lag 1.5")
plot(fc_mssa_24,    main = "24-mo Forecast: Hybrid MSSA + SARIMAX")



plot(fc_m_36,       main = "36-mo Forecast: SARIMAX Lag 1")
plot(fc_m2_36,      main = "36-mo Forecast: SARIMAX Lag 2")
plot(fc_15_36,   main = "36-mo Forecast: SARIMAX Lag 1.5")
plot(fc_mssa_36,    main = "36-mo Forecast: Hybrid MSSA + SARIMAX")

