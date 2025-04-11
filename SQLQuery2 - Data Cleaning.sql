  /*

	Cleaning Data in  SQL Queries
	
  */
  
SELECT
	*
FROM 
	PortofolioProject..NashvilleHousing


-------------------------------------------------------------------------------------------------
-- Standardized Data Format

-- 1)
SELECT
	SaleDate,
	CONVERT(DATE,SaleDate)
FROM 
	PortofolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- 2)
ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- 3)
SELECT
	SaleDateConverted,
	CONVERT(DATE,SaleDate)
FROM 
	PortofolioProject..NashvilleHousing

-------------------------------------------------------------------------------------------------
-- Populate Property Address Data
-- 1) Shows Sale Date Converted
 SELECT
	SaleDateConverted,
	CONVERT(DATE,SaleDate)
 FROM
	PortofolioProject..NashvilleHousing

-- 2) Property Address
 SELECT
	PropertyAddress,
	CONVERT(DATE,SaleDate)
 FROM
	PortofolioProject..NashvilleHousing

-- 3) Shows records of NULL Value in Property Address
SELECT
	PropertyAddress
FROM
	PortofolioProject..NashvilleHousing
WHERE
	PropertyAddress IS NULL

-- 4) Every Records shows that Property Address is NULL
SELECT
	*
FROM
	PortofolioProject..NashvilleHousing
WHERE
	PropertyAddress IS NULL

-- 5) Populate Property Address Data
SELECT
	*
FROM
	PortofolioProject..NashvilleHousing
ORDER BY
	ParcelID

-- 6) Populate Property Address Data
SELECT
	a.ParcelID,
	a.PropertyAddress,
	b.ParcelID,
	b.PropertyAddress
FROM
	PortofolioProject..NashvilleHousing a

-- 7) Populate Property Address Data
SELECT
	a.ParcelID,
	a.PropertyAddress,
	b.ParcelID,
	b.PropertyAddress
FROM
	PortofolioProject..NashvilleHousing a
JOIN
	PortofolioProject..NashvilleHousing b ON
	a.ParcelID = b.ParcelID AND 
	a.[UniqueID ] <> b.[UniqueID ]
WHERE
	a.PropertyAddress IS NULL


-- 8) Populate Property Address Data
SELECT
	a.ParcelID,
	a.PropertyAddress,
	b.ParcelID,
	b.PropertyAddress,
	ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM
	PortofolioProject..NashvilleHousing a
JOIN
	PortofolioProject..NashvilleHousing b ON
	a.ParcelID = b.ParcelID AND 
	a.[UniqueID ] <> b.[UniqueID ]
WHERE
	a.PropertyAddress IS NULL


-- 9) Update Populate Property Address Data
UPDATE a
SET
	PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM
	PortofolioProject..NashvilleHousing a
JOIN
	PortofolioProject..NashvilleHousing b ON
	a.ParcelID = b.ParcelID AND 
	a.[UniqueID ] <> b.[UniqueID ]
WHERE
	a.PropertyAddress IS NULL

-- 10) Check the Record of Populate Property Address Data
-- Shows that there is none of NULL Property Address 
SELECT
	a.ParcelID,
	a.PropertyAddress,
	b.ParcelID,
	b.PropertyAddress,
	ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM
	PortofolioProject..NashvilleHousing a
JOIN
	PortofolioProject..NashvilleHousing b ON
	a.ParcelID = b.ParcelID AND 
	a.[UniqueID ] <> b.[UniqueID ]
WHERE
	a.PropertyAddress IS NULL

---------------------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)
-- 1) Display Property Address
SELECT
	PropertyAddress
FROM
	PortofolioProject..NashvilleHousing
ORDER BY
	ParcelID

-- 2) Split Property Address (using SUBSTRING and CHARINDEX) for Address
SELECT
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)) AS Address
FROM
	PortofolioProject..NashvilleHousing

-- 3) Split Property Address (using SUBSTRING and CHARINDEX) for City
SELECT
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS Address
FROM
	PortofolioProject..NashvilleHousing


