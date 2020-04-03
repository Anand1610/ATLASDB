CREATE PROCEDURE [dbo].[F_M_User_Delete]
(
	@DomainId NVARCHAR(50),
   @i_a_User_Id		    INT,
   @s_a_User  VARCHAR(100),
   @s_a_UserName VARCHAR(100)
)

AS
BEGIN
	 DECLARE @s_l_message				NVARCHAR(500),
			@desc						VARCHAR(200),
			@s_l_notes_desc				NVARCHAR(500)
			
	 BEGIN
		  UPDATE IssueTracker_Users  SET IsActive=0 WHERE UserId=@i_a_User_Id and DomainId=@DomainId
		  
		  SET @s_l_message= 'User deleted'
		  SET @s_l_notes_desc = 'User deleted - ' + @s_a_User 
		  
		  EXEC F_AdminNotes_Add @DomainId=@DomainId,@s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_username,@s_a_notes_type='User'
		  
		  SELECT @s_l_message AS [MESSAGE]
	 END	
END

