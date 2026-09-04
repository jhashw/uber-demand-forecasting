#Benchmarking Forecasting Methods

#Mean, Naive and Drift

fit_NYC_Uber_Pickups_Brooklyn <- NYC_Uber_Pickups_Brooklyn_train |> model(mean=MEAN(pickups), naive=NAIVE(pickups), Drift=RW(pickups ~ drift()))

fc_NYC_Uber_Pickups_Brooklyn <- fit_NYC_Uber_Pickups_Brooklyn |> forecast (h="1 month")

fit_NYC_Uber_Pickups_Manhattan <- NYC_Uber_Pickups_Manhattan_train |> model(mean=MEAN(pickups), naive=NAIVE(pickups), Drift=RW(pickups ~ drift()))

fc_NYC_Uber_Pickups_Manhattan <- fit_NYC_Uber_Pickups_Manhattan |> forecast (h="1 month")

fit_NYC_Uber_Pickups_Bronx <- NYC_Uber_Pickups_Bronx_train |> model(mean=MEAN(pickups), naive=NAIVE(pickups), Drift=RW(pickups ~ drift()))

fc_NYC_Uber_Pickups_Bronx <- fit_NYC_Uber_Pickups_Bronx |> forecast (h="1 month")

lims <- as.POSIXct(strptime(c("2015-04-01 01:00:00", "2015-07-01 01:00:00"), format = "%Y-%m-%d %H:%M:%S"))

p1 <- fc_NYC_Uber_Pickups_Brooklyn |> autoplot(NYC_Uber_Pickups_Brooklyn, level=NULL) + guides(colour = guide_legend (title = "Forecast")) + labs (title = "1 month forecast of Uber Pickups in Brooklyn" , x= "", y="")+ scale_x_datetime(date_breaks = "1 month", date_labels = "%b", limits=lims) + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16))

p2 <- fc_NYC_Uber_Pickups_Manhattan |> autoplot(NYC_Uber_Pickups_Manhattan, level=NULL, size=1) + guides(colour = guide_legend (title = "Forecast")) + labs (title = "1 month forecast of Uber Pickups in Manhattan" , x= "", y="Number of Pickups")+ scale_x_datetime(date_breaks = "1 month", date_labels = "%b",limits=lims) + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16),axis.title.y=element_text(margin=margin(0,0,0,-5)))

p3 <- fc_NYC_Uber_Pickups_Bronx |> autoplot(NYC_Uber_Pickups_Bronx, level=NULL, size=1) + guides(colour = guide_legend (title = "Forecast")) + labs (title = "1 month forecast of Uber Pickups in Bronx" , x= "Month", y="")+ scale_x_datetime(date_breaks = "1 month", date_labels = "%b",limits = lims) + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16))

library(grid)
grid.newpage()
grid.draw(rbind(ggplotGrob(p1), ggplotGrob(p2), ggplotGrob(p3), size = "last"))


#Seasonal Naive

fit_NYC_Uber_Pickups_Brooklyn <- NYC_Uber_Pickups_Brooklyn_train |> model(snaive=SNAIVE(pickups))
fc_NYC_Uber_Pickups_Brooklyn <- fit_NYC_Uber_Pickups_Brooklyn |> forecast (h="1 month")

fit_NYC_Uber_Pickups_Manhattan <- NYC_Uber_Pickups_Manhattan_train |> model(snaive=SNAIVE(pickups))
fc_NYC_Uber_Pickups_Manhattan <- fit_NYC_Uber_Pickups_Manhattan |> forecast (h="1 month")

fit_NYC_Uber_Pickups_Bronx <- NYC_Uber_Pickups_Bronx_train |> model(snaive=SNAIVE(pickups))
fc_NYC_Uber_Pickups_Bronx <- fit_NYC_Uber_Pickups_Bronx |> forecast (h="1 month")

p1 <- fc_NYC_Uber_Pickups_Brooklyn |> autoplot(NYC_Uber_Pickups_Brooklyn, level=NULL) + guides(colour = guide_legend (title = "Forecast")) + labs (title = "1 month forecast of Uber Pickups in Brooklyn" , x= "", y="")+ scale_x_datetime(date_breaks = "1 month", date_labels = "%b") + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16))

p2 <- fc_NYC_Uber_Pickups_Manhattan |> autoplot(NYC_Uber_Pickups_Manhattan, level=NULL) + guides(colour = guide_legend (title = "Forecast")) + labs (title = "1 month forecast of Uber Pickups in Manhattan" , x= "", y="Number of Pickups")+ scale_x_datetime(date_breaks = "1 month", date_labels = "%b") + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16),axis.title.y=element_text(margin=margin(0,0,0,-5)))

p3 <- fc_NYC_Uber_Pickups_Bronx |> autoplot(NYC_Uber_Pickups_Bronx, level=NULL) + guides(colour = guide_legend (title = "Forecast")) + labs (title = "1 month forecast of Uber Pickups in Bronx" , x= "Month", y="")+ scale_x_datetime(date_breaks = "1 month", date_labels = "%b") + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16))

library(grid)
grid.newpage()
grid.draw(rbind(ggplotGrob(p1), ggplotGrob(p2), ggplotGrob(p3), size = "last"))


#Accuracies for Benchmark Forecasting Methods

fit_NYC_Uber_Pickups_Brooklyn <- NYC_Uber_Pickups_Brooklyn |> model(mean=MEAN(pickups), naive=NAIVE(pickups), snaive=SNAIVE(pickups), Drift=RW(pickups ~ drift()))
fc_NYC_Uber_Pickups_Brooklyn <- fit_NYC_Uber_Pickups_Brooklyn |> forecast(h="1 month")
fc_NYC_Uber_Pickups_Brooklyn |> accuracy(NYC_Uber_Pickups_Brooklyn_test)

fit_NYC_Uber_Pickups_Manhattan <- NYC_Uber_Pickups_Manhattan_train |> model(mean=MEAN(pickups), naive=NAIVE(pickups), snaive=SNAIVE(pickups), Drift=RW(pickups ~ drift()))
fc_NYC_Uber_Pickups_Manhattan <- fit_NYC_Uber_Pickups_Manhattan |> forecast(h="1 month")
fc_NYC_Uber_Pickups_Manhattan |> accuracy(NYC_Uber_Pickups_Manhattan_test)

fit_NYC_Uber_Pickups_Bronx <- NYC_Uber_Pickups_Bronx_train |> model(mean=MEAN(pickups), naive=NAIVE(pickups), snaive=SNAIVE(pickups), Drift=RW(pickups ~ drift()))
fc_NYC_Uber_Pickups_Bronx <- fit_NYC_Uber_Pickups_Bronx |> forecast(h="1 month")
fc_NYC_Uber_Pickups_Bronx |> accuracy(NYC_Uber_Pickups_Bronx_test)