-- 4) Display Both SUBSTRING
SELECT
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS Address
FROM
	PortofolioProject..NashvilleHousing	


-- 5) New Column for Split Property Address 
ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))
		

-- 6) Display All Column for Split Property Address
SELECT 
	*
FROM
	PortofolioProject..NashvilleHousing


-- 7) Owner Address
SELECT
	OwnerAddress
FROM
	PortofolioProject..NashvilleHousing

-- 8) Split Owner Address Using PARSENAME
-- REPLACE comma with period since PARSENAME functioned with period
SELECT
	PARSENAME(REPLACE(OwnerAddress,',','.'),1),
	PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	PARSENAME(REPLACE(OwnerAddress,',','.'),3)
FROM
	PortofolioProject..NashvilleHousing

-- 9) Split Owner Address Using PARSENAME
-- REPLACE comma with period since PARSENAME functioned with period
SELECT
	PARSENAME(REPLACE(OwnerAddress,',','.'),3),
	PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM
	PortofolioProject..NashvilleHousing


-- 10) Split Owner Address Using PARSENAME
-- REPLACE comma with period since PARSENAME functioned with period
-- Add Column Table OwnerSplitAddress and OwnerSplitCity
ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT
	*
FROM
	PortofolioProject..NashvilleHousing


-------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" Field

-- 1) Display all distinct field of "Sold as Vacant"
SELECT DISTINCT
	SoldAsVacant,
	COUNT(SoldAsVacant)
FROM
	PortofolioProject..NashvilleHousing
GROUP BY
	SoldAsVacant
ORDER BY 
	COUNT(SoldAsVacant)

-- 2) Display the original and changed value of "Sold as Vacant"
SELECT
	SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
FROM
	PortofolioProject..NashvilleHousing

-- 3) Display the original and changed value of "Sold as Vacant" using UPDATE and SET
UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END

SELECT DISTINCT
	SoldAsVacant,
	COUNT(SoldAsVacant)
FROM
	PortofolioProject..NashvilleHousing
GROUP BY
	SoldAsVacant
ORDER BY 
	COUNT(SoldAsVacant)



  -------------------------------------------------------------------------------------------------
  -- Removing Duplicates

  -- 1)
  SELECT 
	*,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference ORDER BY
					UniqueID
				 ) row_num

  FROM
	PortofolioProject..NashvilleHousing
  ORDER BY
	ParcelID

-- 2)
  WITH RowNumCTE AS (
  SELECT 
	*,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
				 ORDER BY
					UniqueID
				 ) row_num

  FROM
	PortofolioProject..NashvilleHousing
  WHERE
	row_num > 1
  ORDER BY
	ParcelID
 )
	SELECT
		*
	FROM
		RowNumCTE
	WHERE
		row_num > 1
	ORDER BY
		

-- 3)
  SELECT
	*
  FROM
	PortofolioProject..NashvilleHousing

-- 4)
  WITH RowNumCTE AS (
  SELECT 
	*,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
				 ORDER BY
					UniqueID
				 ) row_num

  FROM
	PortofolioProject..NashvilleHousing
--  ORDER BY
--	ParcelID
)

SELECT
	*
FROM
	RowNumCTE
WHERE
	row_num > 1
ORDER BY
	PropertyAddress
 


 -------------------------------------------------------------------------------------------------
 -- Delete Unused Columns

SELECT
	*
FROM
	PortofolioProject..NashvilleHousing

-- 1) Delete Multiple Unused Column
-- There is OwnerSplitAddress and PropertySplitAddress so we delete OwnerAddress and PropertySplitAddress column
-- There only one distinct value except NULL so we delete TaxDistrict column
ALTER TABLE PortofolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, 
			TaxDistrict, 
			PropertyAddress

-- There is SaleDateConverted so we delete SaleDate
ALTER TABLE PortofolioProject..NashvilleHousing
DROP COLUMN SaleDate


-- 2) Display All Column withour the Unused Column 
SELECT
	*
FROM
	PortofolioProject..NashvilleHousing