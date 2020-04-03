CREATE PROCEDURE [dbo].[CheckUserSession]
@AutoID int 
AS
select top 1 AutoId from IssueTracker_Users_LoginTime 
where AutoID=@AutoID and datediff(minute,  Login_Time, getdate()) <=60 and LogOut_Time is null

order by 1 desc
