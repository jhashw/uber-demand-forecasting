#Neural Network Models

#Fitting and forecasting models

Brooklyn_fit_NN <- NYC_Uber_Pickups_Brooklyn_train |> model(NNAR27_14 = NNETAR(pickups, 27, n_nodes =14))
Brooklyn_fc <- Brooklyn_fit_NN |> forecast(h="1 month")

Manhattan_fit_NN <- NYC_Uber_Pickups_Manhattan_train |> model(NNAR25_13 = NNETAR(pickups, 25, n_nodes =13))
Manhattan_fc <- Manhattan_fit_NN |> forecast(h="1 month")

Bronx_fit_NN <- NYC_Uber_Pickups_Bronx_train |> model(NNAR26_13 = NNETAR(pickups, 26, n_nodes =13))
Bronx_fc <- Bronx_fit_NN |> forecast(h="1 month")

#Plotting forecasts with prediction intervals

p1 <- Brooklyn_fc |> autoplot(bind_rows(NYC_Uber_Pickups_Brooklyn_train,NYC_Uber_Pickups_Brooklyn_test)) + autolayer(augment(Brooklyn_fit_NN),.fitted, colour="red") + labs(title="Neural Net Model (27,14): Brooklyn Uber Pickup",x="", y="") + scale_x_datetime(date_breaks = "1 month", date_labels = "%b",limits = lims) + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16))
p2 <- Manhattan_fc |> autoplot(bind_rows(NYC_Uber_Pickups_Manhattan_train,NYC_Uber_Pickups_Manhattan_test)) + autolayer(augment(Manhattan_fit_NN),.fitted, colour="red") + labs(title="Neural Net Model (25,13): Manhattan Uber Pickup",x="", y="Number of Pickups") + scale_x_datetime(date_breaks = "1 month", date_labels = "%b",limits = lims) + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16),axis.title.y=element_text(margin=margin(0,0,0,-5)))
p3 <- Bronx_fc |> autoplot(bind_rows(NYC_Uber_Pickups_Bronx_train,NYC_Uber_Pickups_Bronx_test)) + autolayer(augment(Bronx_fit_NN),.fitted, colour="red") + labs(title="Neural Net Model (26,13): Bronx Uber Pickup",x="", y="") + scale_x_datetime(date_breaks = "1 month", date_labels = "%b",limits = lims) + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16))
grid.newpage()
grid.draw(rbind(ggplotGrob(p1), ggplotGrob(p2), ggplotGrob(p3), size = "last"))

#Plotting forecasts without prediction intervals
p1 <- Brooklyn_fc |> autoplot(bind_rows(NYC_Uber_Pickups_Brooklyn_train,NYC_Uber_Pickups_Brooklyn_test),level=NULL) + autolayer(augment(Brooklyn_fit_NN),.fitted, colour="red") + labs(title="Neural Net Model (27,14): Brooklyn Uber Pickup",x="", y="") + scale_x_datetime(date_breaks = "1 month", date_labels = "%b",limits = lims) + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16))
p2 <- Manhattan_fc |> autoplot(bind_rows(NYC_Uber_Pickups_Manhattan_train,NYC_Uber_Pickups_Manhattan_test),level=NULL) + autolayer(augment(Manhattan_fit_NN),.fitted, colour="red") + labs(title="Neural Net Model (25,13): Manhattan Uber Pickup",x="", y="Number of Pickups") + scale_x_datetime(date_breaks = "1 month", date_labels = "%b",limits = lims) + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16),axis.title.y=element_text(margin=margin(0,0,0,-5)))
p3 <- Bronx_fc |> autoplot(bind_rows(NYC_Uber_Pickups_Bronx_train,NYC_Uber_Pickups_Bronx_test),level=NULL) + autolayer(augment(Bronx_fit_NN),.fitted, colour="red") + labs(title="Neural Net Model (26,13): Bronx Uber Pickup",x="", y="") + scale_x_datetime(date_breaks = "1 month", date_labels = "%b",limits = lims) + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16))
grid.newpage()
grid.draw(rbind(ggplotGrob(p1), ggplotGrob(p2), ggplotGrob(p3), size = "last"))





