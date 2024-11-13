--------------------------------------------------------------------------------------------------------
--------------------------     SQL TEST 2 - EASY INTERVIEW QUESTIONS     ---------------------------------------
--------------------------------------------------------------------------------------------------------

/*
Created by: Yiannis Pitsillides

Dataset Information: We have 3 tables:
- [dbo].[yt_car_main]: This table has information about cars and their retail price
- [dbo].[yt_car_used_prices]: This  table has the Used prices of the cars
- [dbo].[yt_car_info]: Has additional information abour the cars

-- Explaining our data
SELECT TOP 10 * FROM [dbo].[yt_car_main]
SELECT TOP 10 * FROM [dbo].[yt_car_used_prices]
SELECT TOP 10 * FROM [dbo].[yt_car_info]

Complete the following Questions in 20 mins:
	1. What is the total retail_price per make
	2. Which model has the highest Invoice Price combined for  2023 and 2024
	3. Show the average retail_price price per make for all FWD cars (Transmission)
	4. Show the min and max Used prices per make where the  year is 2024 
	5. Show  the Model with the lowest Highway_fuel_economy
	6. Create a new column that has tthe retail price category of the car with the following: <50k, 50k-100k, >100k

How to Install SQL SSMS: https://youtu.be/Xr2xg_u-wzo?si=t7sivAjvahhDcaem
Full SQL Tutorial: https://youtu.be/Xr2xg_u-wzo?si=t7sivAjvahhDcaem 

*/

--Selecting the Database to use
USE [Car_Information]

-- 1. What is the total retail_price per make
SELECT Make, SUM(Retail_Price) AS Retail_Price FROM [dbo].[yt_car_main]
GROUP BY Make
ORDER BY SUM(Retail_Price) Desc

-- 2. Which model has the highest Invoice Price combined for  2023 and 2024
SELECT Model, SUM(Invoice_Price) AS Invoice_Price FROM [dbo].[yt_car_main]
WHERE Year IN (2023, 2024)
GROUP BY Model
ORDER BY SUM(Invoice_Price) Desc

-- 3. Show the average retail_price price per make for all FWD cars (Drivetrain)
SELECT Make, AVG(Retail_Price) AS Avg_Retail_Price FROM [dbo].[yt_car_main]
WHERE [Index] IN (SELECT DISTINCT [Index] FROM [dbo].[yt_car_info] WHERE Drivetrain = 'FWD')
GROUP BY Make
ORDER BY AVG(Retail_Price) Desc

-- 4. Show the min and max Used prices per make where the  year is 2024 
SELECT a.Make, MIN(b.Used_Price) AS Min_Used_Price, MAX(b.Used_Price) AS Max_Used_Price
FROM [dbo].[yt_car_main] a
LEFT JOIN 
[dbo].[yt_car_used_prices] b
ON a.[Index] = b.[Index]
WHERE a.Year = 2024
GROUP BY a.Make

SELECT * FROM [dbo].[yt_car_used_prices] WHERE [Index] IN 
(SELECT DISTINCT [Index] FROM [dbo].[yt_car_main] WHERE make IN ('Mercedes-Benz','Nissan'))

-- 5. Show the Model with the lowest Highway_fuel_economy
SELECT a.Model, MIN(LEFT(b.Highway_fuel_economy,2)) AS HFE_No 
FROM 
[dbo].[yt_car_main] a 
LEFT JOIN
[dbo].[yt_car_info] b
ON a.[Index] = b.[Index]
WHERE b.Highway_fuel_economy IS NOT NULL
GROUP BY a.Model
ORDER BY MIN(LEFT(b.Highway_fuel_economy,2)) ASC

-- 6. Create a new column that has the retail price category of the car with the following: <50k, 50k-100k, >100k
SELECT *, 
CASE
	WHEN Retail_Price < 50000 THEN '<50k'
	WHEN Retail_Price >= 50000 AND Retail_Price < 100000 THEN '50k-100k'
	WHEN Retail_Price >= 100000 THEN '>100k'
ELSE 'Other'
END AS retail_price_category
FROM [dbo].[yt_car_main]


---------------------------------------       YOUTUBE VIDEO - EASY        --------------------------

SELECT TOP 10 * FROM [dbo].[yt_car_main]
SELECT TOP 10 * FROM [dbo].[yt_car_used_prices]
SELECT TOP 10 * FROM [dbo].[yt_car_info]

-- 1. What is the total retail_price per make


-- 2. Which model has the highest Invoice Price combined for  2023 and 2024


-- 3. Show the average retail_price price per make for all FWD cars (Drivetrain)


-- 4. Show the min and max Used prices per make where the  year is 2024 


-- 5. Show the Model with the lowest Highway_fuel_economy


-- 6. Create a new column that has the retail price category of the car with the following: <50k, 50k-100k, >100k
