-------------------------------------------------------------------------------------------------------------------
--------------------------------               SQL TUTORIAL FOR DATA ANALYST/SCIENTIST            ------------------
-------------------------------------------------------------------------------------------------------------------

-- Created by: Yiannis Pitsillides

---------------------------------------------  Video 1  ----------------------------------------------
-- Step 0: Download and instal SQL Server and SSMS. Create a new database
-- Step 1: Load the raw data
-- Step 2: SELECT query - Filtering - Conditions
-- Step 3: WHERE CLAUSE with SubQueries

---------------------------------------------  Video 2  ----------------------------------------------
-- Step 4: IFF & CASE Statement
-- Step 5: Rename - Update - Replace - Insert Into - Delete from tables - New Column
-- Step 6: Aggregated Funtions: SUM - AVERAGE - MIN - MAX - COUNT


---------------------------------------------  Video 3  ----------------------------------------------
-- Step 7: JOINS & UNIONS



--------------------------------------
---- Shortcut Keys to know------------
--------------------------------------

-- CTRL + C = Copy
-- CTRL + X = Cut
-- CTRL + V = Paste
-- CTRL + Z = Undo / back
-- F5 in SQL = Run


-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- Data Types - ---------------------------------------------------
-------------------------------------------------------------------------------------------------------------------


-- VARCHAR(25) - Is for characters - you cannot apply aggregated functions on this
-- NVARCHAR (25)  - Is for characters - you cannot apply aggregated functions on this
-- FLOAT - Is for Number values with decimal; so you can aggregate the data - SUM/AVG/MIN/MAX
-- Int is for Number swith no decimal places
-- Date is for dates




-------------------------------------------------------------------------------------------------------------------
--------------------------------------      Step 1: Load the raw data       --------------------------------------
-------------------------------------------------------------------------------------------------------------------


-- 1: Create the table

IF OBJECT_ID('Football_Data_2020') IS NOT NULL DROP TABLE Football_Data_2020

CREATE TABLE Football_Data_2020
([Date] NVARCHAR(200),
Home_Team NVARCHAR(200),
Away_Team NVARCHAR(200),
Home_Score INT,
Away_Score INT,
Tournament NVARCHAR(200),
City NVARCHAR(200),
Country NVARCHAR(200),
Neutral NVARCHAR(200)
)

--SELECT * FROM Football_Data_2020

-- 2: Import the Data

BULK INSERT Football_Data_2020
FROM 'G:\My Drive\Youtube Videos\6. SQL Tutorial\results 1872-2020.csv'
WITH ( FORMAT='CSV');

--SELECT * FROM Football_Data_2020


-------------------------------------------------------------------------------------------------------------------
-----------------------             Step 2: SELECT query - Filtering - Conditions           -----------------------
-------------------------------------------------------------------------------------------------------------------

-- * means all
SELECT * FROM Football_Data_2020
SELECT [Date], Home_Team, Away_Team, Home_Score, Away_Score, Tournament, City, Country, Neutral FROM Football_Data_2020

-- Exm 1: 1 Condition with = 
SELECT * FROM Football_Data_2020 WHERE Home_Team = 'England'

-- Exm 2: 1 Condition with <>
SELECT * FROM Football_Data_2020 WHERE Tournament <> 'Friendly'

-- Exm 3: Distinct Tournaments
SELECT DISTINCT Tournament FROM Football_Data_2020

-- Exm 4: 1 Condition - IN
SELECT * FROM Football_Data_2020 WHERE COUNTRY IN ('Scotland','England','Wales')

-- Exm 5: 1 Condition - NOT IN
SELECT * FROM Football_Data_2020 WHERE COUNTRY IN ('Scotland','England','Wales')

-- Exm 6: 1 Condition - LIKE
SELECT * FROM Football_Data_2020 WHERE Tournament LIKE '%UEFA%' -- in-between
SELECT * FROM Football_Data_2020 WHERE Tournament LIKE '%UEFA' -- ending with
SELECT * FROM Football_Data_2020 WHERE Tournament LIKE 'UEFA%' -- starting with

-- Exm 7: 1 Condition - NOT LIKE
SELECT * FROM Football_Data_2020 WHERE Tournament NOT LIKE '%UEFA%' -- in-between

-- Exm 8: 1 Condition - >
SELECT * FROM Football_Data_2020 WHERE Home_Score > 10

