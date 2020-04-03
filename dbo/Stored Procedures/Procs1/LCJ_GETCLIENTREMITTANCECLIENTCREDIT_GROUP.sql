CREATE PROCEDURE [dbo].[LCJ_GETCLIENTREMITTANCECLIENTCREDIT_GROUP]      
(      
	@dt1 datetime,
	@dt2 datetime,
	@provider_group varchar(50)        
)      
AS  
BEGIN 
	select
		tbltransactions.Case_Id, Provider_name,
		ISNULL(dbo.tblcase.InjuredParty_FirstName, N'') + N'  ' + ISNULL(dbo.tblcase.InjuredParty_LastName, N'') AS InjuredParty_Name, 
		dbo.tblcase.Accident_Date,
		CONVERT(varchar(12), dbo.tblcase.DateOfService_Start, 1) AS DateOfService_Start, 
		CONVERT(varchar(12), dbo.tblcase.DateOfService_End, 1) AS DateOfService_End,
		ISNULL(CONVERT(MONEY,ISNULL(tblcase.CLAIM_AMOUNT,0.00))-CONVERT(MONEY,ISNULL(tblcase.PAID_AMOUNT,0.00)),0.00) AS CLAIM_AMOUNT,
		TRANSACTIONS_TYPE,
		TRANSACTIONS_DESCRIPTION,
		TRANSACTIONS_AMOUNT,
		TRANSACTIONS_Fee,
		TRANSACTIONS_dATE,
		INDEXORAAA_NUMBER
	 from tbltransactions 
	 inner join tblcase on tblcase.Case_Id = tblTransactions.Case_Id
	 inner join tblProvider on tblcase.Provider_Id = tblProvider.Provider_Id
	WHERE Invoice_Id in 
	(select Account_Id from tblclientaccount 
	where Provider_id in (select Provider_Id from tblProvider where Provider_GroupName =@provider_group)
	and cast(floor(convert( float,account_date)) as datetime)>= @dt1
	and cast(floor(convert( float,account_date)) as datetime) <= @dt2)
	AND TRANSACTIONS_TYPE IN ('CRED')    
END

