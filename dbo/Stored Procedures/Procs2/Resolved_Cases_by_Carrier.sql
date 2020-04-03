CREATE PROCEDURE [dbo].[Resolved_Cases_by_Carrier]
@DomainId VARCHAR(50),
@ProviderId int = ''
AS
BEGIN

SELECT TOP 10  InsuranceCompany_Name, 
		count(c.Case_Id) as Case_count,
		sum(c.Fee_Schedule) as Fee_Schedule_Amt,
		sum(cast(s.Settlement_Amount as numeric(18,2))) as Sum_Of_Settlement 
FROM	[dbo].[tblcase] c join [dbo].[tblInsuranceCompany] i on c.InsuranceCompany_Id = i.InsuranceCompany_Id 
join	[dbo].[tblSettlements] s on c.Case_Id =s.Case_Id   
where	c.Status='CLOSED' and  c.DomainId=@DomainId  
         AND (@ProviderId = '' or Provider_Id = @ProviderId)
Group By i.InsuranceCompany_Name 
order by i.InsuranceCompany_Name;

END



