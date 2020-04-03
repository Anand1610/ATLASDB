CREATE PROCEDURE [dbo].[F_M_Undetermined_Reasons]
(
	@s_a_UndeterminedReasons	NVARCHAR(200),
	@s_a_user_name		NVARCHAR(100),
	@s_a_mode			NVARCHAR(50),
	@i_a_AUTOID		INT
)

AS
BEGIN
	DECLARE @s_l_message NVARCHAR(500),
		@desc VARCHAR(200),
		@s_l_notes_desc NVARCHAR(500)
			
	IF (@s_a_mode=1)	
	BEGIN
		INSERT INTO tbl_Undetermined_reasons 
		(
			UndeterminedReasons
		)

		VALUES
		(
			@s_a_UndeterminedReasons
		)					
		SET @s_l_message='Undetermined Reasons added Successfully'
		SET @s_l_notes_desc = 'Undetermined Reasons added-'+@s_a_UndeterminedReasons
		EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_user_name,@s_a_notes_type='Undetermined Reasons'
		SELECT @s_l_message AS [MESSAGE]
	END
	
	IF (@s_a_mode=2)
	BEGIN
		SELECT * FROM tbl_Undetermined_reasons ORDER BY UndeterminedReasons
	END
	
	IF (@s_a_mode=3)	
	BEGIN
		UPDATE tbl_Undetermined_reasons 
		SET  UndeterminedReasons = @s_a_UndeterminedReasons
		WHERE AUTOID = @i_a_AUTOID 	
						
		SET @s_l_message='Undetermined Reasons Updated Successfully'
		SET @s_l_notes_desc = 'Undetermined Reasons Updated-'+@s_a_UndeterminedReasons + '' --+ @i_a_AUTOID
		EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_user_name,@s_a_notes_type='Undetermined Reasons'
		SELECT @s_l_message AS [MESSAGE]
	END
	
	
	IF (@s_a_mode=4)	
	BEGIN

		DELETE FROM tbl_Undetermined_reasons 
		WHERE AUTOID = @i_a_AUTOID 	
						
		SET @s_l_message='Undetermined Reasons Deleted Successfully'
		SET @s_l_notes_desc = 'Undetermined Reasons Deleted-'+@s_a_UndeterminedReasons + ''-- + @i_a_AUTOID
		EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_user_name,@s_a_notes_type='Undetermined Reasons'
		SELECT @s_l_message AS [MESSAGE]
	END
END

