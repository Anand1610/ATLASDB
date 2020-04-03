CREATE PROCEDURE [dbo].[LCJ_SettlementReport]-- [LCJ_SettlementReport] test,6,'40652'
	
	(
		@DomainId NVARCHAR(50),
		@dt int,
		@pro_id NVARCHAR(100)
	)

AS

BEGIN
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
Fee_Schedule money,
DomainId NVARCHAR(50)
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
		,
		tblCase.DomainId
		FROM         dbo.tblInsuranceCompany INNER JOIN
        dbo.tblcase ON dbo.tblInsuranceCompany.InsuranceCompany_Id = dbo.tblcase.InsuranceCompany_Id INNER JOIN
        dbo.tblProvider ON dbo.tblcase.Provider_Id = dbo.tblProvider.Provider_Id INNER JOIN
        dbo.tblSettlements ON dbo.tblcase.Case_Id = dbo.tblSettlements.Case_Id
		where dbo.tblProvider.Provider_Id = @pro_id and datediff(m,settlement_date,getdate())<= @dt and settlement_amount > 0 
		and dbo.tblProvider.DomainId=@DomainId and ISNULL(tblcase.IsDeleted,0) = 0
		GROUP BY dbo.tblSettlements.Case_Id, dbo.tblProvider.Provider_Name, dbo.tblInsuranceCompany.InsuranceCompany_Name, 
                      dbo.tblcase.InjuredParty_LastName + N',' + dbo.tblcase.InjuredParty_FirstName, CONVERT(money, dbo.tblcase.Claim_Amount), 
                      dbo.tblSettlements.User_Id, dbo.tblSettlements.Settlement_Date, dbo.tblProvider.Provider_Id, CONVERT(money, dbo.tblcase.Paid_Amount), 
                      dbo.tblcase.Date_Opened, dbo.tblInsuranceCompany.InsuranceCompany_Id, ISNULL(REPLACE(dbo.tblcase.DateOfService_Start, '12:00AM', '') 
                      + ' - ' + REPLACE(dbo.tblcase.DateOfService_End, '12:00AM', ''), N'N/A'),CONVERT(money, dbo.tblcase.Fee_Schedule),tblCase.DomainId
		having (CONVERT(money, dbo.tblcase.Claim_Amount)-SUM(dbo.tblSettlements.Settlement_Amount)) >=0


--delete #temp where case_id in (select distinct case_id from tblTreatment group by case_id having  (sum(claim_amount)-sum(paid_amount)) = 0)

delete tblreportsettlement
insert into tblreportsettlement(case_id,sett_tot,Provider_Name,InsuranceCompany_Name,InjuredParty_Name,Claim_Amount,User_Id,Settlement_Amount,Settlement_Int,Settlement_Af,Settlement_Ff,Settlement_Date,Settlement_Notes,Provider_Id,Settlement_Total,Paid_amount,Date_Opened,InsuranceCompany_Id,DOS,Fee_Schedule,DomainId)
select * from #temp 

--select * from tblreportsettlement
END
