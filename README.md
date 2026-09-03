# Forecasting Uber Pickup Demand in New York City

Hourly demand forecasting for three NYC boroughs, comparing benchmark methods, exponential smoothing, harmonic regression, ARIMA and neural network autoregression over a one-month horizon.

**Headline result:** harmonic regression with five Fourier terms cut forecast error by roughly a third against the best naive benchmark in Brooklyn and Manhattan. In the Bronx, additive Winter's method won instead. ARIMA and neural networks, the two most complex methods tested, performed worst.

---

## Problem

Uber needs to know where and when demand will spike in order to position drivers and anticipate surge conditions. The question here: given five months of hourly pickup history, how accurately can the next month be forecast, and which method should a planning team use?

Three boroughs were modeled separately: Brooklyn, Manhattan and the Bronx. They differ enough in volume and demand shape that a single model across all of them would hide the differences that matter operationally.

## Data

29,102 hourly observations covering 01/01/2015 to 06/30/2015, with pickup counts by location alongside weather (wind speed, visibility, temperature, dew point, sea level pressure, precipitation at 1/6/24 hours, snow depth) and holiday flags. 2 categorical and 10 numeric variables.

Source: [NYC Uber Pickups with Weather and Holidays](https://www.kaggle.com/datasets/yannisp/uber-pickups-enriched) (Yannis Pappas, 2016), itself a subset of data FiveThirtyEight obtained from the NYC Taxi and Limousine Commission via a Freedom of Information Law request, enriched with NCEI weather data.

Train/test split is 80/20 by time: January through May for training, June held out for testing. Every accuracy figure below is on the June test set.

## Exploratory findings

The raw data is not segregated by borough, producing duplicate timestamps in `pickup_dt`. Each borough was filtered out and re-indexed to form a regular hourly series.

**Two levels of seasonality.** Demand cycles daily and weekly. Within a day the distribution is bimodal, peaking before noon and again in the evening. Across the week, Friday through Sunday run consistently higher than Monday through Thursday. All three boroughs show a steady upward trend across the six months.

**Weather explains very little.** Correlations with pickup count:

| Variable | Correlation |
|---|---|
| temperature | 0.311 |
| dew point | 0.239 |
| snow depth | -0.135 |
| 24-hour precipitation | -0.102 |
| sea level pressure | -0.053 |
| wind speed | -0.044 |
| 6-hour precipitation | 0.024 |
| 1-hour precipitation | 0.018 |
| visibility | -0.004 |
| holiday | -0.011 |

Only temperature and dew point reach even moderate correlation. The signs are intuitive, with warmer weather associated with more pickups and precipitation and snow with fewer, but nothing is strong enough to justify weather variables as regression predictors. Holidays turned out to have essentially no relationship with demand at all. This ruled out a weather-driven regression model early and redirected the work toward pure time series methods.

## Methods

| Family | Variants tested |
|---|---|
| Benchmarks | Mean, naive, seasonal naive, drift |
| Exponential smoothing | Winter's additive, multiplicative, damped |
| Harmonic regression | K = 1 through 6 Fourier terms |
| ARIMA | Orders selected per borough from ACF/PACF after differencing |
| Neural network | NNAR(p, k), p from PACF, k = floor((p+1)/2) |

Stationarity was checked with time plots, ACF, and KPSS. Undifferenced series returned p = 0.01, rejecting stationarity. After seasonal and first differencing, p rose to 0.1, and the differenced series was treated as stationary for ARIMA order selection.

## Results

Best model from each family, evaluated on June:

| Model | Brooklyn RMSE | MAE | MAPE | Manhattan RMSE | MAE | MAPE | Bronx RMSE | MAE | MAPE |
|---|---|---|---|---|---|---|---|---|---|
| Mean | 367 | 269 | 47.6 | 1562 | 1244 | 76.9 | 37.4 | 29.8 | 49.8 |
| Naive | 406 | 342 | 91.9 | 1513 | 1196 | 81.8 | 32.0 | 25.1 | 66.2 |
| Seasonal naive | 443 | 338 | 82.6 | 1275 | 933 | 56.3 | 38.1 | 29.5 | 67.8 |
| Drift | 379 | 310 | 82.6 | 1592 | 1271 | 76.5 | 31.5 | 24.2 | 58.7 |
| Exponential smoothing | 274 | 224 | 39.5 | 967 | 692 | **27.1** | **24.0** | **17.9** | **34.2** |
| Harmonic regression | **251** | **180** | **34.5** | **860** | **634** | 33.0 | 24.5 | 19.5 | 44.3 |
| ARIMA | 308 | 273 | 63.1 | 2932 | 2779 | 143 | 39.7 | 32.5 | 50.1 |
| Neural network | 362 | 256 | 37.6 | 1331 | 1027 | 50.5 | 32.7 | 25.1 | 45.7 |

**Recommendation by borough:**

- **Brooklyn** — harmonic regression, K=5. Wins on all three metrics. RMSE of 251 against 367 for the best benchmark, a 32% reduction.
- **Manhattan** — harmonic regression, K=5 on RMSE and MAE (860 and 634, a 33% RMSE reduction against seasonal naive). Worth noting that damped Winter's beats it on MAPE, 27.1 against 33.0. The two are close enough that the choice depends on whether large-volume hours or proportional accuracy matters more to the planning use case.
- **Bronx** — Winter's additive. Wins on all three metrics, RMSE 24.0 against 31.5 for drift, a 24% reduction. Harmonic regression is nearly identical on RMSE but noticeably worse on MAPE.

### Error Analysis

**Complexity did not pay off.** ARIMA and neural networks were the two most involved methods and both underperformed harmonic regression. The forecast horizon is the reason: one month of hourly data is 720 steps ahead. ARIMA and NNAR would need prohibitively large parameterizations to carry structure that far. The neural network forecasts are accurate for roughly the first 24 hours and then decay, with seasonal amplitude flattening out, because p was set near one daily cycle and the model has no information about longer-period patterns.

**Seasonal naive failed for a diagnosable reason.** It underperformed simpler benchmarks in Brooklyn and the Bronx despite the data being strongly seasonal. The last day of the training window happened to be a weekend, and seasonal naive replicates it forward. Since weekend volume runs high, the entire June forecast was biased upward. Manhattan escaped this because its weekend-to-weekday gap is narrower. This is a training-window artifact rather than a flaw in the method, and it would disappear with a different cutoff date.

**Winter's multiplicative diverged badly**, producing a Manhattan RMSE of 25,209 against 967 for the damped variant. Multiplicative seasonality compounds error over a long horizon.

**Harmonic regression captured daily seasonality but not weekly.** The fitted values reproduce the bimodal rush-hour shape well, but the model does not lift weekend demand the way the actual data does. Raising K to 12 changed nothing, which suggests the weekly component needs to be handled with a separate seasonal period rather than more Fourier terms at the daily frequency. Its prediction intervals are substantially narrower than those from exponential smoothing.

## Business insights

**Surge timing.** Manhattan peaks between 18:00 and 21:00, with over 700,000 pickups in those four hours across the six-month period, close to double the average of all other hours. Brooklyn peaks in the same window at roughly 60% above baseline. The Bronx is far flatter, peaking 17:00–22:00 but at less than half Manhattan's rate of increase, which suggests surge pricing there is more likely driven by driver availability than by demand spikes.

**Weekly and daily patterns.**
- Weekday morning rush 7:00–9:00 tracks commute travel
- Evening rush 17:00–21:00, weakest on Sunday and Monday, strongest Thursday through Saturday
- Demand collapses between 3:00 and 6:00
- Weekend activity shifts later and extends into the early morning
- Saturday and Sunday carry the highest post-midnight volume

**Driver allocation.**
- **Manhattan** needs the highest driver density: weekday mornings 7:00–9:00 near residential areas, evening rush 17:00–21:00 near financial and dining districts, and 22:00–02:00 near nightlife.
- **Brooklyn** needs residential coverage for the 7:00–9:00 commute, dining and residential coverage 18:00–21:00, and weekend late-night coverage 22:00–03:00.
- **Bronx** demand is even enough that targeted allocation matters less. The exceptions are 17:00–22:00 near transit hubs and residential areas, and 05:00–08:00 for outbound commuters heading to Manhattan and Brooklyn.

The borough-level breakdown is what makes this actionable. A single citywide model would have averaged Manhattan's sharp evening spike together with the Bronx's flat profile and produced allocation guidance that fit neither.

## Limitations

- MAPE sits in the 33–35% range even for the winning models. Hourly counts include low-volume overnight hours, where small absolute errors produce large percentage errors, so MAPE overstates the practical error here. RMSE and MAE are the more useful metrics for this data.
- Only one NNAR configuration per borough was trained. A single fit took over 90 minutes in R, which made hyperparameter search impractical. The neural network results should be read as one attempt, not as the best achievable.
- Weekly seasonality is not properly modeled by any method tested. A multi-seasonal approach (TBATS, or harmonic terms at both daily and weekly frequencies) is the obvious next step.
- Six months of history covers no full annual cycle, so nothing here captures yearly seasonality.
- Evaluation is a single fixed train/test split rather than rolling-origin cross-validation, so the accuracy figures depend on the specific choice of June as the test month. The seasonal naive failure above is a direct example of that sensitivity.

Written in R. Requires `fpp3` / `forecast`, `tidyverse`, and `ggplot2`.