-- Exm 9: 1 Condition - <
SELECT * FROM Football_Data_2020 WHERE Home_Score < 10

-- Exm 10: 1 Condition - BETWEEN
SELECT * FROM Football_Data_2020 WHERE Home_Score BETWEEN 20 AND 30

-- Exm 11: 2 Conditions - AND
SELECT * FROM Football_Data_2020 WHERE Home_Score > 10 AND Tournament <> 'Friendly'

-- Exm 12: 2 Conditions - OR
SELECT * FROM Football_Data_2020 WHERE Home_Score > 10 OR Away_Score > 10

-- Exm 13: 2 Conditions - AND and OR together
SELECT * FROM Football_Data_2020 WHERE (Home_Score > 10 OR Away_Score > 10) AND Tournament <> 'Friendly'



-------------------------------------------------------------------------------------------------------------------
-----------------------                        Step 3: SUB-QUERIES                          -----------------------
-------------------------------------------------------------------------------------------------------------------

-- 1: Load new raw data
-- Create the table

IF OBJECT_ID('Countries_Data') IS NOT NULL DROP TABLE Countries_Data

CREATE TABLE Countries_Data
(Country NVARCHAR(200),
Region NVARCHAR(200),
[Population] INT,
Area_sq_mi FLOAT,
Pop_Density_per_sq_mi FLOAT,
Coastline_coast_area_ratio FLOAT,
Net_migration FLOAT,
Infant_mortality_per_1000_births FLOAT,
GDP_$_per_capita INT,
Literacy_Perc FLOAT,
Phones_per_1000 FLOAT,
Arable_Perc FLOAT,
Crops_Perc FLOAT,
Other_Perc FLOAT,
Climate FLOAT,
Birthrate FLOAT,
Deathrate FLOAT,
Agriculture FLOAT,
Industry FLOAT,
[Service] FLOAT
)

--SELECT * FROM Countries_Data

-- 2: Import the Data

BULK INSERT Countries_Data
FROM 'G:\My Drive\Youtube Videos\6. SQL Tutorial\countries of the world.csv'
WITH ( FORMAT='CSV');

-- SELECT * FROM Countries_Data

-------------------------------------------------------------------------------------------------------------------

-- Exm 1: Subquery from another table - European Countries
SELECT * FROM Football_Data_2020 WHERE Country IN (SELECT DISTINCT Country FROM Countries_Data WHERE Region LIKE '%Europe%')

-- Exm 2: Subquery from another table - Population more than 100,000,000
SELECT * FROM Football_Data_2020 WHERE Country IN (SELECT DISTINCT Country FROM Countries_Data WHERE [Population] > 100000000)

-- Exm 3: Subquery from same table - Select all games that happened in max date
SELECT * FROM Football_Data_2020 WHERE [Date] = (SELECT MAX(DATE) FROM Football_Data_2020)

-- Exm 4: Subquery from same table - Select all countries that ever participated in UEFA games)
SELECT * FROM Football_Data_2020 WHERE Home_Team IN (SELECT DISTINCT Home_Team FROM Football_Data_2020 WHERE Tournament LIKE '%UEFA%')


-------------------------------------------------------------------------------------------------------------------
---------------------------------------      Step 4: IIF & Case Statements in SQL          ------------------------
-------------------------------------------------------------------------------------------------------------------

-- Exm 1: If Country is England add a "- UK" at the end
SELECT [Date], Home_Team, Away_Team, Home_Score, Away_Score, Tournament, City, IIF(Country = 'England', 'England - UK', Country) AS Country,
Neutral FROM Football_Data_2020

-- Exm 2: If Country is England, Scotland, Wales & Northern Ireland add a "- UK" at the end
SELECT [Date], Home_Team, Away_Team, Home_Score, Away_Score, Tournament, City, IIF(Country IN ('England','Scotland','Wales','Northern Ireland'), Country + ' - UK', Country) AS Country,
Neutral FROM Football_Data_2020

-- Exm 3: If Country is England add a "- UK" at the end - CASE
SELECT [Date],  Home_Team, Away_Team, Home_Score, Away_Score, Tournament, City, 

CASE
	WHEN Country = 'England' THEN 'England - UK'
	ELSE Country 
END AS Country,

Neutral 
FROM Football_Data_2020

