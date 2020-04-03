CREATE PROCEDURE [dbo].[F_M_Closed_Reasons]
(
	@s_a_ClosedReasons	NVARCHAR(200),
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
		INSERT INTO tbl_closed_reasons 
		(
			ClosedReasons
		)

		VALUES
		(
			@s_a_ClosedReasons
		)					
		SET @s_l_message='Closed Reasons added Successfully'
		SET @s_l_notes_desc = 'Closed Reasons added-'+@s_a_ClosedReasons
		EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_user_name,@s_a_notes_type='Closed Reasons'
		SELECT @s_l_message AS [MESSAGE]
	END
	
	IF (@s_a_mode=2)
	BEGIN
		SELECT * FROM tbl_closed_reasons ORDER BY ClosedReasons
	END
	
	IF (@s_a_mode=3)	
	BEGIN
		UPDATE tbl_closed_reasons 
		SET  ClosedReasons = @s_a_ClosedReasons
		WHERE AUTOID = @i_a_AUTOID 	
						
		SET @s_l_message='Closed Reasons Updated Successfully'
		SET @s_l_notes_desc = 'Closed Reasons Updated-'+@s_a_ClosedReasons + '' --+ @i_a_AUTOID
		EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_user_name,@s_a_notes_type='Closed Reasons'
		SELECT @s_l_message AS [MESSAGE]
	END
	
	
	IF (@s_a_mode=4)	
	BEGIN

		DELETE FROM tbl_closed_reasons 
		WHERE AUTOID = @i_a_AUTOID 	
						
		SET @s_l_message='Closed Reasons Deleted Successfully'
		SET @s_l_notes_desc = 'Closed Reasons Deleted-'+@s_a_ClosedReasons + ''-- + @i_a_AUTOID
		EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_user_name,@s_a_notes_type='Closed Reasons'
		SELECT @s_l_message AS [MESSAGE]
	END
END

