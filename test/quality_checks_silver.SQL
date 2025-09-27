/* 
=====================================================
Script : Quality Checks for Silver Layer
=====================================================
Purpose
  Run data quality checks for Silver tables 
  (crm_cust_info, crm_prd_info, crm_sales_details, 
   erp_cust_az12, erp_loc_a101, erp_px_cat_g1v2).

Usage
  Run manually in SSMS or via pipeline after data load.
  Example:
      sqlcmd -S server -d database -i quality_check_silver.sql
=====================================================
*/



/* -----------------------------
   QC : crm_cust_info
------------------------------ */
PRINT 'Checking: silver.crm_cust_info';

-- Row count
SELECT COUNT(*) AS row_count FROM silver.crm_cust_info;

-- Null check (important fields)
SELECT COUNT(*) AS null_id_count 
FROM silver.crm_cust_info 
WHERE cst_id IS NULL;

-- Duplicate key check
SELECT cst_id, COUNT(*) AS dup_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- Gender domain check
SELECT DISTINCT cst_gndr 
FROM silver.crm_cust_info;


/* -----------------------------
   QC : crm_prd_info
------------------------------ */
PRINT 'Checking: silver.crm_prd_info';

SELECT COUNT(*) AS row_count FROM silver.crm_prd_info;

-- Null check
SELECT COUNT(*) AS null_id_count 
FROM silver.crm_prd_info 
WHERE prd_id IS NULL OR prd_key IS NULL;

-- Duplicate product key
SELECT prd_key, COUNT(*) AS dup_count
FROM silver.crm_prd_info
GROUP BY prd_key
HAVING COUNT(*) > 1;

-- Cost sanity check (no negative cost)
SELECT COUNT(*) AS negative_cost_count
FROM silver.crm_prd_info
WHERE prd_cost < 0;


/* -----------------------------
   QC : crm_sales_details
------------------------------ */
PRINT 'Checking: silver.crm_sales_details';

SELECT COUNT(*) AS row_count FROM silver.crm_sales_details;

-- Null check for FK
SELECT COUNT(*) AS null_fk_count
FROM silver.crm_sales_details
WHERE sls_ord_num IS NULL OR sls_prd_key IS NULL OR sls_cust_id IS NULL;

-- Sales validation
SELECT COUNT(*) AS invalid_sales
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * ABS(sls_price);

-- Date sanity check
SELECT 
    SUM(CASE WHEN sls_order_dt > GETDATE() THEN 1 ELSE 0 END) AS future_order,
    SUM(CASE WHEN sls_ship_dt < '1900-01-01' THEN 1 ELSE 0 END) AS invalid_ship
FROM silver.crm_sales_details;


/* -----------------------------
   QC : erp_cust_az12
------------------------------ */
PRINT 'Checking: silver.erp_cust_az12';

SELECT COUNT(*) AS row_count FROM silver.erp_cust_az12;

-- Null check
SELECT COUNT(*) AS null_id_count 
FROM silver.erp_cust_az12
WHERE cid IS NULL;

-- Gender domain check
SELECT DISTINCT gen 
FROM silver.erp_cust_az12;

-- Birthdate sanity
SELECT COUNT(*) AS future_bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();


/* -----------------------------
   QC : erp_loc_a101
------------------------------ */
PRINT 'Checking: silver.erp_loc_a101';

SELECT COUNT(*) AS row_count FROM silver.erp_loc_a101;

-- Null check
SELECT COUNT(*) AS null_id_count 
FROM silver.erp_loc_a101
WHERE cid IS NULL;

-- Country normalization check
SELECT DISTINCT cntry
FROM silver.erp_loc_a101;


/* -----------------------------
   QC : erp_px_cat_g1v2
------------------------------ */
PRINT 'Checking: silver.erp_px_cat_g1v2';

SELECT COUNT(*) AS row_count FROM silver.erp_px_cat_g1v2;

-- Null check
SELECT COUNT(*) AS null_id_count 
FROM silver.erp_px_cat_g1v2
WHERE id IS NULL;

-- Duplicate id check
SELECT id, COUNT(*) AS dup_count
FROM silver.erp_px_cat_g1v2
GROUP BY id
HAVING COUNT(*) > 1;

-- Category domain overview
SELECT DISTINCT cat, subcat
FROM silver.erp_px_cat_g1v2;


