# Dengue–Climate Forecasting: SSA / MSSA / SARIMAX Pipeline

A time series analysis pipeline exploring the relationship between dengue incidence
and climate drivers (rainfall, temperature) in Bangladesh, combining Singular
Spectrum Analysis (SSA/MSSA) decomposition with SARIMAX and VAR forecasting models.

## Method overview

1. **Decomposition** — Univariate 1D-SSA and Toeplitz-SSA isolate trend and seasonal
   components from log-stabilized monthly and daily dengue case series.
2. **Climate association** — Cross-correlation analysis (CCF) and regression identify
   the lag structure between dengue residuals and differenced rainfall/temperature.
3. **Joint decomposition** — Multivariate SSA (MSSA) jointly decomposes dengue,
   rainfall, and temperature to extract shared trend, seasonal, and outbreak-specific
   components, visualized via phase-space and 3D trajectory plots.
4. **Forecasting models** — SARIMAX models (multiple climate lag structures) and
   hybrid MSSA+SARIMAX models are fit and compared by RMSE, then used to generate
   12/24/36-month-ahead forecasts.
5. **Structural analysis** — A VAR model with impulse-response functions and forecast
   error variance decomposition characterizes dynamic climate → dengue relationships.

## Repository structure

```
.
├── main.R                              # Sources all modules in sequence
├── R/
│   ├── 00_setup_and_data_prep.R        # Libraries, data import, log stabilization
│   ├── 01_univariate_ssa.R             # 1D-SSA & Toeplitz-SSA (monthly + daily)
│   ├── 02_climate_correlation_analysis.R  # CCF, max-lag detection, regressions
│   ├── 03_mssa_multivariate.R          # Joint MSSA (dengue + rain + temp)
│   ├── 04_sarimax_models.R             # SARIMAX at 0/1/1.5/2-month climate lags
│   ├── 05_hybrid_mssa_sarimax.R        # SARIMAX on MSSA-derived residuals
│   ├── 06_model_evaluation.R           # RMSE comparison table (all models)
│   ├── 07_forecasting.R                # Multi-horizon forecasts + plots
│   └── 08_var_analysis.R               # VAR, IRFs, FEVD
```

## Requirements

R packages: `Rssa`, `ggplot2`, `rgl`, `fields`, `forecast`, `vars`.

```r
install.packages(c("Rssa", "ggplot2", "rgl", "fields", "forecast", "vars"))
```

## Data

Expects two data objects in the environment before sourcing `main.R`:
- `DengueAndClimateBangladesh` — monthly dengue case counts, min/max temperature, rainfall
- `Dengue_Data` — daily dengue case counts, rainfall, temperature (from 2020)

## Usage

```r
# after loading DengueAndClimateBangladesh and Dengue_Data
source("main.R")
```

Because each script builds on objects created earlier in the pipeline, modules
are meant to be run in order within one R session rather than as fully
independent, standalone scripts — the split is for readability and review,
not for isolated execution.

## Authors

R pipeline in this repository written by **Lucas Anderson**.

Paper co-authored with Alexander Bigloo, Mahder Wehabe, and Tristan Cullen (Python
analysis), from "An Analysis of the Association of Climate Variables and the Rate
of New Dengue Cases in Bangladesh with a Future Outlook with Respect to Climate
Change."

## Background

Developed as part of an applied time series analysis research collaboration applying SSA/MSSA
time series decomposition to infectious disease surveillance, advised by Dr. Kimihiro
Noguchi (Western Washington University).
