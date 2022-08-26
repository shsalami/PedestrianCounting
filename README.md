# PedestrianCounting
Using the data warehouse approach, this project presents a solution for the analysis of the pedestrian traffics read by the sensors of the Melbourne city.
 - The data warehouse is designed using Star Schema method.
- Tables with the same structure as the input files are used for data staging (named as SensorLocations and MonthlyCountsPerHour).
- Data profiling of input files is done on stage tables and the result is saved in Excel file DataProfiling.xlsx.
- The data warehouse diagram is shown in the file ERD.pdf.
- The definition of the data items of the data warehouse is shown in the file Metadata.pdf.
- The creation of stage tables and the data warehouse are shown in the file CreateSchema.sql.
- Due to the small amount of data, daily, monthly, and yearly aggregated facts have been created as views.
- The queries related to the four requested questions are included in the file DWQuery.sql and the corresponding results are shown in the corresponding sheets of the Excel file DWQueryResult.xlsx.
- Other metrics suggested for data warehouses such as minimum, maximum, and average traffic at different hours of a day or different months of a year.
