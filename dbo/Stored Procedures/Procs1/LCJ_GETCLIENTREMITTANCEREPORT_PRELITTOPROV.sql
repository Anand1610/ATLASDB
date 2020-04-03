CREATE PROCEDURE [dbo].[LCJ_GETCLIENTREMITTANCEREPORT_PRELITTOPROV] --'40558'    
(    
	@DomainId NVARCHAR(50),
	@clientid varchar(50)    
)    
AS
BEGIN   

    
	select distinct B.provider_id
		, C.provider_name
		, B.CASE_ID
		, B.CASE_CODE
		, B.InjuredParty_FirstName + ' ' +B.InjuredParty_LastName[INJUREDPARTY_NAME]
		, ins.INSURANCECOMPANY_NAME,B.ACCIDENT_DATE
		, B.DATEOFSERVICE_START
		, B.DATEOFSERVICE_END
		, ISNULL(CONVERT(MONEY,ISNULL(B.CLAIM_AMOUNT,0.00))-CONVERT(MONEY,ISNULL(B.PAID_AMOUNT,0.00)),0.00) AS CLAIM_AMOUNT
		, A.TRANSACTIONS_TYPE
		, A.TRANSACTIONS_AMOUNT
		, A.TRANSACTIONS_DATE
		, A.TRANSACTIONS_dESCRIPTION
		, A.TRANSACTIONS_ID
	from tbltransactions A 
	inner join tblcase B ON A.Case_Id = B.Case_Id   
	inner join tblprovider C on C.Provider_Id=B.Provider_Id 
	inner join tblInsuranceCompany ins on ins.InsuranceCompany_Id=B.InsuranceCompany_Id   
	WHERE (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED')    
	AND TRANSACTIONS_TYPE IN ('PreCToP')    
	AND A.PROVIDER_ID=@clientid    
	AND B.DomainId=@DomainId

	ORDER BY TRANSACTIONS_DATE  
END

