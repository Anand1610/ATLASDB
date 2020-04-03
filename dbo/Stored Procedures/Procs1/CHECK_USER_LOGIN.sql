CREATE PROCEDURE [dbo].[CHECK_USER_LOGIN]
	@SZ_USER_NAME nvarchar(20),
	@SZ_PASS_CODE nvarchar(20)
as
	Select 
		USERNAME 
	From
		dbo.IssueTracker_Users
	Where 
		USERNAME=@SZ_USER_NAME
		AND USERPASSWORD=@SZ_PASS_CODE

