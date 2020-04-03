CREATE PROCEDURE [dbo].[F_ArbFiledCases] --[F_ArbFiledCases] '01/01/2014' , '01/25/2014'
	
(
	@from_date varchar(500),
	@to_date varchar(200)
)
AS
DECLARE @strsql as varchar(8000)
BEGIN
	SET NOCOUNT ON;

		select DISTINCT C.Case_Id AS [Case_ID],
		Initial_Status AS [Case_Status],
		status AS [Current_Status],
		ISNULL(C.InjuredParty_FirstName, N'') + N'  ' + ISNULL(C.InjuredParty_LastName, N'')  as  [Patient_Name],
		provider_name AS [Provider],
		Provider_GroupName AS [Provider_Group],
		InsuranceCompany_Name AS [Insurance_Company],
		convert(varchar,Date_AAA_Arb_Filed,101) AS [AAA_FILED_Date]
		from tblCASe C with(nolock)  
		INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON C.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id   
        INNER JOIN dbo.tblProvider WITH (NOLOCK) ON C.Provider_Id = dbo.tblProvider.Provider_Id   
		WHERE Date_AAA_Arb_Filed BETWEEN @from_date AND @to_date AND ISNULL(C.IsDeleted,0) = 0 
		ORDER BY [AAA_FILED_Date]

		SET NOCOUNT OFF;

		
END

