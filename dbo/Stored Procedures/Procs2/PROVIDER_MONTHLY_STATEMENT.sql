
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PROVIDER_MONTHLY_STATEMENT] -- [PROVIDER_MONTHLY_STATEMENT] 'glf'
	@s_a_DomainId Varchar(50)--,
	-- @s_a_Transaction_Type varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Select distinct 
	   B.provider_id
	 , C.provider_name
	 , dbo.fncGetAccountNumber(B.CASE_ID) as ACT_NO
	 , B.CASE_ID
	 , B.CASE_CODE
	 , B.InjuredParty_FirstName + ' ' +B.InjuredParty_LastName[INJUREDPARTY_NAME]
	 , ins.INSURANCECOMPANY_NAME
	 , CONVERT(VARCHAR(10), B.ACCIDENT_DATE, 101) As ACCIDENT_DATE
	 , CONVERT(VARCHAR(10), B.DATEOFSERVICE_START, 101) As DATEOFSERVICE_START
	 , CONVERT(VARCHAR(10), B.DATEOFSERVICE_END, 101) As DATEOFSERVICE_END
	 , ISNULL(B.FEE_SCHEDULE,0.00) AS FEE_SCHEDULE
	 , B.INDEXORAAA_NUMBER
	 --, ISNULL(CONVERT(MONEY,ISNULL(B.CLAIM_AMOUNT,0.00))-CONVERT(MONEY,ISNULL(B.PAID_AMOUNT,0.00)),0.00) AS CLAIM_AMOUNT
	 , CASE WHEN  B.Case_Id LIKE 'ACT%'  THEN CONVERT(MONEY,ISNULL(B.CLAIM_AMOUNT,0.00))
		   ELSE ISNULL(CONVERT(MONEY,ISNULL(B.CLAIM_AMOUNT,0.00))-CONVERT(MONEY,ISNULL(B.PAID_AMOUNT,0.00)),0.00) END AS CLAIM_AMOUNT
	 , CASE WHEN  B.Case_Id LIKE 'ACT%'  THEN CONVERT(MONEY,ISNULL(B.CLAIM_AMOUNT,0.00))
		   ELSE ISNULL(CONVERT(MONEY,ISNULL(B.Fee_Schedule,0.00))-CONVERT(MONEY,ISNULL(B.PAID_AMOUNT,0.00)),0.00) END AS CLAIM_AMOUNT
	 , A.TRANSACTIONS_TYPE
	 , A.TRANSACTIONS_AMOUNT
	, CASE WHEN TRANSACTIONS_TYPE IN ('PreC')
				THEN ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT *  ISNULL(Provider_Initial_Billing,1)/100 )),0.00)
		   WHEN TRANSACTIONS_TYPE IN ('C')
				THEN ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT * ISNULL(Provider_Billing,1) /100 )),0.00)
		   WHEN TRANSACTIONS_TYPE IN ('I')  AND B.Case_ID Like'ACT%' 
				THEN ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT *  ISNULL(Provider_Initial_IntBilling,1)/100 )),0.00)
		   WHEN TRANSACTIONS_TYPE IN ('I')
				THEN ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT * ISNULL(Provider_IntBilling,1) /100 )),0.00) END as TRANSACTIONS_fee
	-- , A.TRANSACTIONS_fee
	 , CONVERT(VARCHAR(10), A.TRANSACTIONS_DATE, 101) As TRANSACTIONS_DATE
	 , A.TRANSACTIONS_dESCRIPTION
	 , A.TRANSACTIONS_ID
	 --,  CASE WHEN ISNULL(Email_For_Monthly_Report,'') <> '' THEN Email_For_Monthly_Report
	--		WHEN ISNULL(Provider_Email,'') <> '' THEN Provider_Email
	--		ELSE '' END Provider_Email
	 , 'prikale29@gmail.com' AS Provider_Email 
	 ,  cost_balance 
	 , Provider_local_Address
	 , Provider_Local_City
	 , Provider_Local_State
	 , Provider_Local_Zip
	 , Provider_Local_Phone
	 , UPPER(C.Invoice_Type) As Invoice_Type 
	 from tbltransactions A 
	 inner join tblcase B ON A.Case_Id = B.Case_Id   
	 inner join tblprovider C  on C.Provider_Id=B.Provider_Id 
	 inner join tblInsuranceCompany ins on ins.InsuranceCompany_Id=B.InsuranceCompany_Id   
	 WHERE 
	 B.DomainId=@s_a_DomainId  
	 AND  TRANSACTIONS_TYPE IN ('C','I','PreC','ProCToPro','FFB','CRED','EXPF','EXPP','EXPC')
	 AND  Transactions_Date between DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0) and
			 DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)
	 AND B.Case_Id <> 'GLF18-100001'
	 ORDER BY TRANSACTIONS_DATE  
END
