--------------------------------------------------------------------------------------------------------
--------------------------     SQL TEST 1 - BEGINNER INTERVIEW QUESTIONS     ---------------------------------------
--------------------------------------------------------------------------------------------------------

/*
Created by: Yiannis Pitsillides

Dataset Information: We have 2 tables:
- [dbo].[yt_car_main]: This table has information about cars and their retail price
- [dbo].[yt_car_info]: Has additional information abour the cars

-- Explaining our data
SELECT TOP 10 * FROM [dbo].[yt_car_main]
SELECT TOP 10 * FROM [dbo].[yt_car_info]

Complete the following Questions in 20 mins:
	1. Show all the Index, Makes, Models and retail price. Order by retail price desc
	2. Show all the Audi Models for 2024
	3. Show the total Retail_Price for Mercedes Cars per Model. Order by retail price desc
	4. Show the total Retail_Price, average/min/max Invoice Price by Make & Body size where the Body style is "SUV"
	5. Show the average retail price per make and Model for all Ford FWD cars
	6. Show all the cars that have a retail_price between 30-60k, are compact SUVs and have 4 Cylinders

How to Install SQL SSMS: https://youtu.be/Xr2xg_u-wzo?si=t7sivAjvahhDcaem
Full SQL Tutorial: https://youtu.be/Xr2xg_u-wzo?si=t7sivAjvahhDcaem 

*/

--Selecting the Database to use
USE [Car_Information]

-- 1. Show all the Makes, Models and retail price. Order by retail price desc
SELECT [Index], Make, Model, Retail_Price FROM [dbo].[yt_car_main]
ORDER BY Retail_Price Desc

-- 2. Show all the Audi Models for 2024
SELECT * FROM [dbo].[yt_car_main]
WHERE Make = 'Audi' AND Year = 2024

-- 3. Show the total Retail_Price for Mercedes Cars per Model. Order by retail price desc
SELECT Model, SUM(Retail_Price) AS Retail_Price FROM [dbo].[yt_car_main]
WHERE Make = 'Mercedes-Benz' 
GROUP BY Model
ORDER BY Retail_Price Desc

-- 4. Show the total Retail_Price, average/min/max Invoice Price by Make & Body size where the Body style is "SUV". 
-- Order by average Invoice Price
SELECT Make, Body_Size, SUM(Retail_Price) AS Total_Retail_Price, AVG(Invoice_Price) AS AVG_Invoice_Price,
MIN(Invoice_Price) AS Min_Invoice_Price, MAX(Invoice_Price) AS Max_Invoice_Price
FROM [dbo].[yt_car_main]
WHERE Body_Style = 'SUV' 
GROUP BY Make, Body_Size
ORDER BY AVG(Invoice_Price) Desc

-- 5. Show the average retail price per make and Model for all Ford FWD cars
SELECT Make, Model, AVG(Retail_Price) AS Avg_Retail_Price FROM [dbo].[yt_car_main]
WHERE Make = 'Ford' AND [Index] IN (SELECT DISTINCT [Index] FROM [dbo].[yt_car_info] WHERE Drivetrain = 'FWD')
GROUP BY Make, Model
ORDER BY AVG(Retail_Price) Desc

-- 6. Show all the cars that have a retail_price between 30-60k, are compact SUVs and have 4 Cylinders
SELECT * FROM [dbo].[yt_car_main]
WHERE Retail_Price BETWEEN 30000 AND 60000 
AND Body_Size = 'Compact' 
AND Body_Style = 'SUV' 
AND [Index] IN (SELECT DISTINCT [Index] FROM [dbo].[yt_car_info] WHERE Cylinders = 'I4')

-- Another way
SELECT a.*, b.Cylinders FROM 
[dbo].[yt_car_main] a
LEFT JOIN
[dbo].[yt_car_info] b
ON a.[Index] = b.[Index]
WHERE a.Retail_Price BETWEEN 30000 AND 60000 
AND a.Body_Size = 'Compact' 
AND a.Body_Style = 'SUV' 
AND b.Cylinders = 'I4'



---------------------------------------       YOUTUBE VIDEO - EASY        --------------------------

--Selecting the Database to use
USE [Car_Information]

SELECT TOP 10 * FROM [dbo].[yt_car_main]
SELECT TOP 10 * FROM [dbo].[yt_car_info]


-- 1. Show all the Makes, Models and retail price. Order by retail price desc

-- 2. Show all the Audi Models for 2024

-- 3. Show the total Retail_Price for Mercedes Cars per Model. Order by retail price desc

-- 4. Show the total Retail_Price, average/min/max Invoice Price by Make & Body size where the Body style is "SUV". 
-- Order by average Invoice Price

-- 5. Show the average retail price per make and Model for all Ford FWD cars (Drivetrain)

-- 6. Show all the cars that have a retail_price between 30-60k, are compact SUVs and have 4 Cylinders
