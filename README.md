# Forecasting of Uber Pickups in New York City
Forecasting pickup demand for Uber in New York City using various methods including Regression, Exponential Smoothing, ARIMA and Neural Networks.

## Goal
- Predict hourly Uber demand in each borough of NYC for the month of June 2015 using Jan 2015 - May 2015 hourly pickup data as the training test.
- Generate business insights based on recurring trends and patterns in the datasets

## Dataset
The dataset contains the number of Uber pickups in New York City, categorized by pickup location, for a 6-month period between 01/01/2015 to 06/30/2015. The data is sampled at 1 hour rate and contains 29102 observations. The dataset also has information for corresponding weather conditions such as wind speed, visibility, temperature, precipitation, and snow depth; as well as holiday information; which may be possible factors that affect the number of pickups. Overall, the dataset has 2 non-numeric (category) variables and 10 numeric variables.

Dataset Reference:
Yannis Pappas. Jan, 2016. NYC Uber Pickups with Weather and Holidays, 1. Retreived 08/30/2024 from https://www.kaggle.com/datasets/yannisp/uber-pickups-enriched

## Workflow
- Filter pickup data into time series and set index
- Identify trends and seasonalities
- Calculate correlation with weather conditions
- Benchmark forecasting methods
  - mean, naive, seasonal naive, drift
- Time series forecasting
  - Exponential smoothing
  - Harmonic regression
  - ARIMA
  - Neural nets
- Accuracy analysis
- Business insights