-- Exm 4: If Country is England, Scotland, Wales & Northern Ireland add a "- UK" at the end

SELECT [Date], Home_Team, Away_Team, Home_Score, Away_Score, Tournament, City, 

CASE
	WHEN Country = 'England' THEN 'England - UK'
	WHEN Country = 'Scotland' THEN 'Scotland - UK'
	WHEN Country = 'Wales' THEN 'Wales - UK'
	WHEN Country = 'Northern Ireland' THEN 'Northern Ireland - UK'
	-- WHEN Country IN ('England','Scotland','Wales','Northern Ireland') THEN Country + ' - UK',
	ELSE Country 
END AS Country,

Neutral 
FROM Football_Data_2020


-------------------------------------------------------------------------------------------------------------------
-------      Step 5: Rename - Update - Replace - Insert Into - Delete from tables - New Column        -------------
-------------------------------------------------------------------------------------------------------------------

-- Exm 1 - Renaming
SELECT [Date], Home_Team, Away_Team, Home_Score, Away_Score, Tournament, City, IIF(Country = 'England', 'England - UK', Country) AS Country,
Neutral FROM Football_Data_2020

UPDATE Football_Data_2020
SET Country = IIF(Country = 'England', 'England - UK', Country)

-- SELECT * FROM Football_Data_2020

-- Exm 2 - Replacing
SELECT [Date], Home_Team, Away_Team, Home_Score, Away_Score, Tournament, City, IIF(Country = 'England', 'England - UK', Country) AS Country,
REPLACE(Country, 'Scotland', 'Scotland - UK') AS Country2
FROM Football_Data_2020

UPDATE Football_Data_2020
SET Country = REPLACE(Country, 'Scotland', 'Scotland - UK')

-- SELECT * FROM Football_Data_2020

-- Exm 3: INSERT INTO
INSERT INTO Football_Data_2020
SELECT '2022-12-12', 'England', 'Wales', 2, 2, 'British Championship', 'London', 'England - UK', 'Test'

SELECT * FROM Football_Data_2020 WHERE Neutral = 'Test'


-- Exm 4: Deleting a row
DELETE FROM Football_Data_2020 WHERE Neutral = 'Test'


-- Exm 5: Deleting a Column
ALTER TABLE Football_Data_2020
DROP COLUMN Neutral


-- Exm 6: Creating a new column "Score"
SELECT [Date], Home_Team, Away_Team, Home_Score, Away_Score, Tournament, City, Country, CAST(Home_Score AS VARCHAR(3)) + '-' + CAST(Away_Score AS VARCHAR(3)) AS Score
FROM Football_Data_2020

ALTER TABLE Football_Data_2020
ADD Score VARCHAR(10)

UPDATE Football_Data_2020
SET Score = CAST(Home_Score AS VARCHAR(3)) + '-' + CAST(Away_Score AS VARCHAR(3))

SELECT * FROM Football_Data_2020


-------------------------------------------------------------------------------------------------------------------
---------------           Step 6: Aggregated Funtions: SUM - AVERAGE - MIN - MAX - COUNT             --------------
-------------------------------------------------------------------------------------------------------------------

-- Exm 1: SUM - Total Home_Score for England	
SELECT Home_Team, SUM(Home_Score) AS Total_Home_Score
FROM Football_Data_2020
WHERE Home_Team = 'England'
GROUP BY Home_Team

-- Exm 2: SUM - Total Home_Score and Away for England	
SELECT Home_Team, SUM(Home_Score) AS Total_Home_Score, SUM(Away_Score) AS Total_Away_Score
FROM Football_Data_2020
WHERE Home_Team = 'England'
GROUP BY Home_Team

-- Exm 3: SUM - Total Home_Score and Away for England combined
SELECT Home_Team, SUM(Home_Score) AS Total_Home_Score, SUM(Away_Score) AS Total_Away_Score, SUM(Home_Score) + SUM(Away_Score) AS Total_Goals_In_Game
FROM Football_Data_2020
WHERE Home_Team = 'England'
GROUP BY Home_Team

-- Exm 4: COUNT - Total Home_Score and Away for England combined and Number of Games
SELECT Home_Team, SUM(Home_Score) AS Total_Home_Score, SUM(Away_Score) AS Total_Away_Score, SUM(Home_Score) + SUM(Away_Score) AS Total_Goals_In_Game,
COUNT(Home_Team) AS No_Of_Games
FROM Football_Data_2020
WHERE Home_Team = 'England'
GROUP BY Home_Team

