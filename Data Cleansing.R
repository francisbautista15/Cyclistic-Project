#Loading Data into RStudio

trip_jul_21 <- read.csv("~/Francis Bautista/Case Study/Data/Raw/202107-divvy-tripdata.csv")
trip_aug_21 <- read.csv("~/Francis Bautista/Case Study/Data/Raw/202108-divvy-tripdata.csv")
trip_sep_21 <- read.csv("~/Francis Bautista/Case Study/Data/Raw/202109-divvy-tripdata.csv")
trip_oct_21 <- read.csv("~/Francis Bautista/Case Study/Data/Raw/202110-divvy-tripdata.csv")
trip_nov_21 <- read.csv("~/Francis Bautista/Case Study/Data/Raw/202111-divvy-tripdata.csv")
trip_dec_21 <- read.csv("~/Francis Bautista/Case Study/Data/Raw/202112-divvy-tripdata.csv")
trip_jan_22 <- read.csv("~/Francis Bautista/Case Study/Data/Raw/202201-divvy-tripdata.csv")
trip_feb_22 <- read.csv("~/Francis Bautista/Case Study/Data/Raw/202202-divvy-tripdata.csv")
trip_mar_22 <- read.csv("~/Francis Bautista/Case Study/Data/Raw/202203-divvy-tripdata.csv")
trip_apr_22 <- read.csv("~/Francis Bautista/Case Study/Data/Raw/202204-divvy-tripdata.csv")
trip_may_22 <- read.csv("~/Francis Bautista/Case Study/Data/Raw/202205-divvy-tripdata.csv")
trip_jun_22 <- read.csv("~/Francis Bautista/Case Study/Data/Raw/202206-divvy-tripdata.csv")

#Combining all 12 months into one dataset for analysis

trip_fy22 <- rbind(
  trip_jul_21,
  trip_aug_21,
  trip_sep_21,
  trip_oct_21,
  trip_nov_21,
  trip_dec_21,
  trip_jan_22,
  trip_feb_22,
  trip_mar_22,
  trip_apr_22,
  trip_may_22,
  trip_jun_22
)

#Viewing newly created dataset

View(trip_fy22)

#Removal of Unused Columns

trip_fy22 <- trip_fy22 %>%
  select(-c(start_lat, 
            start_lng, 
            end_lat,
            end_lng,
            start_station_id,
            start_station_name,
            end_station_id,
            end_station_name))

#Creation of additional columns to seperate date and time

trip_fy22$date <- as.Date(trip_fy22$started_at)
trip_fy22$day_of_week <- format(as.Date(trip_fy22$date), "%A")
trip_fy22$day <- format(as.Date(trip_fy22$date), "%d")
trip_fy22$month <- format(as.Date(trip_fy22$date), "%m")
trip_fy22$year <- format(as.Date(trip_fy22$date), "%Y")
trip_fy22$time <- format(trip_fy22$started_at, format = "%H:%M")
trip_fy22$time <- as.POSIXct(trip_fy22$time, format = "%H:%M")

#Writing dataset to be imported into SQL Database

write.table(trip_fy22, file="trip_data.csv", sep=",",row.names=FALSE)