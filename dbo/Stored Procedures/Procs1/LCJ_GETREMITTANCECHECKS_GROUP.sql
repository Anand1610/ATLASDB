
CREATE PROCEDURE [dbo].[LCJ_GETREMITTANCECHECKS_GROUP] -- [LCJ_GETREMITTANCECHECKS_GROUP]'2/9/2012','2/9/2013'

(
@DomainId NVARCHAR(50),
@dt1 datetime,
@dt2 datetime
)
as
begin

	select
		TPG.Provider_Group_ID AS ID,
		TPG.Provider_Group_Name,
		sum(GROSS_AMOUNT) as GROSS_AMOUNT,
		SUM(FIRM_FEES) as FIRM_FEES,
		SUM(FINAL_REMIT) as FINAL_REMIT ,
		MAX(account_id) as account_id,
		MAX(account_date) as account_date,
		sum(GROSS_AMOUNT)-SUM(FINAL_REMIT) AS FIRM_REMIT_AMOUNT
		
	from tblprovider a 
	inner JOIN TblProvider_Groups TPG on a.Provider_GroupName = TPG.Provider_Group_Name
	inner join tblclientaccount b on a.provider_id=b.provider_id 
	where TPG.Provider_Group_Name <> '' and
	cast(floor(convert( float,b.account_date)) as datetime)>= @dt1 and cast(floor(convert( float,b.account_date)) as datetime) <= @dt2
	and a.DomainId=@DomainId
	GROUP BY TPG.Provider_Group_Name,Provider_Group_ID
	
	
	--select * from TblProvider_Groups
	--select * from tblprovider
	--LEFT OUTER JOIN TblProvider_Groups on tblProvider.Provider_GroupName = TblProvider_Groups.ID
	
--	select * from tblclientaccount where Account_Id ='7598'
END

