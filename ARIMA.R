#ARIMA  Brooklyn

NYC_Uber_Pickups_Brooklyn_train |> gg_tsdisplay(pickups, plot_type="partial", lag= 36) + labs(title = "NYC Uber Pickups: Brooklyn", y = "")

#p-value
NYC_Uber_Pickups_Brooklyn_train |> features(pickups,unitroot_kpss)

#Number of seasonal difference 
NYC_Uber_Pickups_Brooklyn_train |> features(pickups,unitroot_nsdiffs)

# Number of first differences
NYC_Uber_Pickups_Brooklyn_train |> features(pickups,unitroot_ndiffs)

#Double difference
NYC_Uber_Pickups_Brooklyn_train |> gg_tsdisplay(difference(pickups,12)|> difference(), plot_type="partial", lag= 36) + labs(title = "Double differenced: Brooklyn Pickups", y = "")

#Double difference: p value
NYC_Uber_Pickups_Brooklyn_train |> features(difference(pickups,12)|> difference(),unitroot_kpss)

#Fit, forecast and accuracy

#For non seasonal differences - 3,1
#For seasonal difference - 1,1
#Possible Arima combinations to try ARIMA(3,1,1) (1,1,1) and (1,1,3) (1,1,1)
Brooklyn_fit <- NYC_Uber_Pickups_Brooklyn_train |> model(arima311111 = ARIMA(pickups ~ pdq(3,1,1) + PDQ(1,1,1)), arima113111 = ARIMA(pickups ~ pdq(1,1,3) + PDQ(1,1,1)))
Brooklyn_fc <- Brooklyn_fit |> forecast(h=720)
Brooklyn_fc |> accuracy(NYC_Uber_Pickups_Brooklyn_test)

#Arima311111 has the lowest RMSE out of all ARIMA models
Brooklyn_fc |> filter(.model=="arima311111") |> autoplot(bind_rows(NYC_Uber_Pickups_Brooklyn_train,NYC_Uber_Pickups_Brooklyn_test)) + autolayer(augment(Brooklyn_fit)|> filter(.model=="arima311111"), .fitted, colour="red") + labs(y="pickups", title = "Brooklyn Pickups:Arima Forecast") 

#ARIMA  Bronx
NYC_Uber_Pickups_Bronx <- NYC_Uber_Pickups |> filter(borough=="Bronx") |> as_tsibble(index=pickup_dt)
NYC_Uber_Pickups_Bronx_train <-  NYC_Uber_Pickups_Bronx |> filter(month(pickup_dt)<=5)
NYC_Uber_Pickups_Bronx_test <-  NYC_Uber_Pickups_Bronx |> filter(month(pickup_dt)>5)
gg_tsdisplay
NYC_Uber_Pickups_Bronx_train |> gg_tsdisplay(pickups, plot_type="partial", lag= 36) + labs(title = "NYC Uber Pickups: Bronx", y = "")

#p-value
NYC_Uber_Pickups_Bronx_train |> features(pickups,unitroot_kpss)
#Series is not stationary since it has a small p of 0.01, indicating that the null hypothesis is rejected. The data are not stationary.

#Number of seasonal differences
NYC_Uber_Pickups_Bronx_train |> features(pickups,unitroot_nsdiffs)
#Number of seasonal differences required is zero.

#Number of first differences
NYC_Uber_Pickups_Bronx_train |> features(pickups,unitroot_ndiffs)
#Number of first differences required is one.

NYC_Uber_Pickups_Bronx_train |> gg_tsdisplay(difference(pickups), plot_type="partial", lag= 36) + labs(title = "First difference: Bronx Pickups", y = "")
NYC_Uber_Pickups_Bronx_train |> features(difference(pickups),unitroot_kpss)
#P-value reported as 0.1 (and so it could be larger than that). We can conclude that the differenced data appear stationary.
#For non seasonal differences - 3,0
#For seasonal difference - 2,0

#Fit,forecast and accuracy
Bronx_fit <- NYC_Uber_Pickups_Bronx_train |> model(arima310200 = ARIMA(pickups ~ pdq(3,1,0) + PDQ(2,0,0)), arima013012 = ARIMA(pickups ~ pdq(0,1,3) + PDQ(0,1,2)))
Bronx_fc <- Bronx_fit |> forecast(h=720)
Bronx_fc |> accuracy(NYC_Uber_Pickups_Bronx_test)
#Arima013012 has the lowest RMSE
Bronx_fc |> filter(.model=="arima013012") |> autoplot(bind_rows(NYC_Uber_Pickups_Bronx_train,NYC_Uber_Pickups_Bronx_test)) + autolayer(augment(Bronx_fit)|> filter(.model=="arima013012"), .fitted, colour="red") + labs(y="pickups", title = "Bronx Pickups:Arima Forecast")


