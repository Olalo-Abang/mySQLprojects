/*

Cleaning Data in SQL Queries

*/

Select * 
From [Portfolio Projects].[dbo].[Nashville Housing]



--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDate
From [Portfolio Projects].[dbo].[Nashville Housing]


Select SaleDate, CONVERT(Date, SaleDate)
From [Portfolio Projects].[dbo].[Nashville Housing]

Update [Portfolio Projects].[dbo].[Nashville Housing]
SET SaleDate= CONVERT(Date, SaleDate)


Drop column SaleDate
From 
-- If it doesn't Update properly


Alter Table [Portfolio Projects].[dbo].[Nashville Housing]
Add SaleDateArranged Date

Update [Portfolio Projects].[dbo].[Nashville Housing]
SET SaleDateArranged= CONVERT(Date, SaleDate)

Select SaleDateArranged, CONVERT(Date, SaleDate)
From [Portfolio Projects].[dbo].[Nashville Housing]

Select SaleDateArranged
From [Portfolio Projects].[dbo].[Nashville Housing]


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From [Portfolio Projects].[dbo].[Nashville Housing]
--where PropertyAddress is null
order by ParcelID


Select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress
From [Portfolio Projects].[dbo].[Nashville Housing] as A
Join [Portfolio Projects].[dbo].[Nashville Housing] as B
     on A.ParcelID= B.ParcelID
     AND A.[UniqueID ]<> B.[UniqueID ]
where A.PropertyAddress is null

--ISNULL help populate a NULL column with the desired column value.

Select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
From [Portfolio Projects].[dbo].[Nashville Housing] as A
Join [Portfolio Projects].[dbo].[Nashville Housing] as B
     on A.ParcelID= B.ParcelID
     AND A.[UniqueID ]<> B.[UniqueID ]
where A.PropertyAddress is null

--when using Joins in an Update statement, you query it by its alias.
Update  A
SET PropertyAddress= ISNULL(A.PropertyAddress, B.PropertyAddress) 
From [Portfolio Projects].[dbo].[Nashville Housing] as A
Join [Portfolio Projects].[dbo].[Nashville Housing] as B
     on A.ParcelID= B.ParcelID
     AND A.[UniqueID ]<> B.[UniqueID ]
--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From [Portfolio Projects].[dbo].[Nashville Housing]
--where PropertyAddress is null
--order by ParcelID

--Using Substring
Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address
From [Portfolio Projects].[dbo].[Nashville Housing]

--So the output here is starting from the very first value and keeps the values until the coma(,)

--Now if we want to remove the coma(,) here, we can do this;
Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address,
CHARINDEX(',', PropertyAddress) --this query shows show the no. of values per row.

From [Portfolio Projects].[dbo].[Nashville Housing]


--This takes the coma(,) away.
Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
From [Portfolio Projects].[dbo].[Nashville Housing]

--Now if we want to separate STARTING FROM the coma;
Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
From [Portfolio Projects].[dbo].[Nashville Housing]


--two values can't be separatd if two corresponding columns haven't been created.
--So to separate two values, we alter the table and SET it.

Alter Table [Portfolio Projects].[dbo].[Nashville Housing]
Add PropertySplitAddress Nvarchar(255)

Update [Portfolio Projects].[dbo].[Nashville Housing]
SET PropertySplitAddress= SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


Alter Table [Portfolio Projects].[dbo].[Nashville Housing]
Add PropertySplitCity Nvarchar(255)

Update [Portfolio Projects].[dbo].[Nashville Housing]
SET PropertySplitCity= SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select *
From[Portfolio Projects].[dbo].[Nashville Housing]

--SEPARTE OWNER ADDRESS
--To separate another column without using SUBSTRING Function.
Select OwnerAddress
From[Portfolio Projects].[dbo].[Nashville Housing]

--Using PARSENAME
--PARSENAME only looks for "Periods"(.) in columns to use as a separator, nothing else.
--PARSENAME separates the coluns BACKWARDS.
Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
From[Portfolio Projects].[dbo].[Nashville Housing]


Alter Table [Portfolio Projects].[dbo].[Nashville Housing]
Add OwnerSplitAddress Nvarchar(255)

Update [Portfolio Projects].[dbo].[Nashville Housing]
SET OwnerSplitAddress= PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

Alter Table [Portfolio Projects].[dbo].[Nashville Housing]
Add OwnerSplitCity Nvarchar(255)

Update [Portfolio Projects].[dbo].[Nashville Housing]
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

Alter Table [Portfolio Projects].[dbo].[Nashville Housing]
Add OwnerSplitState Nvarchar(255)

Update [Portfolio Projects].[dbo].[Nashville Housing]
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)


Select *
From[Portfolio Projects].[dbo].[Nashville Housing]

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct[SoldAsVacant], Count([SoldAsVacant])
From[Portfolio Projects].[dbo].[Nashville Housing]
Group by [SoldAsVacant]
Order by 2
--"Order by 2" arranges the column by increasing order---------------------------
--"Order by 1" arranges the column as it is. i.e it does not arrange it.--------- THIS HAPPENS BECAUSE OF THE "SELECT DISTINCT" FUNCTION, I THINK.
--"Order by 3" gives an error, so does "Order by 4"------------------------------

Select [SoldAsVacant],
CASE when [SoldAsVacant] = 'Y' THEN 'Yes'
     when [SoldAsVacant] = 'N' THEN 'No'
	 ELSE [SoldAsVacant]
	 END
From[Portfolio Projects].[dbo].[Nashville Housing]


Update [Portfolio Projects].[dbo].[Nashville Housing]
SET [SoldAsVacant] = CASE when [SoldAsVacant] = 'Y' THEN 'Yes'
     when [SoldAsVacant] = 'N' THEN 'No'
	 ELSE [SoldAsVacant]
	 END

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
Select *,
      ROW_NUMBER() OVER( 
--now, we are partitioning this dataset ASSUMING certain columns are THE SAME.
	  PARTITION BY ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY
				         UniqueID
					) as Row_No
From[Portfolio Projects].[dbo].[Nashville Housing]


WITH RowNoCTE AS (
Select *,
      ROW_NUMBER() OVER( 
	  PARTITION BY ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY
				         UniqueID
					) as Row_No
From[Portfolio Projects].[dbo].[Nashville Housing]
--Order by ParcelID
)
Select *
From RowNoCTE

WITH RowNoCTE AS (
Select *,
      ROW_NUMBER() OVER( 
	  PARTITION BY ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY
				         UniqueID
					) as Row_No
From[Portfolio Projects].[dbo].[Nashville Housing]
--Order by ParcelID
)
Select *
From RowNoCTE
Where Row_No > 1
Order by OwnerName

WITH RowNoCTE AS (
Select *,
      ROW_NUMBER() OVER( 
	  PARTITION BY ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY
				         UniqueID
					) as Row_No
From[Portfolio Projects].[dbo].[Nashville Housing]
--Order by ParcelID
)
DELETE
From RowNoCTE
Where Row_No > 1

--It is not professional deleting raw data no matter the circumstances,
--this query is for practice and pratice only. Never to b used in real working environment.

Select * 
From[Portfolio Projects].[dbo].[Nashville Housing]

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select * 
From[Portfolio Projects].[dbo].[Nashville Housing]


Alter Table [Portfolio Projects].[dbo].[Nashville Housing]
Drop Column[OwnerAddress], [TaxDistrict], [PropertyAddress]

Alter Table [Portfolio Projects].[dbo].[Nashville Housing]
Drop Column[SaleDate]

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------