 

CREATE PROCEDURE [dbo].[Report_Menu_Access_Save] 
(
	@s_a_DomainID nvarchar(50),
	@i_a_roleid int,
	@s_a_ReportMenuid varchar(4000),
	@s_a_Created_By_User varchar(100)
)
as
BEGIN
	DECLARE @s_l_notes_desc	VARCHAR(4000)
	DECLARE @s_l_role_name	VARCHAR(200)
 --	select * from tblMenu_Report_access
	BEGIN TRAN
		SET @s_l_role_name = (select top 1 RoleName from IssueTracker_Roles where RoleId = @i_a_roleid)

		DELETE FROM tblMenu_Report_access WHERE DomainId = @s_a_DomainID and RoleId = @i_a_roleid 
		and ReportMenuId NOT in(select s from dbo.SplitString(@s_a_ReportMenuid,',') WHERE s <>'')

		insert into tblMenu_Report_access (DomainId,roleid,ReportMenuid) 
		SELECT @s_a_DomainID,@i_a_roleid, s as ReportMenuID from dbo.SplitString(@s_a_ReportMenuid,',')
		WHERE s <>'' and s NOT in(select ReportMenuId  FROM tblMenu_Report_access WHERE DomainId = @s_a_DomainID and RoleId = @i_a_roleid) 

		SET @s_l_notes_desc = 'ReportMenu Assigned to the role -'+ @s_l_role_name	

		EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='ReportMenu Assign',@DomainID =@s_a_DomainID 
		      
	COMMIT TRAN 
	SELECT 'ReportMenu assigned successfully' AS [Message]
END



