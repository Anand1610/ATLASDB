 

CREATE PROCEDURE [dbo].[Menu_Access_Save] 
(
	@s_a_DomainID nvarchar(50),
	@i_a_roleid int,
	@s_a_menuid varchar(4000),
	@s_a_Created_By_User varchar(100)
)
as
BEGIN
	DECLARE @s_l_notes_desc	VARCHAR(4000)
	DECLARE @s_l_role_name	VARCHAR(200)
 --	select * from tblMenu_Access
	BEGIN TRAN
		SET @s_l_role_name = (select top 1 RoleName from IssueTracker_Roles where RoleId = @i_a_roleid)

		DELETE FROM tblmenu_access WHERE DomainId = @s_a_DomainID and RoleId = @i_a_roleid 
		and MenuId NOT in(select s from dbo.SplitString(@s_a_menuid,',') WHERE s <>'')

		insert into tblmenu_access (DomainId,roleid,menuid) 
		SELECT @s_a_DomainID,@i_a_roleid, s as MenuID from dbo.SplitString(@s_a_menuid,',')
		WHERE s <>'' and s NOT in(select MenuId  FROM tblmenu_access WHERE DomainId = @s_a_DomainID and RoleId = @i_a_roleid) 

		SET @s_l_notes_desc = 'Menu Assigned to the role -'+ @s_l_role_name	

		EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Menu Assign',@DomainID =@s_a_DomainID 
		      
	COMMIT TRAN 
	SELECT 'Menu assigned successfully' AS [Message]
END



