CREATE PROCEDURE [dbo].[LCJ_GETCLIENTFEEDETAILS] --[LCJ_GETCLIENTFEEDETAILS] '135'    
(    
@DomainId NVARCHAR(50),
@clientid varchar(50)    
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

BEGIN
	SELECT @FEEC = SUM( (A.transactions_amount * P.provider_billing)/100 ) from tbltransactions A, tblcase C, tblprovider P 
   WHERE    A.case_id=C.case_id and C.provider_id=P.provider_id and (TRANSACTIONS_STATUS IS NULL 
   or TRANSACTIONS_STATUS = 'CONFIRMED') AND TRANSACTIONS_TYPE IN ('C','PreC')  AND A.PROVIDER_ID=@clientid  and C.DomainId = @DomainId
   
   SELECT @FEEI = SUM( (A.transactions_amount * P.provider_intbilling)/100 ) from tbltransactions A, tblcase C, tblprovider P
   WHERE   A.case_id=C.case_id and C.provider_id=P.provider_id and (TRANSACTIONS_STATUS IS NULL or 
   TRANSACTIONS_STATUS ='CONFIRMED') AND TRANSACTIONS_TYPE IN ('i') AND A.PROVIDER_ID=@clientid  and C.DomainId = @DomainId
 
   select ISNULL(@FEEC,0.00) AS FC,ISNULL(@FEEI,0.00) AS IC
END

END
