########################################################################################################################
# Setup & Data Preparation
# Loads required libraries, imports monthly (Bangladesh climate/dengue) and daily case data, builds ts() objects, and applies log1p() variance stabilization.
#
# Part of the Dengue-Climate SSA/MSSA/SARIMAX forecasting pipeline.
# Intended to be run in sequence (see main.R) within a single R session,
# as later steps depend on objects created in earlier scripts.
########################################################################################################################

#install.packages("Rssa")
#install.packages("forecast")
#install.packages("vars")
#install.packages("ggplot2")
#install.packages("vars")

library(Rssa)
library(ggplot2)
library(rgl)
library(fields)
library(forecast)
library(vars)


########################################################################################################################
###############################Storage of Monthly & Daily Variables####################################################
########################################################################################################################

tempave <- (DengueAndClimateBangladesh$MIN+DengueAndClimateBangladesh$MAX)/2
head(tempave)
dengue <- DengueAndClimateBangladesh$DENGUE
rainfall <- DengueAndClimateBangladesh$RAINFALL

daily_dengue <- Dengue_Data$Case 
daily_rainfall <- Dengue_Data$Rainfall
daily_temp <- Dengue_Data$Temperature

########################################################################################################################
######################################################Timeseries Creation Daily and Monthly#############################
########################################################################################################################

dng_ts <- ts(dengue, frequency = 12)
temp_ts <- ts(tempave, frequency = 12)
rain_ts <- ts(rainfall, frequency = 12)

daily_dng_ts <- ts(daily_dengue, start = c(2020,1), frequency = 365) 
daily_rainfall_ts <- ts(daily_rainfall, start = c(2020,1), frequency = 365)
daily_temp_ts <- ts(daily_temp, start = c(2020,1), frequency = 365)

########################################################################################################################
#######################################################Log Stabilization Daily and Monthly##############################
########################################################################################################################

stab_dng <- log1p(dng_ts)
stab_daily_dng <-log1p(daily_dng_ts)