#ARIMA Manhattan
NYC_Uber_Pickups_Manhattan <- NYC_Uber_Pickups |> filter(borough=="Manhattan") |> as_tsibble(index=pickup_dt)
NYC_Uber_Pickups_Manhattan_train <-  NYC_Uber_Pickups_Manhattan |> filter(month(pickup_dt)<=5)
NYC_Uber_Pickups_Manhattan_test <-  NYC_Uber_Pickups_Manhattan |> filter(month(pickup_dt)>5)

NYC_Uber_Pickups_Manhattan_train |> gg_tsdisplay(pickups, plot_type="partial", lag= 36) + labs(title = "NYC Uber Pickups: Manhattan", y = "")

#p-value
NYC_Uber_Pickups_Manhattan_train |> features(pickups,unitroot_kpss)
#Series is not stationary since it has a small p of 0.01, indicating that the null hypothesis is rejected. The data are not stationary.

#Number of seasonal differences
NYC_Uber_Pickups_Manhattan_train |> features(pickups,unitroot_nsdiffs)
#Number of seasonal differences required is one.

#Number of first differences
NYC_Uber_Pickups_Manhattan_train |> features(pickups,unitroot_ndiffs)
#Number of first differences required is one.

NYC_Uber_Pickups_Manhattan_train |> gg_tsdisplay(difference(pickups,12)|> difference(), plot_type="partial", lag= 36) + labs(title = "Double differenced: Manhattan Pickups", y = "")
#p-value
NYC_Uber_Pickups_Manhattan_train |> features(difference(pickups,12)|> difference(),unitroot_kpss)
#P-value reported as 0.1 (and so it could be larger than that). We can conclude that the differenced data appear stationary.

Manhattan_fit <- NYC_Uber_Pickups_Manhattan_train |> model(arima310210 = ARIMA(pickups ~ pdq(3,1,0) + PDQ(2,1,0)), arima013012 = ARIMA(pickups ~ pdq(0,1,3) + PDQ(0,1,2)))
Manhattan_fc <- Manhattan_fit |> forecast(h=720)
Manhattan_fc |> accuracy(NYC_Uber_Pickups_Manhattan_test)
#Arima013012 has the lowest RMSE
Manhattan_fc |> filter(.model=="arima013012") |> autoplot(bind_rows(NYC_Uber_Pickups_Manhattan_train,NYC_Uber_Pickups_Manhattan_test)) + autolayer(augment(Manhattan_fit)|> filter(.model=="arima013012"), .fitted, colour="red") + labs(y="pickups", title = "Manhattan Pickups:Arima Forecast")


#Plotting all ARIMA models together
p1 <- Brooklyn_fc |> filter(.model=="arima311111") |> autoplot(bind_rows(NYC_Uber_Pickups_Brooklyn_train,NYC_Uber_Pickups_Brooklyn_test)) + autolayer(augment(Brooklyn_fit)|> filter(.model=="arima311111"), .fitted, colour="red") + labs(title = "Brooklyn Pickups:Arima Forecast",x='',y='')+ scale_x_datetime(date_breaks = "1 month", date_labels = "%b",limits = lims) + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16))
p2 <- Manhattan_fc |> filter(.model=="arima013012") |> autoplot(bind_rows(NYC_Uber_Pickups_Manhattan_train,NYC_Uber_Pickups_Manhattan_test)) + autolayer(augment(Manhattan_fit)|> filter(.model=="arima013012"), .fitted, colour="red") + labs( title = "Manhattan Pickups:Arima Forecast",x='',y='Number of Pickups')+ scale_x_datetime(date_breaks = "1 month", date_labels = "%b",limits = lims) + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16),axis.title.y=element_text(margin=margin(0,0,0,-5)))
p3 <- Bronx_fc |> filter(.model=="arima013012") |> autoplot(bind_rows(NYC_Uber_Pickups_Bronx_train,NYC_Uber_Pickups_Bronx_test)) + autolayer(augment(Bronx_fit)|> filter(.model=="arima013012"), .fitted, colour="red") + labs(x='Month',y='',title = "Bronx Pickups:Arima Forecast")+ theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16))+scale_x_datetime(date_breaks = "1 month", date_labels = "%b",limits = lims)

library(grid)
grid.newpage()
grid.draw(rbind(ggplotGrob(p1), ggplotGrob(p2), ggplotGrob(p3), size = "last"))