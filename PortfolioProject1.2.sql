Select *
From [Portfolio projects1.2].[dbo].[ElectricityAccess]

--This query was to round off the "%_Access_electricity" column to the 2nd decimal point.
Select ROUND([%_Access_Electricity], 2) as Access_Electricity2
From [Portfolio projects1.2].[dbo].[ElectricityAccess]

--This query was to alter the table and add this new 2-decimal point column.
Alter Table [Portfolio projects1.2].[dbo].[ElectricityAccess]
ADD Access_Electricity2 float

Alter Table [Portfolio projects1.2].[dbo].[ElectricityAccess]
Delete Access_Electricity2
--That query worked, but for some reason it was showing NULL values on the original Table.
--Those reasons were; the new column didn't come with the original table so the values couldn't reflect.

With ElecAccess ([Entity],[Code],[Year],[%_Access_Electricity]) as
(
Select ROUND([%_Access_Electricity], 2) as Access_Electricity2
From [Portfolio projects1.2].[dbo].[ElectricityAccess]
)
Select *, Access_Electricity2
From ElecAccess
--Using CTE, I kept getting an "incorrect syntax error" and later found out CTEs and TEMP tables are used with JOINS.

Select *
From [Portfolio projects1.2].[dbo].[ElectricityAccess]
Where [Year]= 1990
Order by [Entity] Asc

Select COUNT([Year]) as Total_No_of_Country_in_1990
From [Portfolio projects1.2].[dbo].[ElectricityAccess]
Where [Year]= 1990

Select COUNT([Year]) as Total_No_of_Country_in_2005
From [Portfolio projects1.2].[dbo].[ElectricityAccess]
Where [Year] <=2005

Select [Entity],[Year]
From [Portfolio projects1.2].[dbo].[ElectricityAccess]
Order by [Year] Asc




--For the visualization;
--The Total number of years each country has had electricity so far.
--The Access of Electricity per year.
--The Avg. % of Electricity since its inception.