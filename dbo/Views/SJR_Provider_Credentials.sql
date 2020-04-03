CREATE VIEW [dbo].[SJR_Provider_Credentials]
as
SELECT     tblProvider.Provider_Name, IssueTracker_Users.UserName,IssueTracker_Users.UserPassword
FROM         IssueTracker_Users INNER JOIN
                      tblProvider ON IssueTracker_Users.UserTypeLogin = convert(varchar(50),tblProvider.Provider_Id)
