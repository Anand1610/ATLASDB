CREATE PROCEDURE [dbo].[Report_Menu_Retrive]  --[LCJ_GetRoleMenuList] 'priya','admin'
		@DomainId NVARCHAR(50),
		@UserName nvarchar(50)
AS
BEGIN
	Declare @RoleId int 
	
		Set @RoleId=(Select RoleId From dbo.IssueTracker_Users Where UserName=@UserName and DomainId=@DomainId)

		-- SELECT * From tblMenu_Report
		Select ReportMenuID, MenuName,(MenuLink) as MenuLink,Description, ParentID from tblMenu_Report 
		where ReportMenuID in (Select ReportMenuID From tblMenu_Report_Access Where RoleId=@RoleId )
		
		
END

