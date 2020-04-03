CREATE PROCEDURE [dbo].[F_M_Defendant_Delete]
		(
			@i_a_Defendant_id		    INT,
			@s_a_username				NVARCHAR(100)
		)

AS
BEGIN
	 DECLARE @s_l_message				NVARCHAR(500),
			@desc						VARCHAR(200),
			@s_l_notes_desc				NVARCHAR(500),
			@s_l_defendantname		    NVARCHAR(200)
	 BEGIN
		SELECT @s_l_defendantname=Defendant_Name FROM tblDefendant WHERE Defendant_id=@i_a_Defendant_id
		DELETE FROM tblDefendant WHERE Defendant_id=@i_a_Defendant_id
			 SET @s_l_message='Defendant deleted'
			 SET @s_l_notes_desc = 'Defendant deleted:'+@s_l_defendantname
			 EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_username,@s_a_notes_type='Defendant'
			 SELECT @s_l_message AS [MESSAGE]
	 END	
END

