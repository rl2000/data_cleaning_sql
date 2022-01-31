
---	Database Name: Median_houseprice
--- Datasets cleaned: 1. allproperties, 2. detached houses, 3. semi-detached houses, 4. terraced houses, 5. flats
--- Data cleaning steps include: 1. Dropping columns 2. changing column names 3. finding duplicates using 'row_number'
--- 4.deleting duplicates using 'with clause' 5. finding and dealing with nulls 
--- 6.seperating codes from town names using string function 'Replace'.

CREATE DATABASE Median_houseprice;
USE Median_houseprice;

----SQL Data Cleaning Querries----

---	Table 1: allproperties. First look at dataset after importing.

SELECT *
FROM dbo.allproperties;

---2. Check for duplicate values--using window function row_number(). There are duplicates. All values are repeated 2 times

SELECT Town_Id, Town_name, [2020],
row_number() over(partition by Town_name Order by Town_Id  ) as x
FROM dbo.allproperties
WHERE Region_County = 'West Midlands';

---3. Delete duplicates in table allproperties using with clause.

WITH cte_duplicates AS
	-- create a flag column with duplicates numbers
	(	SELECT Town_Id, Town_name, [2020],
		row_number() over(partition by Town_name order by Town_Id) as x               
		FROM dbo.allproperties)

		-- Now Delete Duplicate Records
		DELETE FROM cte_duplicates
		WHERE x > 1;



---	Table 2: detached_houses. First look at dataset after importing.

SELECT *
FROM dbo.detached_houses;

--- 2.	Dropping columns not required.
ALTER TABLE dbo.detached_houses
DROP COLUMN [1995], [1996], [1997], [1998], [1999], [2000], [2001], 
			[2002], [2003], [2004], [2005], [2006], [2007], [2008], [2009], [2010], 
			[2011],[2012],[2013],[2014];

EXEC sp_rename 'dbo.detached_houses.Percentage Change from 2010 to 2020', 'Percentage_change_1', 'COLUMN';

ALTER TABLE dbo.detached_houses
DROP COLUMN Percentage_change_1;

EXEC sp_rename 'dbo.detached_houses.Percentage Change from 2000 to 2010', 'Percentage_change_2', 'COLUMN';

ALTER TABLE dbo.detached_houses
DROP COLUMN Percentage_change_2;

--3. Changing column names.
EXEC sp_rename 'dbo.detached_houses.TOWN11CD', 'Town_Id', 'COLUMN';
EXEC sp_rename 'dbo.detached_houses.TOWN11NM', 'Town_name', 'COLUMN';
EXEC sp_rename 'dbo.detached_houses.Settlement Type', 'Town_type', 'COLUMN';
EXEC sp_rename 'dbo.detached_houses.Region / Country', 'Region_County', 'COLUMN';

--4. Finding Null Values.....(12 Rows have NULL Values in 2015 column)
SELECT Town_Id, [2015]
FROM dbo.detached_houses
WHERE [2015] IS NULL
GROUP BY Town_Id, [2015];

SELECT Town_Id, [2016] ---(10 rows are NULL)
FROM dbo.detached_houses
WHERE [2016] IS NULL
GROUP BY Town_Id, [2016];

SELECT Town_Id, [2017] ---(11 rows are NULL)
FROM dbo.detached_houses
WHERE [2017] IS NULL
GROUP BY Town_Id, [2017];

SELECT Town_Id, [2018] ---(13 rows are NULL)
FROM dbo.detached_houses
WHERE [2018] IS NULL
GROUP BY Town_Id, [2018];

SELECT Town_Id, [2019] ---(15 rows are NULL)
FROM dbo.detached_houses
WHERE [2019] IS NULL
GROUP BY Town_Id, [2019];

SELECT Town_Id, [2020] ---(18 rows are NULL)
FROM dbo.detached_houses
WHERE [2020] IS NULL
GROUP BY Town_Id, [2020];

--5. Deleting Nullss. On studying the Null Values, I cannot add 'zeros' or leave them null as this will affect the explorative analysis. 
---  Therefore I have decided to drop entire rows that contain NULL values. Some towns will be lost. 

DELETE FROM dbo.detached_houses 
where [2015] IS NULL OR [2016] IS NULL OR [2017] IS NULL OR 
		[2018] IS NULL OR [2019] IS NULL OR [2020] IS NULL;


---	6. Seperate Codes from town names.

SELECT Town_name
FROM dbo.detached_houses;

UPDATE dbo.detached_houses
SET Town_name = REPLACE(Town_name, 'BUASD','') ;

UPDATE dbo.detached_houses
SET Town_name = REPLACE(Town_name, 'BUA','') ;


