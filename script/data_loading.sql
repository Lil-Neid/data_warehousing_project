truncate table bronze.crm_cust_info;
bulk insert bronze.crm_cust_info;
from 'Your file directory'
with (
	firstrow = 2 ,
	fieldterminator = ',',
	tablock
);

truncate table bronze.crm_prd_info;
bulk insert bronze.crm_prd_info;
from 'Your file directory'
with (
	firstrow = 2 ,
	fieldterminator = ',',
	tablock
);

truncate table bronze.crm_sales_details;
bulk insert bronze.crm_sales_details;
from 'Your file directory'
with (
	firstrow = 2 ,
	fieldterminator = ',',
	tablock
);
--=================================================

truncate table bronze.erp_cust_az12;
bulk insert bronze.erp_cust_az12;
from 'Your file directory'
with (
	firstrow = 2 ,
	fieldterminator = ',',
	tablock
);


truncate table bronze.erp_px_cat_g1v2;
bulk insert bronze.erp_px_cat_g1v2;
from 'Your file directory'
with (
	firstrow = 2 ,
	fieldterminator = ',',
	tablock
);


truncate table bronze.erp_loc_a101;
bulk insert bronze.erp_loc_a101;
from 'Your file directory'
with (
	firstrow = 2 ,
	fieldterminator = ',',
	tablock

);
