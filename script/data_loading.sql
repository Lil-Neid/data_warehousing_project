CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '===================================';
        PRINT 'Loading Bronze Layer';
        PRINT '===================================';

        PRINT '-----------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '-----------------------------------';

        -- Table: bronze.crm_cust_info (Customer Information)
        SET @start_time = GETDATE();
        PRINT '>> Truncating table : bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Inserting data : bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\nickh\OneDrive\Dokumen\SQL Server Management Studio 21\Datawarehouse_Project_SQL\Datasets\source_crm\crm_cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '--------------------------'



        -- Table: bronze.crm_prd_info (Product Information)
        set @start_time = getdate();
        PRINT '>> Truncating table : bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Inserting data : bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\nickh\OneDrive\Dokumen\SQL Server Management Studio 21\Datawarehouse_Project_SQL\Datasets\source_crm\crm_prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        set @end_time = getdate()
        PRINT '>> Load duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '--------------------------'

        -- Table: bronze.crm_sales_details (Sales Transactions)
        set @start_time = getdate()
        PRINT '>> Truncating table : bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting data : bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\nickh\OneDrive\Dokumen\SQL Server Management Studio 21\Datawarehouse_Project_SQL\Datasets\source_crm\crm_sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        set @end_time = getdate()
        PRINT '>> Load duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '--------------------------'
        PRINT '-----------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '-----------------------------------';

        -- Table: bronze.erp_cust_az12 (ERP Customer Master)
        set @start_time = getdate()
        PRINT '>> Truncating table : bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Inserting data : bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\nickh\OneDrive\Dokumen\SQL Server Management Studio 21\Datawarehouse_Project_SQL\Datasets\source_erp\erp_CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        set @end_time = getdate()
        PRINT '>> Load duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '--------------------------'

        -- Table: bronze.erp_px_cat_g1v2 (ERP Product Category)
        set @start_time = getdate()
        PRINT '>> Truncating table : bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Inserting data : bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\nickh\OneDrive\Dokumen\SQL Server Management Studio 21\Datawarehouse_Project_SQL\Datasets\source_erp\erp_PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        set @end_time = getdate()
        print '>> Load duration ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' Seconds'
		PRINT '--------------------------'

        -- Table: bronze.erp_loc_a101 (ERP Location Master)
        Set @start_time = getdate()
        PRINT '>> Truncating table : bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;
        PRINT '>> Inserting data : bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\nickh\OneDrive\Dokumen\SQL Server Management Studio 21\Datawarehouse_Project_SQL\Datasets\source_erp\erp_LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        set @end_time = getdate()
        print '>> Load duration ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' Seconds'
		PRINT '--------------------------'

			
        SET @batch_end_time = GETDATE();
        PRINT '===================================';
        PRINT 'Loading Bronze Layer is Completed';
        PRINT ' >> Total Load Duration :' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '===================================';

    END TRY
    BEGIN CATCH
        PRINT '===================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error message : ' + ERROR_MESSAGE();
        PRINT 'Error number  : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error state   : ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '===================================';
    END CATCH
END;




exec bronze.load_bronze


