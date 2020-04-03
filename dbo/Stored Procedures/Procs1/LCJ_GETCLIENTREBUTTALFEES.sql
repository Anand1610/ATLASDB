

CREATE PROCEDURE [dbo].[LCJ_GETCLIENTREBUTTALFEES] 
	-- Add the parameters for the stored procedure here
	@DomainId NVARCHAR(50),
	@Client_id nvarchar(50)
	AS
	BEGIN
	Select ISNULL(SUM(ISNULL(TRANSACTIONS_AMOUNT,0.00)),0.00) as REBUTTALFEES
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
	 AND ISNULL(TRANSACTIONS_STATUS,'')<>'FREEZED'
	 AND TRANSACTIONS_TYPE IN ('RFB')   

END
