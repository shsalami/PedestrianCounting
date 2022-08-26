-----------------------------------------------------------------
-- Create Staging Area:
-----------------------------------------------------------------

CREATE TABLE [dbo].[SensorLocations](
	[sensor_id] [tinyint],
	[sensor_description] [varchar](80),
	[sensor_name] [varchar](15),
	[installation_date] [date],
	[status] [char](1),
	[note] [varchar](100),
	[direction_1] [char](5),
	[direction_2] [char](5),
	[latitude] [float],
	[longitude] [float],
	[location] [char](28) )


CREATE TABLE [dbo].[MonthlyCountsPerHour](
	[ID] [int],
	[Date_Time] [datetime],
	[Year] [smallint],
	[Month] [varchar](10),
	[Mdate] [smallint],
	[Day] [char](10),
	[Time] [tinyint],
	[Sensor_ID] [tinyint],
	[Sensor_Name] [varchar](80),
	[Hourly_Counts] [smallint]
)

-----------------------------------------------------------------
-- Create Foundation Facts and Dimensions:
-----------------------------------------------------------------
Create table Dim_Sensor (
	Sensor_Key int,
	Sensor_Id  tinyint,
	Sensor_Name varchar(15),
	Sensor_Desc varchar(80),
	Install_Date_Key int,
	Sensor_Status_Code char(1),
	Sensor_Status_Name varchar(10),
	Direction1_Code char(1),
	Direction1_Name char(5),
	Direction2_Code char(1),
	Direction2_Name char(5),
	Latitude float,
	Longtitude float,
	Location point
)

Create table Dim_Date (
	Date_Key int,
	Date_Id int,
	Date_Val date,
	Year_No smallint,
	Month_No tinyint,
	Year_Day_No smallint,
	Week_Day_No tinyint,
	Week_Day_Name varchar(10)
)

Create table Dim_Hour (
	Hour_Key tinyint,
	Hour12_No tinyint,
	AM_PM_Code tinyint
)

Create table Dim_Month (
	Month_Key tinyint,
	Month_Name varchar(10)
)

Create table Dim_Year (
	Year_Key smallint,
      Year_Name varchar(20)
)

Create table Fact_Hourly_Sensor_Read (
	Hourly_Sensor_Read_Id int,
	Sensor_Key int,
	Read_Date_Key int,
	Read_Hour_Key tinyint,
	Read_Cnt int
)

-----------------------------------------------------------------
-- Create Aggregated Facts:
-----------------------------------------------------------------

Create View Fact_Daily_Sensor_Read  As
Select Sensor_Key, Read_Date_Key, sum(Read_Cnt) Read_Cnt
 from Fact_Hourly_Sensor_Read 
 group by Sensor_Key, Read_Date_Key;

Create View Fact_Monthly_Sensor_Read  As
Select Sensor_Key, Year_No, Month_No, sum(Read_Cnt) Read_Cnt
 from Fact_Hourly_Sensor_Read f
           join Dim_Date d on (f.Read_Date_Key = d.Date_Key)
 group by Sensor_Key, Year_No, Month_No;

Create View Fact_Yearly_Sensor_Read  As
Select Sensor_Key, Year_No, sum(Read_Cnt) Read_Cnt
 from Fact_Hourly_Sensor_Read f
           join Dim_Date d on (f.Read_Date_Key = d.Date_Key)
 group by Sensor_Key, Year_No;

