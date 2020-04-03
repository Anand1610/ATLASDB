CREATE PROCEDURE [dbo].[SJR_PENDING_REPORT] @PROVIDER_NAME VARCHAR(50) =NULL

AS

set nocount on
declare @date datetime


BEGIN
set @date=GETDATE()
--INSERT INTO TBLPENDING_AUDIT (CASE_COUNT,PROCESSOR_NAME,DATECREATED)

IF @PROVIDER_NAME IS NULL
BEGIN
SELECT     [SJR-Case_report_Extended].Case_Id, LTRIM(RTRIM(SJR_CASE_PROCESSOR_1.User_Id)) AS User_id, [SJR-Case_report_Extended].Date_Opened, 
                      DATEDIFF(d, [SJR-Case_report_Extended].Date_Opened, GETDATE()) AS Processing_Delay, [SJR-Case_report_Extended].Status, DATEDIFF(d, 
                      [SJR-Case_report_Extended].Date_Status_Changed, GETDATE()) AS Pending_Delay,
                      
                     ( SELECT  TOP(1)   IssueTracker_Users.UserName
FROM         IssueTracker_Users INNER JOIN
                      tblCaseDeskHistory ON IssueTracker_Users.UserId = tblCaseDeskHistory.To_User_Id
                      WHERE tblCaseDeskHistory.Case_Id= [SJR-Case_report_Extended].Case_Id
ORDER BY tblCaseDeskHistory.History_Id DESC) AS ASSIGNED_TO
                      
                      
                      
FROM         dbo.SJR_CASE_PROCESSOR() AS SJR_CASE_PROCESSOR_1 RIGHT OUTER JOIN
                    [SJR-Case_report_Extended] ON  SJR_CASE_PROCESSOR_1.Case_Id = [SJR-Case_report_Extended].Case_Id
WHERE     ([SJR-Case_report_Extended].Status IN ('PENDING', 'AAA PENDING', 'AAA PPO PENDING'))
ORDER BY SJR_CASE_PROCESSOR_1.User_Id, processing_delay DESC
GOTO FINISH
end 




IF @PROVIDER_NAME IS NOT NULL
BEGIN
SELECT     [SJR-Case_report_Extended].Case_Id, LTRIM(RTRIM(SJR_CASE_PROCESSOR_1.User_Id)) AS User_id, [SJR-Case_report_Extended].Date_Opened, 
                      DATEDIFF(d, [SJR-Case_report_Extended].Date_Opened, GETDATE()) AS Processing_Delay, [SJR-Case_report_Extended].Status, DATEDIFF(d, 
                      [SJR-Case_report_Extended].Date_Status_Changed, GETDATE()) AS Pending_Delay,
                      
                     ( SELECT  TOP(1)   IssueTracker_Users.UserName
FROM         IssueTracker_Users INNER JOIN
                      tblCaseDeskHistory ON IssueTracker_Users.UserId = tblCaseDeskHistory.To_User_Id
                      WHERE tblCaseDeskHistory.Case_Id= [SJR-Case_report_Extended].Case_Id
ORDER BY tblCaseDeskHistory.History_Id DESC) AS ASSIGNED_TO
                      
                      
                      
FROM         dbo.SJR_CASE_PROCESSOR() AS SJR_CASE_PROCESSOR_1 RIGHT OUTER JOIN
                    [SJR-Case_report_Extended] ON  SJR_CASE_PROCESSOR_1.Case_Id = [SJR-Case_report_Extended].Case_Id
WHERE     ([SJR-Case_report_Extended].Status IN ('PENDING', 'AAA PENDING', 'AAA PPO PENDING')) AND Provider_Name LIKE '%' + @PROVIDER_NAME  + '%'
ORDER BY SJR_CASE_PROCESSOR_1.User_Id, processing_delay DESC
GOTO FINISH
end 

FINISH:

END

