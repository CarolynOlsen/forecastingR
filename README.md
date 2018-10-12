# r-forecastingUtilities
R functions for improved time-series forecasting

`forecastingTimeSeriesCrossValidation.R` defines functions to implement time-series cross-validation (aka rolling forecast windows) for a given ARIMA specification and ETS specification. These ideas were outlined by Rob Hyndman (Monash University), creater of the `forecast` package in R. Since creation of this script, Rob Hyndman has added similar functionality to the `forecast` package, [described here](https://robjhyndman.com/hyndsight/tscv/). However, the script defined here includes more granular plotting output of performance across rolling windows. 

`forecastingPlotErrorsHistogram.R` defines a function to take a vector of forecast errors and plot a histogram of errors including a blue line representing a standard normal distribution for comparison. 
