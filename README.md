# Dengue–Climate Forecasting: SSA / MSSA / SARIMAX Pipeline

A reproducible time series analysis pipeline investigating the relationship between dengue incidence and climate variability in Bangladesh using Singular Spectrum Analysis (SSA/MSSA), SARIMAX forecasting, and Vector Autoregression (VAR).

This repository contains the complete R and Python workflows used throughout the analysis, from data preparation through forecasting and model comparison. The project examines how rainfall and temperature influence dengue transmission while comparing classical statistical forecasting methods with hybrid SSA-based approaches.

---

## Project Overview

The analysis combines signal decomposition, statistical modeling, and multivariate time series methods to characterize climate-driven dengue dynamics.

The workflow consists of five major stages:

1. **Signal decomposition** using 1D-SSA, Toeplitz-SSA, and Multichannel SSA (MSSA).
2. **Climate association analysis** to identify lagged relationships between climate variables and dengue incidence.
3. **Forecast model construction** using SARIMAX models with multiple climate lag structures.
4. **Hybrid MSSA + SARIMAX/SARIMA forecasting** to compare decomposition-assisted forecasting against conventional approaches.
5. **Dynamic systems analysis** using Vector Autoregression (VAR), impulse response functions, and forecast error variance decomposition.

Full methodological detail and results are provided in the accompanying report (see [`paper/`](./paper)), authored by Alexander Bigloo, Lucas Anderson, Mahder Wehabe, and Tristan Cullen (December 2025).

---

## Repository Structure

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
├── data/
│   └── Source datasets
│
└── paper/
    └── (full write-up, PDF/LaTeX source)