--- 7. Find duplicate values using row_number--
SELECT Town_Id, Town_name, [2020],
row_number() over(partition by Town_name Order by Town_Id  ) as x
FROM dbo.detached_houses
WHERE Region_County = 'West Midlands'; -- There are no duplicates. 

-- *********************************************************************************************************************************--
---	Table 3: semidetached_houses. First look at dataset after importing.

SELECT *
FROM dbo.semidetached_houses;

---	2.Dropping columns not required.
ALTER TABLE dbo.semidetached_houses
DROP COLUMN [1995], [1996], [1997], [1998], [1999], [2000], [2001], 
			[2002], [2003], [2004], [2005], [2006], [2007], [2008], [2009], [2010], 
			[2011],[2012],[2013],[2014];

			
EXEC sp_rename 'dbo.semidetached_houses.Percentage Change from 2010 to 2020', 'Percentage_change_1', 'COLUMN';

ALTER TABLE dbo.semidetached_houses
DROP COLUMN Percentage_change_1;

EXEC sp_rename 'dbo.semidetached_houses.Percentage Change from 2000 to 2010', 'Percentage_change_2', 'COLUMN';

ALTER TABLE dbo.semidetached_houses
DROP COLUMN Percentage_change_2;

--3. Changing column names.
EXEC sp_rename 'dbo.semidetached_houses.TOWN11CD', 'Town_Id', 'COLUMN';
EXEC sp_rename 'dbo.semidetached_houses.TOWN11NM', 'Town_name', 'COLUMN';
EXEC sp_rename 'dbo.semidetached_houses.Settlement Type', 'Town_type', 'COLUMN';
EXEC sp_rename 'dbo.semidetached_houses.Region / Country', 'Region_County', 'COLUMN';

--4. Finding Null Values.....(4 Rows have NULL Values in 2015 column)
SELECT Town_Id, [2015]
FROM dbo.semidetached_houses
WHERE [2015] IS NULL
GROUP BY Town_Id, [2015];

SELECT Town_Id, [2016] ---(5 rows are NULL)
FROM dbo.semidetached_houses
WHERE [2016] IS NULL
GROUP BY Town_Id, [2016];

SELECT Town_Id, [2017] ---(3 rows are NULL)
FROM dbo.semidetached_houses
WHERE [2017] IS NULL
GROUP BY Town_Id, [2017];

SELECT Town_Id, [2018] ---(4 rows are NULL)
FROM dbo.semidetached_houses
WHERE [2018] IS NULL
GROUP BY Town_Id, [2018];

SELECT Town_Id, [2019] ---(3 rows are NULL)
FROM dbo.semidetached_houses
WHERE [2019] IS NULL
GROUP BY Town_Id, [2019];


SELECT Town_Id, [2020] ---(8 rows are NULL)
FROM dbo.semidetached_houses
WHERE [2020] IS NULL
GROUP BY Town_Id, [2020];

--5. Deleting Nullss. 

DELETE FROM dbo.semidetached_houses 
where [2015] IS NULL OR [2016] IS NULL OR [2017] IS NULL OR 
		[2018] IS NULL OR [2019] IS NULL OR [2020] IS NULL;


---	6.Seperate Codes from town names.

SELECT Town_name
FROM dbo.semidetached_houses;

UPDATE dbo.semidetached_houses
SET Town_name = REPLACE(Town_name, 'BUASD','') ;

UPDATE dbo.semidetached_houses
SET Town_name = REPLACE(Town_name, 'BUA','') ;

-- *********************************************************************************************************************************--

---	Table 4: terraced_houses. First look at dataset after importing.

SELECT *
FROM dbo.terraced_houses;


--	2.	Dropping columns not required.

ALTER TABLE dbo.terraced_houses
DROP COLUMN [1995], [1996], [1997], [1998], [1999], [2000], [2001], 
			[2002], [2003], [2004], [2005], [2006], [2007], [2008], [2009], [2010], 
			[2011],[2012],[2013],[2014];

			
EXEC sp_rename 'dbo.terraced_houses.Percentage Change from 2010 to 2020', 'Percentage_change_1', 'COLUMN';

ALTER TABLE dbo.terraced_houses
DROP COLUMN Percentage_change_1;

EXEC sp_rename 'dbo.terraced_houses.Percentage Change from 2000 to 2010', 'Percentage_change_2', 'COLUMN';

ALTER TABLE dbo.terraced_houses
DROP COLUMN Percentage_change_2;

--3. Changing column names.
EXEC sp_rename 'dbo.terraced_houses.TOWN11CD', 'Town_Id', 'COLUMN';
EXEC sp_rename 'dbo.terraced_houses.TOWN11NM', 'Town_name', 'COLUMN';
EXEC sp_rename 'dbo.terraced_houses.Settlement Type', 'Town_type', 'COLUMN';
EXEC sp_rename 'dbo.terraced_houses.Region / Country', 'Region_County', 'COLUMN';

