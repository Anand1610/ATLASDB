CREATE PROCEDURE [dbo].[LCJ_SettlementReport_ProvGroup]-- [LCJ_SettlementReport_ProvGroup] '6','JACK'
	
	(
		@DomainId NVARCHAR(50),
		@dt int,
		@pro_GroupName NVARCHAR(100)
	)

AS
--Declare @pro_id as nvarchar(100)
BEGIN
--set @pro_id =(select provider_Id from tblprovider where provider_GroupName='CB')
--select provider_name from tblprovider where provider_id in('40663','40664','40665','40668','40669','40670','40671','40672','40674')

create table #temp
(
case_id nvarchar(100),
sett_tot money,
Provider_Name nvarchar(100),
InsuranceCompany_Name nvarchar(100),
InjuredParty_Name nvarchar(100),
Claim_Amount money,
User_Id nvarchar(100),
Settlement_Amount money,
Settlement_Int money,
Settlement_Af money,
Settlement_Ff money,
Settlement_Date  datetime,
Settlement_Notes nvarchar(2000),
Provider_Id  nvarchar(20),
Settlement_Total money,
Paid_amount money,
Date_Opened datetime,
InsuranceCompany_Id  nvarchar(20),
DOS nvarchar(200),
Fee_Schedule money
 )
insert into #temp
	SELECT     dbo.tblSettlements.Case_Id, SUM(dbo.tblSettlements.Settlement_Amount + dbo.tblSettlements.Settlement_Int) AS Sett_tot, 
        dbo.tblProvider.Provider_Name, dbo.tblInsuranceCompany.InsuranceCompany_Name, 
        dbo.tblcase.InjuredParty_LastName + N',' + dbo.tblcase.InjuredParty_FirstName AS InjuredParty_Name, CONVERT(money, dbo.tblcase.Claim_Amount) 
        AS Claim_Amount, dbo.tblSettlements.User_Id, SUM(dbo.tblSettlements.Settlement_Amount) AS Settlement_Amount, 
        SUM(dbo.tblSettlements.Settlement_Int) AS Settlement_Int, SUM(dbo.tblSettlements.Settlement_Af) AS Settlement_Af, 
        SUM(dbo.tblSettlements.Settlement_Ff) AS Settlement_Ff, dbo.tblSettlements.Settlement_Date, MAX(dbo.tblSettlements.Settlement_Notes) 
        AS Settlement_Notes, dbo.tblProvider.Provider_Id, SUM(dbo.tblSettlements.Settlement_Amount + dbo.tblSettlements.Settlement_Int) 
        AS Settlement_Total, CONVERT(money, dbo.tblcase.Paid_Amount) AS Paid_amount, dbo.tblcase.Date_Opened, 
        dbo.tblInsuranceCompany.InsuranceCompany_Id, ISNULL(REPLACE(dbo.tblcase.DateOfService_Start, '12:00AM', '') 
        + ' - ' + REPLACE(dbo.tblcase.DateOfService_End, '12:00AM', ''), N'N/A') AS DOS,CONVERT(money, dbo.tblcase.Fee_Schedule) as Fee_Schedule
		FROM         dbo.tblInsuranceCompany INNER JOIN
        dbo.tblcase ON dbo.tblInsuranceCompany.InsuranceCompany_Id = dbo.tblcase.InsuranceCompany_Id INNER JOIN
        dbo.tblProvider ON dbo.tblcase.Provider_Id = dbo.tblProvider.Provider_Id INNER JOIN
        dbo.tblSettlements ON dbo.tblcase.Case_Id = dbo.tblSettlements.Case_Id
		where dbo.tblProvider.Provider_Id in (select provider_Id 
											from tblprovider 
											where provider_GroupName=@pro_GroupName and DomainId=@DomainId) 
		and datediff(m,settlement_date,getdate())<= @dt 
		and settlement_amount > 0 
		and tblcase.DomainId=@DomainId
		GROUP BY dbo.tblSettlements.Case_Id, dbo.tblProvider.Provider_Name, dbo.tblInsuranceCompany.InsuranceCompany_Name, 
                      dbo.tblcase.InjuredParty_LastName + N',' + dbo.tblcase.InjuredParty_FirstName, CONVERT(money, dbo.tblcase.Claim_Amount), 
                      dbo.tblSettlements.User_Id, dbo.tblSettlements.Settlement_Date, dbo.tblProvider.Provider_Id, CONVERT(money, dbo.tblcase.Paid_Amount), 
                      dbo.tblcase.Date_Opened, dbo.tblInsuranceCompany.InsuranceCompany_Id, ISNULL(REPLACE(dbo.tblcase.DateOfService_Start, '12:00AM', '') 
                      + ' - ' + REPLACE(dbo.tblcase.DateOfService_End, '12:00AM', ''), N'N/A'),CONVERT(money, dbo.tblcase.Fee_Schedule)
		having (CONVERT(money, dbo.tblcase.Claim_Amount)-SUM(dbo.tblSettlements.Settlement_Amount)) >0


--delete #temp where case_id in (select distinct case_id from tblTreatment group by case_id having  (sum(claim_amount)-sum(paid_amount)) = 0)

delete tblreportsettlement
insert into tblreportsettlement
select * from #temp

END