-- Exm 5: COUNT - Total Home_Score and Away for England combined and Number of Games and Goals per game
SELECT Home_Team, SUM(Home_Score) AS Total_Home_Score, SUM(Away_Score) AS Total_Away_Score, SUM(Home_Score) + SUM(Away_Score) AS Total_Goals_In_Game,
COUNT(Home_Team) AS No_Of_Games, 
ROUND(CAST(SUM(Home_Score) AS FLOAT) / CAST(COUNT(Home_Team) AS FLOAT),2) AS Goals_Per_Game
FROM Football_Data_2020
WHERE Home_Team = 'England'
GROUP BY Home_Team

-- Exm 6: AVERAGE - Average Home goals per Tournament
SELECT Tournament, ROUND(AVG(CAST(Home_Score AS FLOAT)),2) AS Average_Goals_per_Tournament 
FROM Football_Data_2020
GROUP BY Tournament
ORDER BY AVG(CAST(Home_Score AS FLOAT)) DESC

-- Exm 6: AVERAGE - Average Home goals per Home_Team
SELECT Home_Team, ROUND(AVG(CAST(Home_Score AS FLOAT)),2) AS Average_Goals_per_Home_Team
FROM Football_Data_2020
GROUP BY Home_Team
ORDER BY AVG(CAST(Home_Score AS FLOAT)) DESC

SELECT * FROM Football_Data_2020 WHERE Home_Team = 'Parishes of Jersey'

-- Exm 7: AVERAGE - Average Home goals per Home_Team AND No. of games
SELECT Home_Team, ROUND(AVG(CAST(Home_Score AS FLOAT)),2) AS Average_Goals_per_Home_Team, COUNT(Home_Team) AS No_Of_Games
FROM Football_Data_2020
GROUP BY Home_Team
ORDER BY AVG(CAST(Home_Score AS FLOAT)) DESC

-- Exm 8: MAX - max Home Goals by Home_Team
SELECT Home_Team, MAX(Home_Score) AS Max_Goals 
FROM Football_Data_2020
GROUP BY Home_Team
ORDER BY MAX(Home_Score) DESC

-- Exm 9: Min - Country with MIN GDP Per Capita 
SELECT TOP 10 Country, 
MIN(GDP_$_per_capita) AS Min_GDP_Per_Capita
FROM Countries_Data
WHERE GDP_$_per_capita IS NOT NULL
GROUP BY Country
ORDER BY MIN(GDP_$_per_capita)



-------------------------------------------------------------------------------------------------------------------
----------------------------------           Step 6: JOINS & UNIONS             -----------------------------------
-------------------------------------------------------------------------------------------------------------------

------------------------------------------    Exm 1: LEFT JOIN   --------------------------------------------------

-- 1. We need to SELECT the columns we need from the 2 or more tables we are going to JOIN
-- 2. Need to identify the column(s) that are identical in each table so we can JOIN them
-- 3. Need to specify on top which columns we need from each table

-- Table a: SELECT * FROM Football_Data_2020 WHERE Tournament = 'FIFA World Cup'
-- Table b: SELECT * FROM Countries_Data

-- Question - Show the total Home_Score and GDP Per capita for Home_Team

SELECT a.Home_Team, a.Total_Home_Score, b.GDP_$_per_capita
FROM 
	(SELECT Home_Team, SUM(Home_Score) AS Total_Home_Score FROM Football_Data_2020 WHERE Tournament = 'FIFA World Cup' GROUP BY Home_Team) a
	 
	LEFT JOIN
	(SELECT Country, GDP_$_per_capita FROM Countries_Data) b
	ON a.Home_Team = b.Country

ORDER BY a.Total_Home_Score DESC

-- Exm 2: LEFT JOIN  - Question: Show the total Home_Score, GDP Per capita for Home_Team and Region

SELECT a.Home_Team, a.Total_Home_Score, b.Region, b.GDP_$_per_capita
FROM 
	(SELECT Home_Team, SUM(Home_Score) AS Total_Home_Score FROM Football_Data_2020 WHERE Tournament = 'FIFA World Cup' GROUP BY Home_Team) a

	LEFT JOIN
	(SELECT Country, Region, GDP_$_per_capita FROM Countries_Data) b
	ON a.Home_Team = b.Country

