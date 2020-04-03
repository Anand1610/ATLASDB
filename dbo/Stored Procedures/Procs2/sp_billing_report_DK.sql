CREATE PROCEDURE sp_billing_report_DK

As
BEGIN

DECLARE @year int =2019
DECLARE @month int = 12
-- Report 1 Case Opened Report
SELECT DISTINCT 

	tblcase .Case_Id AS CASE_ID,
	ISNULL(tblcase.InjuredParty_FirstName, N'') + N'  ' + ISNULL(tblcase.InjuredParty_LastName, N'') AS InjuredParty_Name,
	dbo.tblProvider.Provider_Name
	,n.user_ID
	,Status AS [STATUS]
	,Date_Opened
	,(select top 1 nt.[Notes_Date] from [dbo].[tblNotes] nt Where nt.[Case_Id] = tblcase.case_id And nt.[Notes_Desc] Like '%to AAA - FILED%' And year(nt.[Notes_Date])= @year AND month(nt.[Notes_Date])= @month) AS [Case_FILED_Date]
	,isnull(Claim_Amount,0) [Claim_Amount]
	,isnull(paid_amount,0) [Paid_Amount]
	,CONVERT(FLOAT, CLAIM_AMOUNT) - CONVERT(FLOAT, PAID_AMOUNT) AS [CLAIM_BALANCE]
	,(Select COUNT(*) from [dbo].[tblTreatment] T  WHERE T.[Case_Id]= tblcase.Case_Id ) AS BILL_NUMBER_Count
    
	From
	dbo.tblcase  AS tblcase WITH (NOLOCK)
	Inner join [tblNotes]  n (NOLOCK) on n.[Case_Id] =tblcase.case_id
	INNER JOIN dbo.tblProvider WITH (NOLOCK) ON tblcase.Provider_Id = dbo.tblProvider.Provider_Id 

	WHERE n.[Notes_Desc] Like '%Case Opened%' And 
	year(n.[Notes_Date])= @year AND month(n.[Notes_Date])= @month
	And year(Date_Opened)= @year AND month(Date_Opened)= @month
	and tblcase.DomainId like '%DK%'
Order By Date_Opened


End