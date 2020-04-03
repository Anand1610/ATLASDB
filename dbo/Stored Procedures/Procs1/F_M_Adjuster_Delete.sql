CREATE PROCEDURE [dbo].[F_M_Adjuster_Delete]
		(
			@i_a_Adjuster_id		    INT,
			@s_a_username				NVARCHAR(100)
		)

AS
BEGIN
	 DECLARE @s_l_message				NVARCHAR(500),
			@desc						VARCHAR(200),
			@s_l_notes_desc				NVARCHAR(500),
			@s_l_adjusterfirstname		NVARCHAR(100),
			@s_l_adjusterlastname		NVARCHAR(100)
	 BEGIN
		SELECT @s_l_adjusterfirstname= Adjuster_FirstName,@s_l_adjusterlastname=Adjuster_LastName FROM tblAdjusters WHERE Adjuster_Id=@i_a_Adjuster_id
		DELETE FROM tblAdjusters WHERE Adjuster_Id=@i_a_Adjuster_id
			 SET @s_l_message='Adjuster deleted'
			 SET @s_l_notes_desc = 'Adjuster deleted:'+@s_l_adjusterfirstname+' '+@s_l_adjusterlastname
			 EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_username,@s_a_notes_type='Adjuster'
			 SELECT @s_l_message AS [MESSAGE]
	 END	
END

