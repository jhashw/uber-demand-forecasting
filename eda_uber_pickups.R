## Exploratory Data Analysis

p1 <- NYC_Uber_Pickups_Brooklyn |> autoplot(pickups) + labs (x = "Month", title = "Pickups in Brooklyn (Jan-June 2015)") + scale_x_datetime(date_breaks = "1 month", date_labels = "%b") + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16))

p2 <- NYC_Uber_Pickups_Manhattan |> autoplot(pickups) + labs (y="Number of pickups", x = "Month", title = "Pickups in Manhattan (Jan-June 2015)") + scale_x_datetime(date_breaks = "1 month", date_labels = "%b") + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16))

p3 <- NYC_Uber_Pickups_Bronx |> autoplot(pickups) + labs (x = "Month", title = "Pickups in Bronx (Jan-June 2015)") + scale_x_datetime(date_breaks = "1 month", date_labels = "%b") + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16))

library(grid)
grid.newpage()
grid.draw(rbind(ggplotGrob(p1), ggplotGrob(p2), ggplotGrob(p3), size = "last"))


# Visualizing data - zooming into last month of June

lims <- as.POSIXct(strptime(c("2015-06-01 01:00:00", "2015-07-01 01:00:00"), format = "%Y-%m-%d %H:%M:%S"))

p1 <- NYC_Uber_Pickups_Brooklyn |> autoplot(pickups) + labs (x = "", y="", title = "Pickups in Brooklyn (June 2015)") + scale_x_datetime(date_breaks = "1 day", date_labels = "%a", limits=lims) + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16), axis.text.x = element_text(size=12))

p2 <- NYC_Uber_Pickups_Manhattan |> autoplot(pickups) + labs (y="Number of pickups", x = "", title = "Pickups in Manhattan (June 2015)") + scale_x_datetime(date_breaks = "1 day", date_labels = "%a", limits=lims) + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16, vjust=2), axis.title.y=element_text(margin=margin(0,0,0,-5)), axis.text.x = element_text(size=12))

p3 <- NYC_Uber_Pickups_Bronx |> autoplot(pickups) + labs (x = "Month", y="", title = "Pickups in Bronx (June 2015)") + scale_x_datetime(date_breaks = "1 day", date_labels = "%a",limits=lims) + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16),axis.text.x = element_text(size=12))

library(grid)
grid.newpage()
grid.draw(rbind(ggplotGrob(p1), ggplotGrob(p2), ggplotGrob(p3), size = "last"))

#Calculating and plotting correlations:
  
install.packages("GGally")
library(GGally)

NYC_Uber_Pickups_Brooklyn_df <- data.frame(NYC_Uber_Pickups_Brooklyn)
ggpairs(NYC_Uber_Pickups_Brooklyn_df, columns=c('pickups', 'spd', 'vsb',
                                                'temp', 'dewp','slp','pcp01','pcp06','pcp24','sd','hday'))

p1 <- NYC_Uber_Pickups_Brooklyn |> ggplot(aes(x = temp, y = pickups)) + geom_point(size=1) + geom_smooth(method="lm", se=FALSE)+ theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16),axis.text.x = element_text(size=14)) + labs(x="temperature (F)")

p2 <- NYC_Uber_Pickups_Brooklyn |> ggplot(aes(x = dewp, y = pickups)) + geom_point(size=1) + geom_smooth(method="lm", se=FALSE) + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16),axis.text.x = element_text(size=12))+ labs(x="dew point (F)")

p3 <- NYC_Uber_Pickups_Brooklyn |> ggplot(aes(x = pcp24, y = pickups)) + geom_point(size=1) + geom_smooth(method="lm", se=FALSE) + theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16),axis.text.x = element_text(size=12))+ labs(x="24-hour precipitation")

p4 <- NYC_Uber_Pickups_Brooklyn |> ggplot(aes(x = sd, y = pickups)) + geom_point(size=1) + geom_smooth(method="lm", se=FALSE)+ theme(title=element_text(size=16), axis.text=element_text(size=14), axis.title=element_text(size=16),axis.text.x = element_text(size=12))+ labs(x="snow depth (in)")
library(grid)
grid.newpage()
grid.draw(rbind(ggplotGrob(p1), ggplotGrob(p3), ggplotGrob(p4), size = "last"))

