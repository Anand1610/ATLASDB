CREATE PROCEDURE [dbo].[F_Get_PaymentProRpt]   --[dbo].[F_Get_PaymentProRpt] '1/1/2014','1/31/2014','NSLIJ'    
(
	@DomainId NVARCHAR(50),
	@s_l_fromdate DATETIME,
	@s_l_todate DATETIME,
	@provider_Group VARCHAR(50)=null
)
AS  
BEGIN


	select
		sum(GROSS_AMOUNT) as GROSS_AMOUNT,
		SUM(FIRM_FEES) as FIRM_FEES,
		SUM(FINAL_REMIT) as FINAL_REMIT ,
		sum(GROSS_AMOUNT) - SUM(FINAL_REMIT) AS FIRM_REMIT_AMOUNT,
		(select SUM(transactions_Amount)  AS  transactions_Amount from tblTransactions
		where provider_id in (select Provider_Id from TblProvider where provider_groupname like '%'+ ISNULL(@provider_Group,'') +'%')
		AND CAST(FLOOR(CONVERT(FLOAT,Transactions_Date)) AS DATETIME)>= @s_l_fromdate and CAST(FLOOR(CONVERT( FLOAT,Transactions_Date)) AS DATETIME) <= @s_l_todate 
		and Transactions_Type = 'AF') AS AF_Fee
	from tblprovider a 
	LEFT OUTER JOIN TblProvider_Groups TPG on a.Provider_GroupName = TPG.Provider_Group_Name
	inner join tblclientaccount b on a.provider_id=b.provider_id 
	where TPG.Provider_Group_Name <> '' and
	cast(floor(convert( float,b.account_date)) as datetime)>= @s_l_fromdate and cast(floor(convert( float,b.account_date)) as datetime) <= @s_l_todate
	AND TPG.Provider_Group_Name like '%'+ ISNULL(@provider_Group,'') +'%' and a.DomainId=@DomainId
	--GROUP BY TPG.ID	
END

