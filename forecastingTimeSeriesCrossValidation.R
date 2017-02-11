##########
# PURPOSE:  This script uses ideas outlined by Rob Hyndman (Monash University) to conduct time-series
#           cross-validation (aka rolling forecast windows) for a given ARIMA specification and ETS
#           specification. 
# INPUTS:   timeseries_object: a time series object
#           min_train_obs:     minimum periods to be used for training
#           forecast_horizon:  # of periods to forecast forward in each rolling window
#           arima_order:       arima specification, e.g. "c(1,0,1)"
#           ets:               exponenential smoothing (ETS) specification, e.g. "ZZZ"
# OUTPUT:   Returns a plot of forecast performance across rolling windows. 
##########


TimeSeriesCV <- function (timeseries_object, min_train_obs = "30", forecast_horizon, periods, arima_order, ets = "ZZZ") {
  
  library(forecast)
  
  #give easier aliases
  ts <- timeseries_object
  k <- min_train_obs
  h <- forecast_horizon
  p <- periods
  n <- length(timeseries_object)
  
  #create a couple objects we'll need
  mae1 <- mae2 <- mae3 <- matrix(NA,n-k,h)
  avg_fct_actual1 <- avg_fct_actual2 <- avg_fct_actual3 <- matrix(NA,n-k,h)
  st <- tsp(ts)[1]+(k-2)/p
  
  #loop through forecasts w/ re-estimation, save MAEs
  for(i in 1:(n-k))
  {
    xshort <- window(ts, end=st + i/p)
    xnext <- window(ts, start=st +(i+1)/p, end=st + (i+h)/p)
    fit1 <- tslm(xshort ~ trend + season)
    fcast1 <- forecast(fit1, h=h)
    fit2 <- Arima(xshort, order=arima_order, 
                  include.drift=TRUE,  method="ML")
    fcast2 <- forecast(fit2, h=h)
    fit3 <- ets(xshort,model=ets,damped=TRUE)
    fcast3 <- forecast(fit3, h=h)
    mae1[i,1:length(xnext)] <- abs(fcast1[['mean']]-xnext)
    mae2[i,1:length(xnext)] <- abs(fcast2[['mean']]-xnext)
    mae3[i,1:length(xnext)] <- abs(fcast3[['mean']]-xnext)
    avg_fct_actual1[i,1:length(xnext)] <- ( abs(fcast1[['mean']] - xnext) / xnext)
    avg_fct_actual2[i,1:length(xnext)] <- ( abs(fcast2[['mean']] - xnext) / xnext)
    avg_fct_actual3[i,1:length(xnext)] <- ( abs(fcast3[['mean']] - xnext) / xnext)
  }
  
  mae1_avg <- as.data.frame(t(rbind(1:12, colMeans(mae1, na.rm=T))))
  colnames(mae1_avg) <- c("Forecast Horizon","LM MAE")
  mae2_avg <- as.data.frame(t(rbind(1:12, colMeans(mae2, na.rm=T))))
  colnames(mae2_avg) <- c("Forecast Horizon","ARIMA MAE")
  mae3_avg <- as.data.frame(t(rbind(1:12, colMeans(mae3, na.rm=T))))
  colnames(mae3_avg) <- c("Forecast Horizon","ETS MAE")
  
  mae_avg <- merge(x = mae1_avg, y = mae2_avg
                   , by = "Forecast Horizon")
  mae_avg <- merge(x = mae_avg, y = mae3_avg
                   , by = "Forecast Horizon")
  
  print(mae_avg)
  
  #plot output
  plot <- plot(1:h, colMeans(mae1,na.rm=TRUE), type="l", col=2
       , main = "Time-Series CV: Rolling Forecasts with Re-estimation"
       , xlab="Forecast Horizon", ylab="Mean Absolute Error (MAE)"
       , ylim=c(0,max(c(mae1,mae2,mae3), na.rm = T)))
  plot <- plot + lines(1:h, colMeans(mae2,na.rm=TRUE), type="l",col=3)
  plot <- plot + lines(1:h, colMeans(mae3,na.rm=TRUE), type="l",col=4)
  plot <- plot + legend("topleft",legend=c("LM","ARIMA","ETS"),col=2:4,lty=1)
  
  #return the plot
  return(plot)
}