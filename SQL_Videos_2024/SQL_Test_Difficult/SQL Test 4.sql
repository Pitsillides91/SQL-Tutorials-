--------------------------------------------------------------------------------------------------------
--------------------------     SQL TEST 4 - DIFFICULT INTERVIEW QUESTIONS     ---------------------------------------
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
	1. What is the average retail price for Make and Model for the Years 2023 and 2024, premium Trim  and horsepower > 400.
	2. Create a Rank column based on the Invoice Price per Model in the main table - Partitions
	3. Show the total retail Price, average used price, cylinders and Horsepower per model that has Highway FE <40mpg
	4. Create a new Category for the retail price using the following <50k, 50k-100k, >100k. Show the number of cars per Make and Category. Bonus for a Pivot table output
	5. Create another column on the main dataset that has the average used price per make for the Models/Index that have a NULL Used Price. Bonus tip: Use CTEs

How to Install SQL SSMS: https://youtu.be/Xr2xg_u-wzo?si=t7sivAjvahhDcaem
Full SQL Tutorial: https://youtu.be/Xr2xg_u-wzo?si=t7sivAjvahhDcaem 

*/

--Selecting the Database to use
USE [Car_Information]

-- 1. What is the average retail price for Make and Model for the Years 2023 and 2024, premium Trim  and horsepower > 400. Order desc
SELECT Make, Model,  AVG(Retail_Price) AS Avg_Retail_Price FROM [dbo].[yt_car_main]
WHERE Year in (2023, 2024) AND Trim LIKE ('%Premium%') 
AND [Index] IN (SELECT DISTINCT [Index] FROM [dbo].[yt_car_info] WHERE LEFT(Horsepower,3) > 400)
GROUP BY Make, Model
ORDER BY AVG(Retail_Price) DESC

-- 2. Create a Rank column based on the Invoice Price per Model in the main table
SELECT *, 
RANK() OVER (ORDER BY ISNULL(Invoice_Price,0) DESC) AS Invoice_Price_Rank 
FROM [dbo].[yt_car_main]

-- 3. Show the total retail Price, average used price, cylinders and Horsepower per model that has Highway FE <40mpg
SELECT a.Model,b.cylinders, b.Horsepower, 
SUM(a.Retail_Price) AS Sum_Retail_Price, AVG(c.Used_Price) AS Avg_Used_Price
FROM 
[dbo].[yt_car_main] a
LEFT JOIN 
[dbo].[yt_car_info] b
ON a.[Index] = b.[Index]
LEFT JOIN
[dbo].[yt_car_used_prices] c
ON a.[Index] = c.[Index]
WHERE LEFT(b.Highway_Fuel_Economy,2) < 40
GROUP BY a.Model,b.cylinders, b.Horsepower

-- 4. Create a new Category for the retail price using the following <50k, 50k-100k, >100k. 
-- Show the number of cars per Make and Category. Bonus for a Pivot table output

SELECT a.Make, a.retail_price_category, COUNT(DISTINCT a.[index]) AS No_of_cars
FROM
	(SELECT *, 
	CASE
		WHEN Retail_Price < 50000 THEN '<50k'
		WHEN Retail_Price >= 50000 AND Retail_Price < 100000 THEN '50k-100k'
		WHEN Retail_Price >= 100000 THEN '>100k'
	ELSE 'Other'
	END AS retail_price_category
	FROM [dbo].[yt_car_main]) a
GROUP BY a.Make, a.retail_price_category

-- PIVOT for Bonus
SELECT Make,  ISNULL([<50k],0) AS Less_50k, ISNULL([50k-100k], 0)  AS a_50k_to_100k, ISNULL([>100k], 0) AS More_100k
FROM
	(SELECT a.Make, a.retail_price_category, COUNT(DISTINCT a.[index]) AS No_of_cars
	FROM
		(SELECT *, 
		CASE
			WHEN Retail_Price < 50000 THEN '<50k'
			WHEN Retail_Price >= 50000 AND Retail_Price < 100000 THEN '50k-100k'
			WHEN Retail_Price >= 100000 THEN '>100k'
		ELSE 'Other'
		END AS retail_price_category
		FROM [dbo].[yt_car_main]) a
	GROUP BY a.Make, a.retail_price_category) a
PIVOT
(SUM(No_of_cars) FOR retail_price_category IN ([<50k], [50k-100k], [>100k])) AS pvt

-- 5. Create another column on the main dataset that has the average used price per make for the Models/Index that have a NULL Used Price.
-- Bonus tip: Use CTEs

SELECT TOP 10 * FROM [dbo].[yt_car_main]
SELECT TOP 10 * FROM [dbo].[yt_car_used_prices]

WITH 
	-- Creating the averages
	AvgPrices AS 
	(SELECT DISTINCT a.Make, AVG(b.Used_Price) AS Avg_Used_Price
    FROM [dbo].[yt_car_main] a
    LEFT JOIN [dbo].[yt_car_used_prices] b ON a.[Index] = b.[Index]
    GROUP BY a.Make),

	-- Identifying the Indexes we need to update
	MissingUsedPrices AS 
	(SELECT a.[Index], a.Make, b.Used_Price
    FROM [dbo].[yt_car_main] a
    LEFT JOIN [dbo].[yt_car_used_prices] b ON a.[Index] = b.[Index]
    WHERE b.Used_Price IS NULL),

	-- Create a table with the updated used prices
	Updated_prices AS
	(SELECT m.[Index], m.Make, a.Avg_Used_Price AS Updated_Used_Price
	FROM MissingUsedPrices m
	LEFT JOIN AvgPrices a ON m.Make = a.Make)

-- Combining all together
SELECT a.*, c.Used_Price, b.Updated_Used_Price, ISNULL(c.Used_Price, b.Updated_Used_Price) AS Combined_Used_Price 
FROM [dbo].[yt_car_main] a
LEFT JOIN Updated_prices b
ON a.[Index] = b.[Index]
LEFT JOIN [dbo].[yt_car_used_prices] c
ON a.[Index] = c.[Index]



---------------------------------------       YOUTUBE VIDEO - DIFFICULT      --------------------------

SELECT TOP 10 * FROM [dbo].[yt_car_main]
SELECT TOP 10 * FROM [dbo].[yt_car_used_prices]
SELECT TOP 10 * FROM [dbo].[yt_car_info]

-- 1. What is the average retail price for Make and Model for the Years 2023 and 2024, premium Trim  and horsepower > 400. Order desc


-- 2. Create a Rank column based on the Invoice Price per Model in the main table


-- 3. Show the total retail Price, average used price, cylinders and Horsepower per model that has Highway FE <40mpg


-- 4. Create a new Category for the retail price using the following <50k, 50k-100k, >100k. 
-- Show the number of cars per Make and Category. Bonus for a Pivot table output


-- 5. Create another column on the main dataset that has the average used price per make for the Models/Index that have a NULL Used Price.
-- Bonus tip: Use CTEs

