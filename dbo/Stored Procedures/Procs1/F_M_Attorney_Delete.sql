CREATE PROCEDURE [dbo].[F_M_Attorney_Delete]
		(
			@i_a_attorney_auto_id		INT,
			@s_a_username				NVARCHAR(100),
			@s_l_attorneyfirstname		NVARCHAR(100),
			@s_l_attorneylastname		NVARCHAR(100)
		)

AS
BEGIN
	 DECLARE @s_l_message				NVARCHAR(500),
			@desc						VARCHAR(200),
			@s_l_notes_desc				NVARCHAR(500)
	 BEGIN
		SELECT @s_l_attorneyfirstname= Attorney_FirstName,@s_l_attorneylastname=Attorney_LastName FROM tblAttorney WHERE Attorney_AutoId=@i_a_attorney_auto_id
		DELETE FROM tblAttorney WHERE Attorney_AutoId=@i_a_attorney_auto_id
			 SET @s_l_message='Attorney deleted'
			 SET @s_l_notes_desc = 'Attorney deleted:'+@s_l_attorneyfirstname+' '+@s_l_attorneylastname
			 EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_username,@s_a_notes_type='Attorney'
			 SELECT @s_l_message AS [MESSAGE]
	 END	
END

