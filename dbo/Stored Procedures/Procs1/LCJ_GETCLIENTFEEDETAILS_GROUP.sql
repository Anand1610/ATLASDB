CREATE PROCEDURE [dbo].[LCJ_GETCLIENTFEEDETAILS_GROUP] --'289'    
(    
	@dt1 datetime,
	@dt2 datetime,
	@provider_group varchar(50)     
)    
AS    
BEGIN  
DECLARE   
@FEEC MONEY,                                                                                              
@PB FLOAT,                                                                                                                 
@PI FLOAT,                                                                                                                 
@FEEI MONEY,
@FEEPreC MONEY,
@FEEPreCToP MONEY


	--SELECT @FEEC = SUM(TRANSACTIONS_AMOUNT) from tbltransactions A WHERE (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED') 
	--AND TRANSACTIONS_TYPE IN ('C') AND A.PROVIDER_ID=@clientid AND rfund_batch is NULL AND rfund_deposite_number is NULL           
	
	SELECT  @FEEC = SUM(TRANSACTIONS_AMOUNT) from tbltransactions A WHERE Invoice_Id in 
	(select Account_Id from tblclientaccount 
	where Provider_id in (select Provider_Id from tblProvider where Provider_GroupName =@provider_group)
	and cast(floor(convert( float,account_date)) as datetime)>= @dt1
	and cast(floor(convert( float,account_date)) as datetime) <= @dt2)
	and TRANSACTIONS_TYPE IN ('C')  

	
	--IF NOT EXISTS(SELECT Provider_Id FROM tblProviderFinancial WHERE Provider_Id=@CLIENTID)
		--SELECT @FEEPreC = isnull(SUM(TRANSACTIONS_AMOUNT),0.00) from tbltransactions A WHERE (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED') 
		--AND TRANSACTIONS_TYPE IN ('PreC') AND A.PROVIDER_ID=@clientid AND rfund_batch is NULL AND rfund_deposite_number is NULL           
		
	SELECT  @FEEPreC= SUM(TRANSACTIONS_AMOUNT) from tbltransactions A WHERE Invoice_Id in 
	(select Account_Id from tblclientaccount 
	where Provider_id in (select Provider_Id from tblProvider where Provider_GroupName =@provider_group)
	and cast(floor(convert( float,account_date)) as datetime)>= @dt1
	and cast(floor(convert( float,account_date)) as datetime) <= @dt2)
	and TRANSACTIONS_TYPE IN ('PreC')  
		
	
	--SELECT @FEEPreCToP = isnull(SUM(TRANSACTIONS_AMOUNT),0.00) from tbltransactions A WHERE (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED') 
	--	AND TRANSACTIONS_TYPE IN ('PreCToP') AND A.PROVIDER_ID=@clientid AND rfund_batch is NULL AND rfund_deposite_number is NULL           
		
	SELECT  @FEEPreCToP= SUM(TRANSACTIONS_AMOUNT) from tbltransactions A WHERE Invoice_Id in 
	(select Account_Id from tblclientaccount 
	where Provider_id in (select Provider_Id from tblProvider where Provider_GroupName =@provider_group)
	and cast(floor(convert( float,account_date)) as datetime)>= @dt1
	and cast(floor(convert( float,account_date)) as datetime) <= @dt2)
	and TRANSACTIONS_TYPE IN ('PreCToP')  
	
		
	SET @FEEC=ISNULL(@FEEC,0.00) + ISNULL(@FEEPreC,0.00) + ISNULL(@FEEPreCToP,0.00)

	--SELECT @PB = Provider_Billing FROM TBLPROVIDER WHERE PROVIDER_ID=@CLIENTID   
	
	--SELECT @PB = sum(Provider_Billing) FROM TBLPROVIDER WHERE Provider_GroupName =@provider_group
	
	
	SELECT @PB =max(convert(money,Provider_Billing)) FROM TBLPROVIDER WHERE Provider_id in 
	(select Provider_Id from tblclientaccount 
	where Provider_id in (select distinct Provider_Id from tblProvider where Provider_GroupName =@provider_group)
	and cast(floor(convert( float,account_date)) as datetime)>= @dt1
	and cast(floor(convert( float,account_date)) as datetime) <= @dt2)
	
	
	SET @FEEC  =  ISNULL(@FEEC,0.00) * @PB / 100    
	                                                                                 
	--SELECT @FEEI = SUM(TRANSACTIONS_AMOUNT) from tbltransactions A WHERE (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED') 
	--AND TRANSACTIONS_TYPE IN ('I') AND A.PROVIDER_ID=@clientid AND rfund_batch is NULL AND rfund_deposite_number is NULL              
	
	SELECT  @FEEI= SUM(TRANSACTIONS_AMOUNT) from tbltransactions A WHERE Invoice_Id in 
	(select Account_Id from tblclientaccount 
	where Provider_id in (select Provider_Id from tblProvider where Provider_GroupName =@provider_group)
	and cast(floor(convert( float,account_date)) as datetime)>= @dt1
	and cast(floor(convert( float,account_date)) as datetime) <= @dt2)
	and TRANSACTIONS_TYPE IN ('I')  
	

	--SELECT @PI =sum(convert(money,Provider_INTBilling)) FROM TBLPROVIDER WHERE Provider_GroupName =@provider_group 
	
	
	SELECT @PI =max(convert(money,Provider_INTBilling)) FROM TBLPROVIDER WHERE Provider_id in 
	(select Provider_Id from tblclientaccount 
	where Provider_id in (select distinct Provider_Id from tblProvider where Provider_GroupName =@provider_group)
	and cast(floor(convert( float,account_date)) as datetime)>= @dt1
	and cast(floor(convert( float,account_date)) as datetime) <= @dt2)
	
	
	--and Provider_INTBilling <>'False'
	
	SET @FEEI  = ISNULL(@FEEI,0.00)  * @PI /100                                                                                        
	 
	  select ISNULL(@FEEC,0.00) AS FC,ISNULL(@FEEI,0.00) AS IC    

	  
	     

END

