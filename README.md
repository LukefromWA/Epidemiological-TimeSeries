# Dengue–Climate Forecasting: SSA / MSSA / SARIMAX Pipeline

A reproducible time series analysis pipeline investigating the relationship between dengue incidence and climate variability in Bangladesh using Singular Spectrum Analysis (SSA/MSSA), SARIMAX forecasting, and Vector Autoregression (VAR).

This repository contains the complete R and Python workflows used throughout the analysis, from data preparation through forecasting and model comparison. The project examines how rainfall and temperature influence dengue transmission while comparing classical statistical forecasting methods with hybrid SSA-based approaches.

---

# Project Overview

The analysis combines signal decomposition, statistical modeling, and multivariate time series methods to characterize climate-driven dengue dynamics.

The workflow consists of five major stages:

1. **Signal decomposition** using 1D-SSA, Toeplitz-SSA, and Multichannel SSA (MSSA).
2. **Climate association analysis** to identify lagged relationships between climate variables and dengue incidence.
3. **Forecast model construction** using SARIMAX models with multiple climate lag structures.
4. **Hybrid MSSA + SARIMAX forecasting** to compare decomposition-assisted forecasting against conventional approaches.
5. **Dynamic systems analysis** using Vector Autoregression (VAR), impulse response functions, and forecast error variance decomposition.

---

# Repository Structure

```text
.
├── main.R                              # Runs the complete R analysis pipeline
├── R/
│   ├── 00_setup_and_data_prep.R
│   ├── 01_univariate_ssa.R
│   ├── 02_climate_correlation_analysis.R
│   ├── 03_mssa_multivariate.R
│   ├── 04_sarimax_models.R
│   ├── 05_hybrid_mssa_sarimax.R
│   ├── 06_model_evaluation.R
│   ├── 07_forecasting.R
│   └── 08_var_analysis.R
│
├── python/
│   ├── main.py
│   ├── 00_setup_and_data_prep.py
│   ├── 01_baseline_sarimax.py
│   ├── 02_model_selection.py
│   └── 03_eda_visualization.py
│
└── data/
    └── Source datasets
```

---

# Analysis Workflow

## 1. Data Preparation

The R and Python workflows begin by importing and cleaning the monthly and daily dengue surveillance datasets. Daily observations are aggregated to monthly resolution where required and transformed for downstream analyses.

---

## 2. Univariate SSA

One-dimensional SSA and Toeplitz SSA are used to decompose dengue incidence into trend, seasonal, and residual components.

These decompositions provide a denoised representation of epidemic dynamics before introducing climate variables.

---

## 3. Climate Association Analysis

Cross-correlation functions (CCF) and regression models are used to identify lagged relationships between rainfall, temperature, and dengue incidence.

Climate variables are differenced where appropriate before evaluating delayed associations.

---

## 4. Multichannel SSA (MSSA)

MSSA jointly decomposes dengue incidence, rainfall, and temperature into shared temporal components.

The analysis includes

- Common trend extraction
- Seasonal decomposition
- Phase-space visualization
- Three-dimensional trajectory plots

to investigate shared climate–disease dynamics.

---

## 5. Forecasting Models

Several forecasting approaches are compared throughout the analysis.

These include

- SARIMAX
- SARIMAX with multiple climate lag structures
- Hybrid MSSA + SARIMAX

Forecasts are generated over multiple forecasting horizons and compared using RMSE.

---

## 6. Structural Time Series Analysis

Vector Autoregression (VAR) models are fit to characterize interactions between dengue incidence, rainfall, and temperature.

Additional analyses include

- Impulse Response Functions (IRFs)
- Forecast Error Variance Decomposition (FEVD)

to examine dynamic climate forcing.

---

# Requirements

## R

Required packages

```r
install.packages(c(
  "Rssa",
  "ggplot2",
  "rgl",
  "fields",
  "forecast",
  "vars"
))
```

## Python

Install the required packages with

```bash
pip install -r python/requirements.txt
```

The Python workflow uses

- pandas
- numpy
- matplotlib
- seaborn
- statsmodels
- scikit-learn

---

# Data

The analysis uses two surveillance datasets.

### Monthly Dataset (2008–2019)

- Dengue incidence
- Rainfall
- Minimum temperature
- Maximum temperature

### Daily Dataset (2020–2021)

- Dengue incidence
- Rainfall
- Temperature

### R

Load both datasets into your R environment before running

```r
source("main.R")
```

### Python

Place both CSV files inside

```text
data/
├── DengueAndClimateBangladesh.csv
└── Dengue Data.csv
```

The preprocessing script produces

```text
data/dengue_climate_monthly_2008_2021.csv
```

which is used by the remaining Python modules.

---

# Running the Pipeline

## R

```r
source("main.R")
```

The R scripts are intended to run sequentially within a single session since each module builds on objects created by previous steps.

## Python

```bash
cd python
python main.py
```

The Python modules are also designed to run sequentially through `main.py`.

---

# Authors

This repository contains the complete reproducible analysis pipeline developed as part of our applied time series analysis project.

### R Pipeline

**Lucas Anderson**

### Python Pipeline

**Tristan Cullen**

The Python code has been modularized and refactored for this repository while preserving its original functionality and attribution.

Research collaboration with

- Lucas Anderson
- Tristan Cullen
- Alexander Bigloo
- Mahder Wehabe

Thank you to everyone involved for their contributions to the project and manuscript.

---

# Background

Developed as part of an applied time series analysis research project at **Western Washington University** under the supervision of **Dr. Kimihiro Noguchi**.

The project investigates the relationship between climate variability and dengue transmission using Singular Spectrum Analysis (SSA/MSSA), multivariate time series methods, and statistical forecasting. This repository provides the complete reproducible workflow used throughout the analysis.