--------------------------------------------------------------------------------------------------------
--------------------------     SQL TEST 3 - INTERMEDIATE INTERVIEW QUESTIONS     ---------------------------------------
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
	1. What is the average retail_price per model for 2023. Order desc
	2. What is the total retail_price per make and Cylinders for AWD cars. Order desc by 
	3. Show the average Used Prices per Model and year for cars that have 500+ horsepower
	4. Show the top 10 models and make in terms of highway fuel economy that have a retail price less than 50k
	5. Show all the cars that do not have Used prices data
	6. Show all the data that exists in car info but does not have a retail price

How to Install SQL SSMS: https://youtu.be/Xr2xg_u-wzo?si=t7sivAjvahhDcaem
Full SQL Tutorial: https://youtu.be/Xr2xg_u-wzo?si=t7sivAjvahhDcaem 

*/

--Selecting the Database to use
USE [Car_Information]

-- 1. What is the average retail_price per model for 2023. Order desc
SELECT Model,  AVG(Retail_Price) AS Avg_Retail_Price FROM [dbo].[yt_car_main]
WHERE Year = 2023
GROUP BY Model
ORDER BY AVG(Retail_Price) DESC

-- 2. What is the total retail_price per make and Cylinders for AWD cars. Order desc 
SELECT a.Make, b.Cylinders, SUM(a.Retail_Price) AS Total_Retail_Price 
FROM [dbo].[yt_car_main] a
LEFT JOIN 
[dbo].[yt_car_info] b
ON a.[Index] = b.[Index]
WHERE b.Drivetrain = 'AWD'
AND b.Cylinders IS NOT NULL
GROUP BY a.Make, b.Cylinders
ORDER BY SUM(Retail_Price) DESC

-- 3. Show the average Used Prices per Model and year for cars that have 500+ horsepower. We do not want NULL values
SELECT a.Model, a.Year, c.Horsepower_No, AVG(b.Used_Price) AS Avg_Used_Price
FROM [dbo].[yt_car_main] a
LEFT JOIN 
[dbo].[yt_car_used_prices] b
ON a.[Index] = b.[Index]
INNER JOIN
(SELECT DISTINCT [Index], LEFT(Horsepower,3) AS Horsepower_No FROM [dbo].[yt_car_info] WHERE LEFT(Horsepower,3) > 500) c
ON a.[Index] = c.[Index]
WHERE b.Used_Price IS NOT NULL
GROUP BY a.Model, a.Year, c.Horsepower_No

-- 4. Show the top 10 models and make in terms of highway fuel economy that have a retail price less than 70k. 
-- We do not want NULL values
SELECT DISTINCT TOP 10  Make, Model, LEFT(b.Highway_fuel_economy,2) AS Highway_fuel_economy
FROM [dbo].[yt_car_main] a
LEFT JOIN 
[dbo].[yt_car_info] b
ON a.[Index] = b.[Index]
WHERE b.Highway_fuel_economy IS NOT NULL 
AND Retail_Price < 70000
ORDER BY LEFT(b.Highway_fuel_economy,2) ASC

-- 5. Show all the cars that do not have Used prices data
SELECT * FROM [dbo].[yt_car_main]
WHERE [Index] NOT IN (SELECT DISTINCT [Index] FROM [dbo].[yt_car_used_prices])

SELECT * FROM [dbo].[yt_car_used_prices] WHERE Used_Price IS NULL

-- 6. Show all the data that exists in car info but does not have a retail price
SELECT * FROM [dbo].[yt_car_info]
WHERE [Index] NOT IN (SELECT DISTINCT [Index] FROM [dbo].[yt_car_main] WHERE Retail_Price IS NOT NULL)



---------------------------------------       YOUTUBE VIDEO - INTERMEDIATE      --------------------------

SELECT TOP 10 * FROM [dbo].[yt_car_main]
SELECT TOP 10 * FROM [dbo].[yt_car_used_prices]
SELECT TOP 10 * FROM [dbo].[yt_car_info]

-- 1. What is the average retail_price per model for 2023. Order desc


-- 2. What is the total retail_price per make and Cylinders for AWD cars. Order desc 


-- 3. Show the average Used Prices per Model and year for cars that have 500+ horsepower. We do not want NULL values


-- 4. Show the top 10 models and make in terms of highway fuel economy that have a retail price less than 70k. 
-- We do not want NULL values


-- 5. Show all the cars that do not have Used prices data


-- 6. Show all the data that exists in car info but does not have a retail price
