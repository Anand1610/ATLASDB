
CREATE PROCEDURE [dbo].[F_AAAPendingCases]   --[F_AAAPendingCases] 
AS
BEGIN
	SET NOCOUNT ON;

		select DISTINCT cas.Case_Id AS [Case_ID],
		Initial_Status AS [Case_Status],
		status AS [Current_Status],
		ISNULL(cas.InjuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InjuredParty_LastName, N'') as  [Patient_Name],
		provider_name AS [Provider],
		Provider_GroupName AS [Provider_Group],
		InsuranceCompany_Name AS [Insurance_Company],
		LTRIM(RTRIM(N.User_Id)) AS [Case_Opener],
		Date_Opened AS [Date_Opened],
		(select max(UserName) from tblCaseDeskHistory (NOLOCK) INNER JOIN IssueTracker_Users (NOLOCK) ON To_User_Id = UserId 
		WHERE bt_status = 1 AND Case_Id=cas.Case_ID) AS [Work_Desk_Assigned_Name],
		Assigned_Attorney AS [Attorney_assigned],
		CASE WHEN date_status_changed is null then  datediff(dd,Date_Opened,GETDATE())  ELSE datediff(dd,date_status_changed,GETDATE()) END AS [Status_Age]
		from tblcase  cas (NOLOCK) 
		INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON cas.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
		INNER JOIN dbo.tblProvider WITH (NOLOCK) ON cas.Provider_Id = dbo.tblProvider.Provider_Id 
		INNER JOIN tblNotes  N (NOLOCK) on N.Case_Id = cas.Case_Id and N.Notes_Desc = 'Case Opened'

		where  Status like 'AAA Package Incomplete%' AND ISNULL(cas.IsDeleted,0) = 0
		  SET NOCOUNT OFF;
END

