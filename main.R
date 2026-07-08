########################################################################################################################
# main.R
#
# Entry point for the Dengue-Climate SSA/MSSA/SARIMAX forecasting pipeline.
# Sources each analysis module in sequence within a single R session.
#
# Required objects before running: `DengueAndClimateBangladesh` and `Dengue_Data`
# data frames must be loaded into the environment (see data/README.md).
########################################################################################################################

source("R/00_setup_and_data_prep.R")
source("R/01_univariate_ssa.R")
source("R/02_climate_correlation_analysis.R")
source("R/03_mssa_multivariate.R")
source("R/04_sarimax_models.R")
source("R/05_hybrid_mssa_sarimax.R")
source("R/06_model_evaluation.R")
source("R/07_forecasting.R")
source("R/08_var_analysis.R")
