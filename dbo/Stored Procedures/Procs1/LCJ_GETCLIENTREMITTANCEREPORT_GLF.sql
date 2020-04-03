CREATE PROCEDURE [dbo].[LCJ_GETCLIENTREMITTANCEREPORT_GLF] -- [LCJ_GETCLIENTREMITTANCEREPORT_GLF] 'glf'  ,'1273'
(    
	@DomainId NVARCHAR(50),
	@invoice_id nvarchar(50)	
	--@clientid varchar(50)    
)    
AS
BEGIN     
	select distinct B.provider_id
	, C.provider_name, dbo.fncGetAccountNumber(B.CASE_ID) as ACT_NO
	, B.CASE_ID,B.CASE_CODE,B.InjuredParty_FirstName + ' ' +B.InjuredParty_LastName[INJUREDPARTY_NAME]
	, ins.INSURANCECOMPANY_NAME
	, B.ACCIDENT_DATE
	, B.DATEOFSERVICE_START
	, B.DATEOFSERVICE_END
	, ISNULL(B.FEE_SCHEDULE,0.00) AS FEE_sCHEDULE
	, CASE WHEN  B.Case_Id Like 'ACT%'  THEN CONVERT(MONEY,ISNULL(B.CLAIM_AMOUNT,0.00))
		   ELSE ISNULL(CONVERT(MONEY,ISNULL(B.CLAIM_AMOUNT,0.00))-CONVERT(MONEY,ISNULL(B.PAID_AMOUNT,0.00)),0.00) END AS CLAIM_AMOUNT
	, A.TRANSACTIONS_TYPE
	, A.TRANSACTIONS_AMOUNT --A.TRANSACTIONS_fee,
	, CASE 	   
		   WHEN TRANSACTIONS_TYPE IN ('PreC') 
				THEN ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT * ISNULL(Provider_Initial_Billing,1) /100 )),0.00)
		   WHEN TRANSACTIONS_TYPE IN ('PreCToP') 
				THEN ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT * ISNULL(Provider_Initial_Billing,1) /100 )),0.00)
		   WHEN TRANSACTIONS_TYPE IN ('C')
				THEN ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT * ISNULL(Provider_Billing,1) /100 )),0.00)
				--when Transactions_Type in ('EXP')
				--then isnull(convert(money,(A.TRANSACTIONS_AMOUNT * 1)),0.00)
			--when  Transactions_Type in ('CRED')
			--then isnull(convert(money,(A.TRANSACTIONS_AMOUNT * -1)),0.00)
		   WHEN TRANSACTIONS_TYPE IN ('I')  AND  B.Case_Id Like 'ACT%'
				THEN ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT *  ISNULL(Provider_Initial_IntBilling,1)/100 )),0.00)
		   WHEN TRANSACTIONS_TYPE IN ('I') 
				THEN ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT * ISNULL(Provider_IntBilling,1) /100 )),0.00) END as TRANSACTIONS_fee
	, A.TRANSACTIONS_DATE
	, ISNULL(A.ChequeNo,'')  + ISNULL(A.TRANSACTIONS_dESCRIPTION    ,'') as TRANSACTIONS_dESCRIPTION
	, A.TRANSACTIONS_ID
	--, Initial_Status
	--, Provider_Initial_Billing
	from tbltransactions A 
	inner join tblcase B ON A.Case_Id = B.Case_Id   
	inner join tblprovider C on C.Provider_Id=B.Provider_Id 
	inner join tblInsuranceCompany ins on ins.InsuranceCompany_Id = B.InsuranceCompany_Id   
	WHERE Invoice_Id = @invoice_id--(TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED')  
	 and B.DomainId=@DomainId  
	AND TRANSACTIONS_TYPE IN ('C','I','PreC')    
	--AND A.PROVIDER_ID=@clientid    
	--ORDER BY TRANSACTIONS_DATE  
END

