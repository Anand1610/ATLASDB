CREATE PROCEDURE [dbo].[LCJ_GETCLIENTREMITTANCEREPORT_BY_GROUP] --[LCJ_GETCLIENTREMITTANCEREPORT_BY_GROUP] @dt1='2/18/2012',@dt2='2/18/2013',@provider_group='NSLIJ'
(    
	@dt1 datetime,
	@dt2 datetime,
	@provider_group varchar(50)   
)    
AS
BEGIN   
	select
		a.Case_Id, Provider_name,
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
		af_show,
		(select top 1 account_number from tblTreatment where Case_Id = a.case_id) as account_number
	 from tbltransactions a
	 inner join tblcase on tblcase.Case_Id = a.Case_Id
	 inner join tblProvider on tblcase.Provider_Id = tblProvider.Provider_Id
	 LEFT OUTER join TblProvider_Groups on TblProvider_Groups.Provider_Group_Name =TblProvider.Provider_GroupName
	WHERE Invoice_Id in 
	(select Account_Id from tblclientaccount 
	where Provider_id in (select Provider_Id from tblProvider where Provider_GroupName =@provider_group)
	and cast(floor(convert( float,account_date)) as datetime)>= @dt1
	and cast(floor(convert( float,account_date)) as datetime) <= @dt2)
	and TRANSACTIONS_TYPE IN ('C','I','PreC')  
	

	
END