--4. Finding Null Values.....(8 Rows have NULL Values in 2015 column)
SELECT Town_Id, [2015]
FROM dbo.terraced_houses
WHERE [2015] IS NULL
GROUP BY Town_Id, [2015];

SELECT Town_Id, [2016] ---(10 rows are NULL)
FROM dbo.terraced_houses
WHERE [2016] IS NULL
GROUP BY Town_Id, [2016];

SELECT Town_Id, [2017] ---(5 rows are NULL)
FROM dbo.terraced_houses
WHERE [2017] IS NULL
GROUP BY Town_Id, [2017];

SELECT Town_Id, [2018] ---(6 rows are NULL)
FROM dbo.terraced_houses
WHERE [2018] IS NULL
GROUP BY Town_Id, [2018];

SELECT Town_Id, [2019] ---(8 rows are NULL)
FROM dbo.terraced_houses
WHERE [2019] IS NULL
GROUP BY Town_Id, [2019];


SELECT Town_Id, [2020] ---(12 rows are NULL)
FROM dbo.terraced_houses
WHERE [2020] IS NULL
GROUP BY Town_Id, [2020];

--5. Deleting Nullss. 

DELETE FROM dbo.terraced_houses 
where [2015] IS NULL OR [2016] IS NULL OR [2017] IS NULL OR 
		[2018] IS NULL OR [2019] IS NULL OR [2020] IS NULL;


---	6. Seperate Codes from town names.

SELECT Town_name
FROM dbo.terraced_houses;

UPDATE dbo.terraced_houses
SET Town_name = REPLACE(Town_name, 'BUASD','') ;

UPDATE dbo.terraced_houses
SET Town_name = REPLACE(Town_name, 'BUA','') ;

-- *********************************************************************************************************************************--

---	Table 5: flats and masonettes----
--	1. First look at dataset after importing.


SELECT *
FROM dbo.flats_maisonettes;


--	2.	Dropping columns not required.

ALTER TABLE dbo.flats_maisonettes
DROP COLUMN [1995], [1996], [1997], [1998], [1999], [2000], [2001], 
			[2002], [2003], [2004], [2005], [2006], [2007], [2008], [2009], [2010], 
			[2011],[2012],[2013],[2014];

			
EXEC sp_rename 'dbo.flats_maisonettes.Percentage Change from 2010 to 2020', 'Percentage_change_1', 'COLUMN';

ALTER TABLE dbo.flats_maisonettes
DROP COLUMN Percentage_change_1;

EXEC sp_rename 'dbo.flats_maisonettes.Percentage Change from 2000 to 2010', 'Percentage_change_2', 'COLUMN';

ALTER TABLE dbo.flats_maisonettes
DROP COLUMN Percentage_change_2;

--3. Changing column names.
EXEC sp_rename 'dbo.flats_maisonettes.TOWN11CD', 'Town_Id', 'COLUMN';
EXEC sp_rename 'dbo.flats_maisonettes.TOWN11NM', 'Town_name', 'COLUMN';
EXEC sp_rename 'dbo.flats_maisonettes.Settlement Type', 'Town_type', 'COLUMN';
EXEC sp_rename 'dbo.flats_maisonettes.Region / Country', 'Region_County', 'COLUMN';


--4. Finding Null Values.....(204 Rows have NULL Values in 2015 column)
SELECT Town_Id, [2015]
FROM dbo.flats_maisonettes
WHERE [2015] IS NULL
GROUP BY Town_Id, [2015];

SELECT Town_Id, [2016] ---(194 rows are NULL)
FROM dbo.flats_maisonettes
WHERE [2016] IS NULL
GROUP BY Town_Id, [2016];

SELECT Town_Id, [2017] ---(197 rows are NULL)
FROM dbo.flats_maisonettes
WHERE [2017] IS NULL
GROUP BY Town_Id, [2017];

SELECT Town_Id, [2018] ---(192 rows are NULL)
FROM dbo.flats_maisonettes
WHERE [2018] IS NULL
GROUP BY Town_Id, [2018];

SELECT Town_Id, [2019] ---(204 rows are NULL)
FROM dbo.flats_maisonettes
WHERE [2019] IS NULL
GROUP BY Town_Id, [2019];


SELECT Town_Id, [2020] ---(272 rows are NULL)
FROM dbo.flats_maisonettes
WHERE [2020] IS NULL
GROUP BY Town_Id, [2020];

---	6. Seperate Codes from town names.

SELECT Town_name
FROM dbo.flats_maisonettes;


UPDATE dbo.flats_maisonettes
SET Town_name = REPLACE(Town_name, 'BUASD','') ;

UPDATE dbo.flats_maisonettes
SET Town_name = REPLACE(Town_name, 'BUA','') ;

---THE END-------------------------------------