```

---

## Statistical Modeling Framework

### Variance Stabilization & Differencing

Dengue cases display strong yearly cycles and non-stationary variance. Before fitting, the series is log-transformed and seasonally differenced with period 12 (months):

$$
y_t = \log(1 + \text{cases}_t)
$$

### SARIMAX Specification

The relationship between climate variables and dengue incidence is modeled with a seasonal autoregressive integrated moving-average model with exogenous regressors:

$$
\text{SARIMAX}(p, 0, q) \times (P, 1, Q)_{12}
$$

Multiple candidate orders were compared by AIC; the selected specification was $\text{SARIMAX}(1,0,1)\times(2,1,1)_{12}$, combining non-seasonal AR(1)/MA(1) terms with seasonal AR(2)/MA(1) terms at a 12-month periodicity.

### Lagged Climate Covariates

Cross-correlation analysis identified a 1-to-2-month delay between temperature/rainfall and dengue incidence. Candidate lags of 1, 1.5, and 2 months were tested as exogenous regressors on pre-COVID data (to avoid confounding from COVID-era testing surges misattributed to dengue); the 2-month lag gave the best sample RMSE and AIC among lagged SARIMAX variants.

### MSSA Decomposition & Hybrid Forecasting

Multichannel SSA jointly decomposes dengue incidence, rainfall, and temperature into shared trend, seasonal, and residual components. The extracted residual series was then modeled directly:

$$
\text{ARIMA}(1,0,0)\times(0,1,1)_{12}
$$

applied to the MSSA residuals with no exogenous climate regressors — this simplified hybrid model outperformed every climate-inclusive SARIMAX variant (see results below).

### Vector Autoregression (VAR)

A VAR model was fit jointly on dengue incidence, rainfall, and temperature to characterize bidirectional dynamics, alongside impulse response functions (IRFs) and forecast error variance decomposition (FEVD):

$$
\mathbf{x}_t = c + \sum_{i=1}^{p} A_i \mathbf{x}_{t-i} + \varepsilon_t, \qquad \mathbf{x}_t = (\text{dengue}_t,\ \text{rainfall}_t,\ \text{temperature}_t)^\top
$$

---

## Analysis Workflow

### 1. Data Preparation

The R and Python workflows begin by importing and cleaning the monthly and daily dengue surveillance datasets. Daily observations are aggregated to monthly resolution where required and transformed for downstream analyses.

### 2. Univariate SSA

One-dimensional SSA and Toeplitz SSA are used to decompose dengue incidence into trend, seasonal, and residual components, providing a denoised representation of epidemic dynamics before introducing climate variables.

### 3. Climate Association Analysis

Cross-correlation functions (CCF) and regression models identify lagged relationships between rainfall, temperature, and dengue incidence. Climate variables are differenced where appropriate before evaluating delayed associations.

### 4. Multichannel SSA (MSSA)

MSSA jointly decomposes dengue incidence, rainfall, and temperature into shared temporal components. The analysis includes:

- Common trend extraction
- Seasonal decomposition
- Phase-space visualization
- Three-dimensional trajectory plots
- Paired eigen-triple identification to determine periodicity of individual signal components

### 5. Forecasting Models

Several forecasting approaches are compared throughout the analysis: SARIMAX, SARIMAX with multiple climate lag structures, and hybrid MSSA + SARIMAX/SARIMA. Forecasts are generated over multiple forecasting horizons and compared using RMSE and AIC.

### 6. Structural Time Series Analysis

VAR models characterize interactions between dengue incidence, rainfall, and temperature, supplemented by IRFs and FEVD to examine dynamic climate forcing.

---

## Results

### Model Comparison (Monthly Data)

| Model | AIC | RMSE |
|---|---|---|
| No-lag SARIMAX | 340.76 | 0.8667 |
| 1-month lag SARIMAX | 338.27 | 0.8701 |
| 1.5-month lag SARIMAX | 336.69 | 0.8740 |
| 2-month lag SARIMAX | 336.99 | 0.8721 |
| Hybrid MSSA/SARIMAX | 323.24 | 0.7985 |
| **Hybrid MSSA/SARIMA** | **318.52** | **0.7985** |

The Hybrid MSSA/SARIMA model — using MSSA-decomposed residuals with no exogenous climate regressors — achieved the lowest AIC and RMSE overall, outperforming every climate-inclusive SARIMAX specification.

### Diagnostics

- **Ljung-Box test** on the Hybrid MSSA/SARIMA residuals: $p = 0.4486$, failing to reject the null hypothesis that residuals are white noise, confirming an adequate model fit.
- **VAR appendix analysis**: temperature was a statistically significant predictor of dengue incidence at lags 1, 4, 5, and 6, corroborating the SARIMAX lag findings. However, VAR residual diagnostics showed non-constant variance and non-normal residuals with unaddressed autocorrelation, indicating the VAR framework did not fully capture the series' nonlinear dynamics — the hybrid MSSA/SARIMA model was therefore preferred for forecasting.

---

## Discussion

Climate variables play a meaningful role in predicting dengue incidence in Bangladesh, with temperature as the most significant lagged predictor across SARIMAX, VAR, and hybrid models. Strong annual seasonality detected via SSA and MSSA supports the link between dengue transmission and Bangladesh's monsoon climate cycle. The superior performance of the simplified Hybrid MSSA/SARIMA model over more complex climate-inclusive SARIMAX models suggests that decomposing trend and seasonality offers greater predictive stability than directly including exogenous climate regressors for this dataset.

### Limitations

- Dengue case reporting during the COVID-19 era is likely inflated by increased medical attention and symptom overlap with COVID-19; climate-lagged models were additionally tested on pre-COVID data to mitigate this
- The climate variables used (average temperature and rainfall) may oversimplify the ecological drivers of mosquito breeding, which also depend on humidity, extreme temperatures, environmental management, and human behavior
- The VAR model's residual diagnostics indicate unmodeled nonlinear dynamics

### Future Work

- Explore nonlinear or machine-learning forecasting approaches
- Incorporate additional climate variables (humidity, min/max temperature, wind speed), land-use data, and mosquito population estimates
- Use daily climatological data without monthly aggregation to capture finer-scale weather effects
- Develop real-time early warning systems built on MSSA-enhanced models to support public health resource allocation

---

## Requirements

### R

Required packages:

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

### Python

Install the required packages with:

```bash
pip install -r python/requirements.txt
```

The Python workflow uses:

- pandas
- numpy
- matplotlib
- seaborn
- statsmodels
- scikit-learn

---

## Data

The analysis uses two surveillance datasets collected from the Institute of Epidemiology, Disease Control and Research (IEDCR) and the Directorate General of Health Services (DGHS), Bangladesh.

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

Load both datasets into your R environment before running:

```r
source("main.R")
```

### Python

Place both CSV files inside:

```text
data/
├── DengueAndClimateBangladesh.csv
└── Dengue Data.csv
```

The preprocessing script produces:

```text
data/dengue_climate_monthly_2008_2021.csv
```

which is used by the remaining Python modules.

---

## Running the Pipeline

### R

```r
source("main.R")
```

The R scripts are intended to run sequentially within a single session since each module builds on objects created by previous steps.

### Python

```bash
cd python
python main.py
```

The Python modules are also designed to run sequentially through `main.py`.

---

## Authors

This repository contains the complete reproducible analysis pipeline developed as part of an applied time series analysis project.

- **R Pipeline:** Lucas Anderson
- **Python Pipeline:** Tristan Cullen (modularized and refactored for this repository while preserving original functionality and attribution)

Research collaboration and manuscript co-authorship:

- Alexander Bigloo
- Lucas Anderson
- Mahder Wehabe
- Tristan Cullen

Thank you to everyone involved for their contributions to the project and manuscript.

---

## Background

Developed as part of an applied time series analysis research project at **Western Washington University** under the supervision of **Dr. Kimihiro Noguchi**.

The project investigates the relationship between climate variability and dengue transmission using Singular Spectrum Analysis (SSA/MSSA), multivariate time series methods, and statistical forecasting. This repository provides the complete reproducible workflow used throughout the analysis.

---

## Citation

If you use this pipeline, please cite the accompanying report (Bigloo, Anderson, Wehabe & Cullen, December 2025; see [`paper/`](./paper)) and this repository.