ORDER BY a.Total_Home_Score DESC

-- Exm 3: LEFT JOIN - Total Home Score per Region

SELECT  b.Region, SUM(a.Total_Home_Score) AS Total_Region_Home_Score
FROM 
	(SELECT Home_Team, SUM(Home_Score) AS Total_Home_Score FROM Football_Data_2020 WHERE Tournament = 'FIFA World Cup' GROUP BY Home_Team) a

	LEFT JOIN
	(SELECT Country, Region, GDP_$_per_capita FROM Countries_Data) b
	ON a.Home_Team = b.Country

GROUP BY b.Region
ORDER BY SUM(a.Total_Home_Score) DESC

------------------------------------------    Exm 2: FULL JOIN   --------------------------------------------------

SELECT a.Home_Team, b.Country, ISNULL(a.Home_Team, b.Country) AS Country_Comb,
ISNULL(a.Total_Home_Score, 0) AS Total_Home_Score,
ISNULL(b.GDP_$_per_capita,0) AS GDP_$_per_capita

FROM 
	(SELECT Home_Team, SUM(Home_Score) AS Total_Home_Score FROM Football_Data_2020 WHERE Tournament = 'FIFA World Cup' GROUP BY Home_Team) a --78 rows

	FULL JOIN
	(SELECT Country, GDP_$_per_capita FROM Countries_Data) b --227 rows
	ON a.Home_Team = b.Country

ORDER BY a.Total_Home_Score DESC

--before: 78
--after: 241

------------------------------------------    Exm 3: INNER JOIN   --------------------------------------------------

SELECT a.Home_Team, a.Total_Home_Score, b.GDP_$_per_capita
FROM 
	(SELECT Home_Team, SUM(Home_Score) AS Total_Home_Score FROM Football_Data_2020 WHERE Tournament = 'FIFA World Cup' GROUP BY Home_Team) a

	INNER JOIN
	(SELECT Country, GDP_$_per_capita FROM Countries_Data) b
	ON a.Home_Team = b.Country

ORDER BY a.Total_Home_Score DESC

--before: 78
--afeter: 64


------------------------------------------    Exm 4: CROSS JOIN   --------------------------------------------------

SELECT a.Home_Team, b.Country, a.Total_Home_Score, b.GDP_$_per_capita
FROM 
	(SELECT Home_Team, SUM(Home_Score) AS Total_Home_Score FROM Football_Data_2020 WHERE Tournament = 'FIFA World Cup' GROUP BY Home_Team) a

	CROSS JOIN
	(SELECT Country, GDP_$_per_capita FROM Countries_Data) b
	--ON a.Home_Team = b.Country

ORDER BY a.Total_Home_Score DESC

--before: 78
--afeter: 17,706


------------------------------------------    Exm 5: UNIONS   --------------------------------------------------

-- 1: Create the table

IF OBJECT_ID('Football_Data_2021') IS NOT NULL DROP TABLE Football_Data_2021

CREATE TABLE Football_Data_2021
([Date] NVARCHAR(200),
Home_Team NVARCHAR(200),
Away_Team NVARCHAR(200),
Home_Score INT,
Away_Score INT,
Tournament NVARCHAR(200),
City NVARCHAR(200),
Country NVARCHAR(200),
Neutral NVARCHAR(200)
)

--SELECT * FROM Football_Data_2021

-- 2: Import the Data

BULK INSERT Football_Data_2021
FROM 'G:\My Drive\Youtube Videos\6. SQL Tutorial\results 2021.csv'
WITH ( FORMAT='CSV');

-- Table a: SELECT * FROM Football_Data_2020 -- 42,003
-- Table b: SELECT * FROM Football_Data_2021 -- 1,078

SELECT * FROM Football_Data_2020
UNION ALL
SELECT * FROM Football_Data_2021

-- Total rows: 43,081

------------------------------------------    Exm 7: CREATE A NEW VIEW   --------------------------------------------------

CREATE VIEW Football_Data_2020_2021 AS

SELECT * FROM Football_Data_2020
UNION ALL
SELECT * FROM Football_Data_2021

-- SELECT * FROM Football_Data_2020_2021