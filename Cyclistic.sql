SELECT 
FROM [Cyclistic Project].[dbo].[trip_data]

-- Creating table to compare casual v member monthly

---- Firstly explore how to layout table to show total rides monthly
SELECT
month,
year,
COUNT(ride_id) AS num_of_rides_casual
FROM [Cyclistic Project].[dbo].[trip_data]
WHERE member_casual = 'casual'
GROUP BY month, year
ORDER BY year, month

SELECT
month,
year,
COUNT(ride_id) AS num_of_rides_member
FROM [Cyclistic Project].[dbo].[trip_data]
WHERE member_casual = 'member'
GROUP BY month, year
ORDER BY year, month

---- Creating Temp Tables for Number of Rides of Casual and Member Users

CREATE TABLE #member_riders
(month INT,
year INT,
num_of_rides_member INT
)

INSERT INTO #member_riders
SELECT
month,
year,
COUNT(ride_id) AS num_of_rides_member
FROM [Cyclistic Project].[dbo].[trip_data]
WHERE member_casual = 'member'
GROUP BY month, year
ORDER BY year, month

CREATE TABLE #casual_riders
(month INT,
year INT,
num_of_rides_casual INT
)

INSERT INTO #casual_riders
SELECT
month,
year,
COUNT(ride_id) AS num_of_rides_casual
FROM [Cyclistic Project].[dbo].[trip_data]
WHERE member_casual = 'casual'
GROUP BY month, year
ORDER BY year, month

----- Creating table for Data Visualisation

SELECT
#casual_riders.month,
#casual_riders.year,
num_of_rides_casual,
num_of_rides_member
FROM #casual_riders
INNER JOIN #member_riders
	ON #casual_riders.month = #member_riders.month
ORDER BY year, month

-- Exploring Average Ride Time per Day of Week 

SELECT 
	day_of_week,
	AVG((DATEDIFF(minute,started_at, ended_at))) AS ride_duration_casual
  FROM [Cyclistic Project].[dbo].[trip_data]
  WHERE member_casual = 'casual'
  GROUP BY day_of_week

---- Creating temp table for casual users
CREATE TABLE #casual_riders_duration_daily
(day_of_week varchar(50),
duration_of_ride_casual INT
)

INSERT INTO #casual_riders_duration_daily
SELECT 
	day_of_week,
	AVG((DATEDIFF(minute,started_at, ended_at))) AS duration_of_ride_casual
  FROM [Cyclistic Project].[dbo].[trip_data]
  WHERE member_casual = 'casual'
  GROUP BY day_of_week

 Select *
 FROM #casual_riders_duration_daily

 ---- Creating temp table for member users
CREATE TABLE #member_riders_duration_daily
(day_of_week varchar(50),
duration_of_ride_member INT
)

INSERT INTO #member_riders_duration_daily
SELECT 
	day_of_week,
	AVG((DATEDIFF(minute,started_at, ended_at))) AS duration_of_ride_member
  FROM [Cyclistic Project].[dbo].[trip_data]
  WHERE member_casual = 'member'
  GROUP BY day_of_week

 Select *
 FROM #member_riders_duration_daily

 ---- Join tables together for Data Visualisation

SELECT
#casual_riders_duration_daily.day_of_week,
#casual_riders_duration_daily.duration_of_ride_casual,
#member_riders_duration_daily.duration_of_ride_member
FROM #casual_riders_duration_daily
INNER JOIN #member_riders_duration_daily
	ON #casual_riders_duration_daily.day_of_week = #member_riders_duration_daily.day_of_week
ORDER BY day_of_week

-- Exploration for Number of Rides per Week 

---- Create Temp Table for Members
CREATE TABLE #member_riders_week
(days_of_week varchar(50),
num_of_rides_member INT
)

INSERT INTO #member_riders_week
SELECT
day_of_week,
COUNT(ride_id) AS num_of_rides_member
FROM [Cyclistic Project].[dbo].[trip_data]
WHERE member_casual = 'member'
GROUP BY day_of_week

SELECT * 
FROM #member_riders_week

---- Create Temp Table for Casual Users

CREATE TABLE #casual_riders_week
(days_of_week varchar(50),
num_of_rides_casual INT
)

INSERT INTO #casual_riders_week
SELECT
day_of_week,
COUNT(ride_id) AS num_of_rides_casual
FROM [Cyclistic Project].[dbo].[trip_data]
WHERE member_casual = 'casual'
GROUP BY day_of_week

SELECT * 
FROM #casual_riders_week

---- Join Casual and Member tables as per Day of week for Data Visualisation

SELECT
#casual_riders_week.days_of_week,
#casual_riders_week.num_of_rides_casual,
#member_riders_week.num_of_rides_member
FROM #casual_riders_week
INNER JOIN #member_riders_week
	ON #casual_riders_week.days_of_week = #member_riders_week.days_of_week
ORDER BY days_of_week

-- Exploration of Which Bike Type is Popular


---- Creating Temp Table for Member Users

CREATE TABLE #bike_type_member
(rideable_type varchar(50),
num_of_rides_member INT
)

INSERT INTO #bike_type_member
SELECT
rideable_type,
COUNT(ride_id) AS num_of_rides_member
FROM [Cyclistic Project].[dbo].[trip_data]
WHERE member_casual = 'member'
GROUP BY rideable_type

SELECT * 
FROM #bike_type_member

---- Creating Temp Table for Casual Users

CREATE TABLE #bike_type_casual
(rideable_type varchar(50),
num_of_rides_casual INT
)

INSERT INTO #bike_type_casual
SELECT
rideable_type,
COUNT(ride_id) AS num_of_rides_casual
FROM [Cyclistic Project].[dbo].[trip_data]
WHERE member_casual = 'casual'
GROUP BY rideable_type

SELECT * 
FROM #bike_type_casual

---- Join Casual and Members as per Day of week for Data Visualisation

SELECT
#bike_type_casual.rideable_type,
#bike_type_casual.num_of_rides_casual,
#bike_type_member.num_of_rides_member
FROM #bike_type_casual
FULL OUTER JOIN #bike_type_member
	ON #bike_type_casual.rideable_type = #bike_type_member.rideable_type
	
