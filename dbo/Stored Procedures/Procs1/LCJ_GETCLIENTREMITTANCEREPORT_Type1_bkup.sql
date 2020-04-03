
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LCJ_GETCLIENTREMITTANCEREPORT_Type1_bkup] 
	-- Add the parameters for the stored procedure here
	@DomainId NVARCHAR(50),
	@Client_id nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select distinct B.provider_id
	,A.Transactions_Id
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
			 WHEN TRANSACTIONS_TYPE IN ('PreI') 
				THEN ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT * ISNULL(Provider_IntBilling,1) /100 )),0.00)
			  WHEN TRANSACTIONS_TYPE IN ('ID') 
				THEN ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT * ISNULL(Provider_IntBilling,1) /100 )),0.00)
		   WHEN TRANSACTIONS_TYPE IN ('I')  AND  B.Case_Id Like 'ACT%'
				THEN ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT *  ISNULL(Provider_Initial_IntBilling,1)/100 )),0.00)
		   WHEN TRANSACTIONS_TYPE IN ('I') 
				THEN ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT * ISNULL(Provider_IntBilling,1) /100 )),0.00) END as TRANSACTIONS_fee
	, A.TRANSACTIONS_DATE
	,CASE 
	WHEN TRANSACTIONS_TYPE IN ('PreC')
	THEN 'Voluntary'
	WHEN TRANSACTIONS_TYPE IN ('PreCToP')
	THEN 'Voluntary (Direct)'
	 WHEN TRANSACTIONS_TYPE IN ('PreI')
	 THEN 'Voluntary Interest'
	 WHEN TRANSACTIONS_TYPE IN ('ID')
	 THEN 'Voluntary Interest (Direct)'
	  WHEN TRANSACTIONS_TYPE IN ('C') AND sety.Settlement_Type IN ('Settled/Court','Settled/Phone','Settled in Arb Conciliation')
	  THEN 'Settlement'
	   WHEN TRANSACTIONS_TYPE IN ('C') AND sety.Settlement_Type NOT IN ('Settled/Court','Settled/Phone','Settled in Arb Conciliation')
	  THEN 'Awarded'
	   WHEN TRANSACTIONS_TYPE IN ('I') AND sety.Settlement_Type IN ('Settled/Court','Settled/Phone','Settled in Arb Conciliation')
	  THEN 'Settlement Interest'
	   WHEN TRANSACTIONS_TYPE IN ('I') AND sety.Settlement_Type NOT IN ('Settled/Court','Settled/Phone','Settled in Arb Conciliation')
	  THEN 'Awarded Interest'
	 END AS TRANSACTIONS_dESCRIPTION
	--, ISNULL(A.ChequeNo,'')  + ISNULL(A.TRANSACTIONS_dESCRIPTION    ,'') as TRANSACTIONS_dESCRIPTION
	, A.TRANSACTIONS_ID
	, CASE 	   
		   WHEN Vendor_Fee_Type ='Flat Fee' 
		   AND Transactions_Id =(select Top 1 Transactions_Id from tblTransactions where Case_Id=A.Case_Id AND Transactions_Type IN ('PreC','C','PreCToP','PreI','ID','I') AND (A.Case_Id NOT IN (Select Case_Id from tblTransactions where Transactions_status='FREEZED' AND Transactions_Type IN ('PreC','C','PreCToP','PreI','ID','I')))  AND (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED') order by Transactions_Id )
		   THEN 			
				ISNULL(Vendor_Fee,0.00)
				
			WHEN Vendor_Fee_Type ='%' 
			AND Transactions_Id =(select Top 1 Transactions_Id from tblTransactions where Case_Id=A.Case_Id AND Transactions_Type IN ('PreC','C','PreCToP','PreI','ID','I') AND (A.Case_Id NOT IN (Select Case_Id from tblTransactions where Transactions_status='FREEZED' AND Transactions_Type IN ('PreC','C','PreCToP','PreI','ID','I')))  AND (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED') order by Transactions_Id )
			THEN 
				ISNULL(ABS(ISNULL(convert(money,(A.TRANSACTIONS_AMOUNT * ISNULL(Vendor_Fee,0.00) /100 )),0.00)),0.00)
			
			WHEN Vendor_Fee_Type ='Slab Based'
			THEN
				ISNULL( case when (select top 1 AmountType from tblprovider_slabs where providerid = B.Provider_id)=0 then 
				  (select  ISNULL(Vendorfee,0.00) from tblprovider_slabs where providerid = B.Provider_id 
				 and settlement_amount > = slabfrom and settlement_amount <= slabto 
				 )
				 else
				 (select ISNULL(Vendorfee,0.00) from tblprovider_slabs where providerid = B.Provider_id 
				 and Claim_Amount > = slabfrom and Claim_Amount <= slabto 
				 ) end ,0.00)

			WHEN Vendor_Fee_Type IS NULL
				THEN
				0.00
				ELSE
				0.00
				END AS  VENDOR_FEE
	--, Initial_Status
	--, Provider_Initial_Billing
	from tbltransactions (NOLOCK) A 
	
	inner join tblcase (NOLOCK) B ON A.Case_Id = B.Case_Id   
	inner join tblprovider (NOLOCK) C on C.Provider_Id=B.Provider_Id 
	inner join tblInsuranceCompany (NOLOCK) ins on ins.InsuranceCompany_Id = B.InsuranceCompany_Id 
	LEFT JOIN tblSettlements (NOLOCK) Sett ON sett.Case_Id=A.Case_Id
	LEFT JOIN tblSettlement_Type (NOLOCK) Sety ON sety.SettlementType_Id=sett.Settled_Type  
	WHERE A.PROVIDER_ID=@Client_id 
	AND 
	(TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED')  
	 and B.DomainId=@DomainId  
	AND TRANSACTIONS_TYPE IN ('C','I','PreC','PreCToP','PreI','ID')    
	--AND A.PROVIDER_ID=@clientid    
	--ORDER BY TRANSACTIONS_DATE  
END

