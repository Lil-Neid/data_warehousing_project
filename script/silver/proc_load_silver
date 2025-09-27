/* 
=====================================================
Stored Procedure : Load Silver Layer (Bronze -> Silver)
=====================================================
Script Purpose
  This stored procedure loads data into the 'silver' schema 
  from 'bronze' schema tables. It performs the following actions:
    - Truncates silver tables before loading.
    - Transforms and inserts cleansed data from bronze into silver.
    
Parameters
  None

Usage Example
EXEC silver.load_silver;
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '===================================';
        PRINT 'Loading Silver Layer';
        PRINT '===================================';

        PRINT '-----------------------------------';
        PRINT 'Transforming CRM Tables';
        PRINT '-----------------------------------';

        -- Table: silver.crm_cust_info
        SET @start_time = GETDATE();
        PRINT '>> Truncating table : silver.crm_cust_info';
        TRUNCATE TABLE silver.crm_cust_info;

        PRINT '>> Inserting data : silver.crm_cust_info';
        INSERT INTO silver.crm_cust_info (
            cst_id, cst_key, cst_firstname, cst_lastname, 
            cst_marital_status, cst_gndr, cst_create_date
        )
        SELECT 
            cst_id,
            cst_key,
            TRIM(cst_firstname),
            TRIM(cst_lastname),
            CASE 
                WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
                WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
                ELSE 'n/a'
            END,
            CASE 
                WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                ELSE 'n/a'
            END,
            cst_create_date
        FROM (
            SELECT *, ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag
            FROM bronze.crm_cust_info
        ) t
        WHERE flag = 1 AND cst_id IS NOT NULL;
        SET @end_time = GETDATE();
        PRINT '>> Load duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '--------------------------';


        -- Table: silver.crm_prd_info
        SET @start_time = GETDATE();
        PRINT '>> Truncating table : silver.crm_prd_info';
        TRUNCATE TABLE silver.crm_prd_info;

        PRINT '>> Inserting data : silver.crm_prd_info';
        INSERT INTO silver.crm_prd_info (
            prd_id, cat_id, prd_key, prd_nm, 
            prd_cost, prd_line, prd_start_dt, prd_end_dt
        )
        SELECT 
            prd_id,
            REPLACE(SUBSTRING(prd_key, 1,5),'-','_'),
            SUBSTRING(prd_key,7 , LEN(prd_key)),
            prd_nm,
            ISNULL(prd_cost,0),
            CASE 
                WHEN TRIM(UPPER(prd_line)) = 'R' THEN 'Road'
                WHEN TRIM(UPPER(prd_line)) = 'M' THEN 'Mountain'
                WHEN TRIM(UPPER(prd_line)) = 'S' THEN 'Other Sales'
                WHEN TRIM(UPPER(prd_line)) = 'T' THEN 'Touring'
                ELSE 'n/a'
            END,
            CAST(prd_start_dt AS DATE),
            CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE)
        FROM bronze.crm_prd_info;
        SET @end_time = GETDATE();
        PRINT '>> Load duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '--------------------------';


        -- Table: silver.crm_sales_details
        SET @start_time = GETDATE();
        PRINT '>> Truncating table : silver.crm_sales_details';
        TRUNCATE TABLE silver.crm_sales_details;

        PRINT '>> Inserting data : silver.crm_sales_details';
        INSERT INTO silver.crm_sales_details (
            sls_ord_num, sls_prd_key, sls_cust_id, 
            sls_order_dt, sls_ship_dt, sls_due_dt, 
            sls_sales, sls_quantity, sls_price
        )
        SELECT 
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            CASE 
                WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
            END,
            CASE 
                WHEN sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
            END,
            CASE 
                WHEN sls_due_dt <= 0 OR LEN(sls_due_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
            END,
            CASE 
                WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != (sls_quantity * ABS(sls_price))
                    THEN sls_quantity * ABS(sls_price) 
                ELSE sls_sales
            END,
            sls_quantity,
            CASE 
                WHEN sls_price <= 0 OR sls_price IS NULL
                    THEN sls_sales / sls_quantity
                ELSE sls_price
            END
        FROM bronze.crm_sales_details;
        SET @end_time = GETDATE();
        PRINT '>> Load duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '--------------------------';


        PRINT '-----------------------------------';
        PRINT 'Transforming ERP Tables';
        PRINT '-----------------------------------';

        -- Table: silver.erp_cust_az12
        SET @start_time = GETDATE();
        PRINT '>> Truncating table : silver.erp_cust_az12';
        TRUNCATE TABLE silver.erp_cust_az12;

        PRINT '>> Inserting data : silver.erp_cust_az12';
        INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
        SELECT
            CASE 
                WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4 , LEN(cid))
                ELSE cid
            END,
            CASE 
                WHEN bdate > GETDATE() THEN NULL
                ELSE bdate
            END,
            CASE 
                WHEN UPPER(TRIM(gen)) IN ('FEMALE', 'F') THEN 'Female'
                WHEN UPPER(TRIM(gen)) IN ('MALE' , 'M') THEN 'Male'
                ELSE 'n/a'
            END
        FROM bronze.erp_cust_az12;
        SET @end_time = GETDATE();
        PRINT '>> Load duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '--------------------------';


        -- Table: silver.erp_loc_a101
        SET @start_time = GETDATE();
        PRINT '>> Truncating table : silver.erp_loc_a101';
        TRUNCATE TABLE silver.erp_loc_a101;

        PRINT '>> Inserting data : silver.erp_loc_a101';
        INSERT INTO silver.erp_loc_a101 (cid, cntry)
        SELECT 
            REPLACE(cid,'-',''),
            CASE 
                WHEN cntry IN ('USA','US') THEN 'United States'
                WHEN cntry = 'DE' THEN 'Germany'
                WHEN cntry ='' OR cntry IS NULL THEN 'n/a'
                ELSE cntry
            END
        FROM bronze.erp_loc_a101;
        SET @end_time = GETDATE();
        PRINT '>> Load duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '--------------------------';


        -- Table: silver.erp_px_cat_g1v2
        SET @start_time = GETDATE();
        PRINT '>> Truncating table : silver.erp_px_cat_g1v2';
        TRUNCATE TABLE silver.erp_px_cat_g1v2;

        PRINT '>> Inserting data : silver.erp_px_cat_g1v2';
        INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
        SELECT id, cat, subcat, maintenance
        FROM bronze.erp_px_cat_g1v2;
        SET @end_time = GETDATE();
        PRINT '>> Load duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '--------------------------';


        SET @batch_end_time = GETDATE();
        PRINT '===================================';
        PRINT 'Loading Silver Layer is Completed';
        PRINT ' >> Total Load Duration :' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '===================================';

    END TRY
    BEGIN CATCH
        PRINT '===================================';
        PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER';
        PRINT 'Error message : ' + ERROR_MESSAGE();
        PRINT 'Error number  : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error state   : ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '===================================';
    END CATCH
END;

EXEC silver.load_silver;
