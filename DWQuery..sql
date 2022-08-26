-- EX_01: Top 10 (most pedestrians) locations by day

With Sensor_Rank as
(
  SELECT Sensor_Key, ReadDateKey,
         ROW_NUMBER() over (partition by ReadDateKey order by ReadCnt Desc) rank,   
         ReadCnt
    FROM Fact_Daily_Sensor_Read
)
, x as
(
  SELECT ReadDateKey, rank, Sensor_Name
    FROM Sensor_Rank f
         Join Dim_Sensor d on (f.Sensor_Key = d.Sensor_Key)
   WHERE rank < 11
)
SELECT ReadDateKey, [1] AS R1, [2] AS R2, [3] AS R3,[4] AS R4, [5] AS R5, [6] AS R6, [7] AS R7, [8] AS R8, [9] AS R9, [10] AS R10
FROM (
   SELECT ReadDateKey, rank, Sensor_Name
    FROM x) as m
PIVOT 
(  
  max(Sensor_Name)
  FOR rank IN ( [1], [2],[3], [4], [5], [6], [7] , [8] , [9] , [10])  
) AS pvt  


-- EX_02: Top 10 (most pedestrians) locations by month

With Sensor_Rank as
(
  SELECT ROW_NUMBER() over (partition by Year_Key, Month_Key order by ReadCnt Desc) rank,  
         Sensor_Name, Year_Key, Month_Key, ReadCnt
    FROM Fact_Monthly_Sensor_Read
)
, x as
(
  SELECT Year_Key, Month_Key, rank, Sensor_Name
    FROM Sensor_Rank s
         Join Dim_Sensor d on (s.Sensor_Key = d.Sensor_Key) 
   WHERE rank < 11
)
SELECT Year_Key, Month_Key, [1] AS R1, [2] AS R2, [3] AS R3,[4] AS R4, [5] AS R5, [6] AS R6, [7] AS R7, [8] AS R8, [9] AS R9, [10] AS R10
FROM (
  SELECT Year_Key, Month_Key, rank, Sensor_Name
    FROM x) as m
PIVOT 
(  
max(Sensor_Name)
FOR rank IN  
( [1], [2],[3], [4], [5], [6], [7] , [8] , [9] , [10])  
) AS pvt  


-- EX_03: Which location has shown most decline due to lockdowns in last 2 years

With Lockdown_Read as
(
  select Sensor_Key, avg(pedestrianCnt) Read_Avg, Year_Key
    From Fact_Yearly_Sensor_Read
   Where Year_Key in (2020, 2021)
   Group by Sensor_Key, Year_Key
)
Select top 1 d.Sensor_Id, d.Sensor_Name, ReadCnt, f.Read_Avg twoRecentlyYearAvg, m.ReadCnt - f.Read_Avg Lockdown_Count
From  Lockdown_Read f
      Join Dim_Sensor d on (f.Sensor_Key = d.Sensor_Key)
      Join Fact_Yearly_Sensor_Read m on (f.Sensor_key = m.Sensor_key)
Where m.Year_Key = 2019
Order by (m.pedestrianCnt - f.Read_Avg) desc


-- EX_04: Which location has most growth in last year

Select top 1 f.Sensor_ID, f.Sensor_Name, m.pedestrianCnt nowCnt, f.pedestrianCnt lastCnt, 
       m.pedestrianCnt - f.pedestrianCnt Groth_Count
  From Fact_Yearly_Sensor_Read f
JOIN  Yearly_Sensor_Read m on (f.Sensor_ID = m.Sensor_ID)
Where m.Year = 2021 and f.Year = 2020
Order by (m.pedestrianCnt - f.pedestrianCnt) desc

