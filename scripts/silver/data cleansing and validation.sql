
--============================ crm_cust_info ==========================================

-- Checking on duplicate values for the KEY
SELECT
cst_id,
COUNT(*)
FROM DataWarehouse.bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL 

-- Checking an example of the duplicate values and deciding on the way to move forward
SELECT
*
FROM DataWarehouse.bronze.crm_cust_info
WHERE cst_id = 29466

-- Check for unwanted spaces either before or after text values by LEN function
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE LEN(cst_firstname) != LEN(TRIM(cst_firstname))

SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE LEN(cst_lastname) != LEN(TRIM(cst_lastname))

SELECT cst_gndr
FROM bronze.crm_cust_info
WHERE LEN(cst_gndr) != LEN(TRIM(cst_gndr))

-- Data standardization & consistency
SELECT
DISTINCT (cst_gndr)
FROM bronze.crm_cust_info

SELECT
DISTINCT (cst_marital_status)
FROM bronze.crm_cust_info

--============================ crm_prd_info ==========================================

-- Checking on duplicate values for the KEY
SELECT
prd_id,
COUNT(*)
FROM DataWarehouse.bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL 

-- Check for unwanted spaces
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check for NULLS or negative numbers
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Data standardization & consistency
SELECT DISTINCT(prd_line)
FROM bronze.crm_prd_info

-- Check for invalid date orders
SELECT * 
FROM bronze.crm_prd_info
WHERE prd_start_dt > prd_end_dt
ORDER BY prd_key

--============================ crm_sales_details ==========================================

-- Check for unwanted spaces
SELECT sls_ord_num
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)

-- Check that sls_prd_key and sls_cust_id are present in the silver.crm_cust_info table
SELECT
sls_prd_key
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)

SELECT
sls_cust_id
FROM bronze.crm_sales_details b
WHERE NOT EXISTS (SELECT cst_id FROM silver.crm_cust_info s WHERE b.sls_cust_id = s.cst_id)

-- Check on dates columns
WITH MyCTE AS ( -- Replaced zeros with NULL first for more accurate validation
SELECT
NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
)
SELECT 
sls_due_dt
FROM MyCTE
WHERE (sls_due_dt IS NOT NULL
AND sls_due_dt <= 0)
OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101

-- Check if dates are in an invalid order
SELECT
sls_order_dt,
sls_ship_dt,
sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
OR sls_order_dt > sls_due_dt
OR sls_ship_dt > sls_due_dt

/* Check data consistency between Sales, Quantity and Price
	Sales should equl Quantity * Price
	Values of all three cannot be NULL, zero or negative. */
SELECT DISTINCT
CASE
	WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity*ABS(sls_price) THEN sls_quantity*ABS(sls_price)
	ELSE sls_sales
END AS sls_sales,
sls_quantity AS old_sls_quantity,
CASE 
	WHEN sls_price <= 0 OR sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity, 0)
	ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != (sls_quantity * sls_price)
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0


--============================ erp_cust_az12 ==========================================

-- cid column check to tie with the id in silver.crm_cust_info
SELECT DISTINCT TOP 5 cid FROM bronze.erp_cust_az12
SELECT TOP 5 * FROM silver.crm_cust_info

-- Two more methods for confirmation that 'NAS' is added to particular records
	SELECT LEN(CID), COUNT(*)
	FROM bronze.erp_cust_az12
	GROUP BY LEN(CID)

	SELECT DISTINCT LEFT(CID, 3)
	FROM bronze.erp_cust_az12
	WHERE LEFT(CID, 3) != 'NAS'

-- Validating bdate column values
SELECT
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()
ORDER BY bdate DESC

-- Data Standardization & Consistency
SELECT DISTINCT
gen
FROM bronze.erp_cust_az12

-- CTE to check data cleansing is accomplished accurately and correctly
/*
WITH MyCTE AS (
SELECT
CASE
	WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
	ELSE cid
END AS cid,
CASE
	WHEN bdate > GETDATE() THEN NULL
	ELSE bdate
END AS bdate,
gen,
CASE
	WHEN UPPER(TRIM(gen)) IN ('F', 'Female') THEN 'Female'
	WHEN UPPER(TRIM(gen)) IN ('M', 'Male') THEN 'Male'
	ELSE 'N/A'
END AS gen1
FROM bronze.erp_cust_az12
)
SELECT DISTINCT gen, gen1
FROM MyCTE
*/


--============================ erp_loc_a101 ==========================================

-- Validate cid
-- Finding: a '-' is used between characters that requires removal to match with cst_key in crm_cust_info table
SELECT 
cid
FROM bronze.erp_loc_a101

-- Check for standardization & consistency for cntry column
-- Finding: Low cardinality that needs to be unified
SELECT DISTINCT
cntry
FROM bronze.erp_loc_a101
ORDER BY cntry

--============================ erp_px_cat_g1v2 ==========================================

-- id column already aligned with the created cat_id column from silver.crm_prd_info
-- Checking for unwanted spaces in cat column
-- Finding: No unwanted spaces
SELECT
*
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
OR subcat != TRIM(subcat)
OR maintenance != TRIM(maintenance)

-- Data Standardization & Consistency
SELECT DISTINCT
--cat
--subcat
maintenance
FROM bronze.erp_px_cat_g1v2

