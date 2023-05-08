install.packages("RMySQL")


library(ggplot2)
library(ggmap)
library(RColorBrewer)
library(RMySQL)



dbcon = dbConnect(MySQL(), user='root', password='', dbname='track', host='localhost')
result = dbSendQuery(dbcon, "select lat,lon from data_location")
stations = fetch(result, n=-1)




df = data.frame(stations$lat,stations$lon)
colnames(df) <- c('Latitude','Longitude')
coords.data <- df




map_bounds <- c(left = 79, bottom = 5.6, right = 82.3, top = 10.2)
coords.map <- get_stamenmap(map_bounds, zoom = 7, maptype = "toner-lite")



coords.map <- ggmap(coords.map, extent="device", legend="none")



coords.map <- coords.map + stat_density2d(data=coords.data, aes(x=Longitude, y=Latitude, fill=..level.., alpha=..level..), geom="polygon")
coords.map <- coords.map + scale_fill_gradientn(colours=rev(brewer.pal(7, "Spectral")))
coords.map <- coords.map + geom_point(data=coords.data, aes(x=Longitude, y=Latitude), fill="red", shape=23, alpha=0.8)
coords.map <- coords.map + theme_bw()
ggsave(filename="heatmap.png")


