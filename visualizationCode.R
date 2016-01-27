# Visualizing the crimes in the Houston area - based on the article 'ggmap : Spatial Visualization with ggplot2 by David Kahle and Hadley Wickham'
# Load ggmap and ggplot2
library(ggmap)
library(ggplot2)

# Get the map of houston

qmap('houston', zoom = 13)

# Only violent crimes

violent_crimes <- subset(crime, offense != "auto theft" & offense != "theft" & offense != "burglary")

# Ordering violent crimes

violent_crimes$offense <- factor(violent_crimes$offense, levels = c("robbery", "aggravated assault", "rape", "murder"))

# Restrict only to downtown

violent_crimes <- subset(violent_crimes, -95.39681 <= lon & lon <= -95.34188 & 29.73631 <= lat & lat <= 29.78400)

# Using geom_point first

theme_set(theme_bw(16))
HoustonMap <- qmap("houston", zoom = 14, color = "bw", legend = "topright")

HoustonMap + geom_point(aes(x = lon, y = lat, colour = offense, size = offense), data = violent_crimes)

# Using bins instead of points (we know better where the events are happening at the expense of knowing their frequency)
HoustonMap + stat_bin2d(aes(x = lon, y = lat, colour = offense, fill = offense), size = .5, bins = 30, alpha = 1/2, data = violent_crimes)

# Neglect the type of offense and simply show the geospatial distribution of crimes 
HoustonMap + stat_density2d(aes(x = lon, y = lat, fill = ..level.., alpha = ..level..), size = 2, 
                           data = violent_crimes, geom = "polygon")

# Crime across days

houston <- get_map(location = "houston", zoom = 14, color = "bw", source = "osm")
HoustonMap <- ggmap(houston, base_layer = ggplot(aes(x = lon, y = lat), data = violent_crimes))
HoustonMap + stat_density2d(aes(x = lon, y = lat, fill = ..level.., alpha = ..level..), 
                            geom = "polygon", data = violent_crimes) + scale_fill_gradient(low = "black", high = "red") + 
  facet_wrap(~day)

