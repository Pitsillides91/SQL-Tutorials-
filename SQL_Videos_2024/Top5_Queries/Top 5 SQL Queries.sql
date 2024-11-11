--------------------------------------------------------------------------------------------------------
--------------------------     TOP 5 SQL INTERVIEW QUESTIONS     ---------------------------------------
--------------------------------------------------------------------------------------------------------
/*
Created by: Yiannis Pitsillides

Agenda:
	1. AGGREGATIONS
	2. CONDITIONS / FILTERS
	3. SUB QUERIES - NESTED QUERIES
	4. JOINS/UNIONs
	5. CASE / IFF STATEMENTS 

*/
---------------------------------       0. General Info         ------------------------------

--Selecting the Database to use
USE [Car_Information]

-- Explaining our data
SELECT TOP 10 * FROM [dbo].[yt_car_main]
SELECT TOP 10 * FROM [dbo].[yt_car_used_prices]
SELECT TOP 10 * FROM [dbo].[yt_car_info]



---------------------------------       1.AGGREGATIONS         ------------------------------

-- 1.1.Question: What is the Total/Average/Count/Min/Max Retail Price?

-- 1.1. SUM
SELECT SUM(Retail_Price) AS Total_Retail_Price FROM [dbo].[yt_car_main]

-- 1.2. AVG
SELECT AVG(Retail_Price) AS Avg_Retail_Price FROM [dbo].[yt_car_main]

-- 1.3. COUNT
SELECT COUNT(Retail_Price) AS Count_Retail_Price FROM [dbo].[yt_car_main]

-- 1.4. MIN
SELECT MIN(Retail_Price) AS Min_Retail_Price FROM [dbo].[yt_car_main]

-- 1.5. MAX
SELECT MAX(Retail_Price) AS Max_Retail_Price FROM [dbo].[yt_car_main]

-- 1.2.Question: What is the Total/Average/Count/Min/Max Retail Price  by Make?
SELECT Make,  SUM(Retail_Price) AS Total_Retail_Price 
FROM [dbo].[yt_car_main]
GROUP BY Make

SELECT Make,  SUM(Retail_Price) AS Total_Retail_Price, AVG(Retail_Price) AS Avg_Retail_Price, MIN(Retail_Price) AS Min_Retail_Price
FROM [dbo].[yt_car_main]
GROUP BY Make

--------------------------------   2. CONDITIONS / FILTERS    ------------------------------
-- 2.1. =, !=, IN, NOT IN
SELECT * FROM [dbo].[yt_car_main] 
WHERE Make = 'Audi'

SELECT * FROM [dbo].[yt_car_main] 
WHERE Model != 'A3'

SELECT * FROM [dbo].[yt_car_main] 
WHERE Year IN (2023,2024)

SELECT * FROM [dbo].[yt_car_main] 
WHERE Body_Size NOT IN ('Midsize', 'Large')

-- 2.2. <, >, AND, OR,  Like
SELECT * FROM [dbo].[yt_car_main] 
WHERE Retail_Price < 30000

SELECT * FROM [dbo].[yt_car_main] 
WHERE Retail_Price > 100000 AND Make = 'Mercedes-Benz'

SELECT * FROM [dbo].[yt_car_main] 
WHERE Retail_Price > 100000 OR Body_Style = 'Coupe'
ORDER BY Retail_Price 

SELECT * FROM [dbo].[yt_car_main] 
WHERE Make LIKE '%Mercedes%'


-------------------------------   3.SUB QUERIES - NESTED QUERIES   ----------------------------

SELECT TOP 10 * FROM [dbo].[yt_car_main]
SELECT TOP 10 * FROM [dbo].[yt_car_info]

-- Question: Total Retail_Price for FWD cars
SELECT SUM(Retail_Price) AS FWD_Retail_Price 
FROM [dbo].[yt_car_main] 
WHERE [index] IN (SELECT DISTINCT [index] FROM [dbo].[yt_car_info] WHERE Drivetrain = 'FWD')

