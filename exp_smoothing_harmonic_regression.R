
#Exponential Smoothing Models

#Fitting ETS models and checking accuracy

Brooklyn_fit <-  NYC_Uber_Pickups_Brooklyn_train |> model(winters_additive = ETS(pickups ~ error("A") +trend("A") + season("A")), winters_multiplicative = ETS(pickups ~ error("M") + trend("A") + season("M")), winters_damped = ETS(pickups ~ error("M") + trend("Ad") + season("M")))
Brooklyn_fc <- Brooklyn_fit |> forecast(h="1 month")
Brooklyn_fc |> accuracy(NYC_Uber_Pickups_Brooklyn_test)

Manhattan_fit <-  NYC_Uber_Pickups_Manhattan_train |> model(winters_additive = ETS(pickups ~ error("A") +trend("A") + season("A")), winters_multiplicative = ETS(pickups ~ error("M") + trend("A") + season("M")), winters_damped = ETS(pickups ~ error("M") + trend("Ad") + season("M")))
Manhattan_fc <- Manhattan_fit |> forecast(h="1 month")
Manhattan_fc |> accuracy(NYC_Uber_Pickups_Manhattan_test)

Bronx_fit <-  NYC_Uber_Pickups_Bronx_train |> model(winters_additive = ETS(pickups ~ error("A") +trend("A") + season("A")), winters_multiplicative = ETS(pickups ~ error("M") + trend("A") + season("M")), winters_damped = ETS(pickups ~ error("M") + trend("Ad") + season("M")))
Bronx_fc <- Bronx_fit |> forecast(h="1 month")
Bronx_fc |> accuracy(NYC_Uber_Pickups_Bronx_test)

#Plotting the best ETS model for each borough

p1 <- Brooklyn_fc |> filter(.model == "winters_damped") |> autoplot(bind_rows(NYC_Uber_Pickups_Brooklyn_train,NYC_Uber_Pickups_Brooklyn_test)) + autolayer(augment(Brooklyn_fit) |> filter(.model=="winters_damped"),.fitted, colour="red") + labs(title="Winters damped: Brooklyn Uber Pickup",x="", y="")+ scale_x_datetime(date_breaks = "1 month", date_labels = "%b") + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16))

p2 <- Manhattan_fc |> filter(.model == "winters_damped") |> autoplot(bind_rows(NYC_Uber_Pickups_Manhattan_train,NYC_Uber_Pickups_Manhattan_test)) + autolayer(augment(Manhattan_fit) |> filter(.model=="winters_damped"),.fitted, colour="red") + labs(title="Winters damped: Manhattan Uber Pickup",x="", y="Number of Pickups")+ scale_x_datetime(date_breaks = "1 month", date_labels = "%b") + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16),axis.title.y=element_text(margin=margin(0,0,0,-5)))

p3 <- Bronx_fc |> filter(.model == "winters_additive") |> autoplot(bind_rows(NYC_Uber_Pickups_Bronx_train,NYC_Uber_Pickups_Bronx_test)) + autolayer(augment(Bronx_fit) |> filter(.model=="winters_additive"),.fitted, colour="red") + labs(title="Winters additive: Bronx Uber Pickup",x="Month", y="")+ scale_x_datetime(date_breaks = "1 month", date_labels = "%b") + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16))

library(grid)
grid.newpage()
grid.draw(rbind(ggplotGrob(p1), ggplotGrob(p2), ggplotGrob(p3), size = "last"))


#Harmonic Regression Models
#Fitting Harmonic Regression Models and checking accuracy

Brooklyn_fit <-  NYC_Uber_Pickups_Brooklyn_train |> model(K1 = TSLM(pickups ~ trend() + fourier(K=1)), K2 = TSLM(pickups ~ trend() + fourier(K=2)), K3 = TSLM(pickups ~ trend() + fourier(K=3)), K4 = TSLM(pickups ~ trend() + fourier(K=4)), K5 = TSLM(pickups ~ trend() + fourier(K=5)), K6 = TSLM(pickups ~ trend() + fourier(K=6)))
Brooklyn_fc <- Brooklyn_fit |> forecast(h='1 month')
Brooklyn_fc |> accuracy(NYC_Uber_Pickups_Brooklyn_test)

Manhattan_fit <-  NYC_Uber_Pickups_Manhattan_train |> model(K1 = TSLM(pickups ~ trend() + fourier(K=1)), K2 = TSLM(pickups ~ trend() + fourier(K=2)), K3 = TSLM(pickups ~ trend() + fourier(K=3)), K4 = TSLM(pickups ~ trend() + fourier(K=4)), K5 = TSLM(pickups ~ trend() + fourier(K=5)), K6 = TSLM(pickups ~ trend() + fourier(K=6)))
Manhattan_fc <- Manhattan_fit |> forecast(h='1 month')
Manhattan_fc |> accuracy(NYC_Uber_Pickups_Manhattan_test)

Bronx_fit <-  NYC_Uber_Pickups_Bronx_train |> model(K1 = TSLM(pickups ~ trend() + fourier(K=1)), K2 = TSLM(pickups ~ trend() + fourier(K=2)), K3 = TSLM(pickups ~ trend() + fourier(K=3)), K4 = TSLM(pickups ~ trend() + fourier(K=4)), K5 = TSLM(pickups ~ trend() + fourier(K=5)), K6 = TSLM(pickups ~ trend() + fourier(K=6)))
Bronx_fc <- Bronx_fit |> forecast(h='1 month')
Bronx_fc |> accuracy(NYC_Uber_Pickups_Bronx_test)

#Plotting the best Harmonic Regression model for each borough

p1 <- Brooklyn_fc |> filter(.model == "K5") |> autoplot(bind_rows(NYC_Uber_Pickups_Brooklyn_train,NYC_Uber_Pickups_Brooklyn_test)) + autolayer(augment(Brooklyn_fit) |> filter(.model=="K5"),.fitted, colour="red") + labs(title="K=5 Harmonic Regression: Brooklyn Uber Pickup",x="", y="") + scale_x_datetime(date_breaks = "1 month", date_labels = "%b",limits = lims) + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16))

p2 <- Manhattan_fc |> filter(.model == "K6") |> autoplot(bind_rows(NYC_Uber_Pickups_Manhattan_train,NYC_Uber_Pickups_Manhattan_test)) + autolayer(augment(Manhattan_fit) |> filter(.model=="K6"),.fitted, colour="red") + labs(title="K=6 Harmonic Regression: Manhattan Uber Pickup",x="", y="Number of Pickups") + scale_x_datetime(date_breaks = "1 month", date_labels = "%b",limits = lims) + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16),axis.title.y=element_text(margin=margin(0,0,0,-5)))
library(grid)

p3 <- Bronx_fc |> filter(.model == "K5") |> autoplot(bind_rows(NYC_Uber_Pickups_Bronx_train,NYC_Uber_Pickups_Bronx_test)) + autolayer(augment(Bronx_fit) |> filter(.model=="K5"),.fitted, colour="red") + labs(title="K=5 Harmonic Regression: Bronx Uber Pickup",x="Month", y="") + scale_x_datetime(date_breaks = "1 month", date_labels = "%b",limits = lims) + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16))

library(grid)
grid.newpage()
grid.draw(rbind(ggplotGrob(p1), ggplotGrob(p2), ggplotGrob(p3), size = "last"))