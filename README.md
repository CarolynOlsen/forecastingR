# forecastingR
R functions for improved time-series forecasting

`forecastingTimeSeriesCrossValidation.R` defines functions to implement time-series cross-validation (aka rolling forecast windows) for a given ARIMA specification and ETS specification. These ideas were outlined by Rob Hyndman (Monash University), creater of the `forecast` package in R. 

`forecastingPlotErrorsHistogram.R` defines a function to take a vector of forecast errors and plot a histogram of errors including a blue line representing a standard normal distribution for comparison. 