-- Question: Total Retail_Price for FWD cars per Make
SELECT Make, SUM(Retail_Price) AS FWD_Retail_Price 
FROM [dbo].[yt_car_main] 
WHERE [index] IN (SELECT DISTINCT [index] FROM [dbo].[yt_car_info] WHERE Drivetrain = 'FWD')
GROUP BY Make

---------------------------------      4.JOINS/UNIONs           ------------------------------

-- deepdive: https://www.youtube.com/watch?v=V4aMAU9VLNo

SELECT TOP 10 * FROM [dbo].[yt_car_main]
SELECT TOP 10 * FROM [dbo].[yt_car_info]

-- 4.1. LEFT JOIN - Most used - Selects all the data from Table A

-- Question: Join the Cylinders and Torgue on the main dataset

SELECT a.*,
b.Cylinders, b.Torque
FROM 
[dbo].[yt_car_main] a
LEFT JOIN 
[dbo].[yt_car_info] b
ON a.[index] = b.[index] 

-- Same query
SELECT a.*,
b.Cylinders, b.Torque
FROM 
(SELECT * FROM [dbo].[yt_car_main]) a
LEFT JOIN 
(SELECT * FROM [dbo].[yt_car_info]) b
ON a.[index] = b.[index] 

-- Question: Join the Cylinders and Torgue on the main dataset WHERE make = Audi
SELECT a.*,
b.Cylinders, b.Torque
FROM 
(SELECT * FROM [dbo].[yt_car_main] WHERE make = 'Audi') a
LEFT JOIN 
(SELECT * FROM [dbo].[yt_car_info]) b
--WHERE A.make = 'Audi'
ON a.[index] = b.[index] 

-- Question: Show the total Retail_Price Per Make and Transmission for AWD cars

SELECT a.Make,
b.Transmission, 
SUM(Retail_Price) AS Retail_Price
FROM 
(SELECT * FROM [dbo].[yt_car_main]) a
LEFT JOIN 
(SELECT * FROM [dbo].[yt_car_info] WHERE Drivetrain = 'AWD') b
ON a.[index] = b.[index] 
-- WHERE b.Transmission IS NOT NULL
GROUP BY a.Make,b.Transmission

-- 4.2. FULL JOIN - Selects all the data from Both Tables
-- deepdive: https://www.youtube.com/watch?v=V4aMAU9VLNo

-- 4.3. INNER JOIN
-- deepdive: https://www.youtube.com/watch?v=V4aMAU9VLNo

-- 4.4. CROSS JOIN
-- deepdive: https://www.youtube.com/watch?v=V4aMAU9VLNo

-- 4.5. UNION
-- deepdive: https://www.youtube.com/watch?v=V4aMAU9VLNo


--------------------------------    5. CASE / IFF STATEMENTS    ------------------------------

-- 5.1.Question: Create a new column that has a 'Yes/No' if the car is more than  100k
SELECT *,  IIF( Retail_Price>100000, 'Yes', 'No') AS Car_more_100k
FROM [dbo].[yt_car_main]

-- 5.2.Question: Create a new Category column with cars <30k, 30-50, 50-70, 70-90,90k+
SELECT *,
CASE
	WHEN Retail_Price < 30000 THEN 'Retail_Price < 30k'
	WHEN Retail_Price >= 30000 AND Retail_Price < 50000 THEN '30k TO 50k'
	WHEN Retail_Price >= 50000 AND Retail_Price < 70000 THEN '50k TO 70k'
	WHEN Retail_Price >= 70000 AND Retail_Price < 90000 THEN '70k TO 90k'
	WHEN Retail_Price >= 90000 THEN 'Retail_Price > 90k'
END AS 'Retail_Price Categories'
FROM [dbo].[yt_car_main]

-- Full Tutorial: https://youtu.be/Xr2xg_u-wzo?si=t7sivAjvahhDcaem