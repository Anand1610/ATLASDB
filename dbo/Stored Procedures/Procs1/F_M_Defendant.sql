CREATE PROCEDURE [dbo].[F_M_Defendant]
		(
			@s_a_defendant_name					NVARCHAR(100),
			@s_a_defendant_address				VARCHAR(255),
			@s_a_defendant_zip					NVARCHAR(50),
			@s_a_defendant_state				NVARCHAR(20),
			@s_a_defendant_phone				NVARCHAR(50),
			@s_a_defendant_fax					NVARCHAR(50),
			@s_a_defendant_email				NVARCHAR(50),
			@s_l_user_name						NVARCHAR(50)
		)

AS
BEGIN
	DECLARE @s_l_message NVARCHAR(500),
			@desc VARCHAR(200),
			
			@s_l_notes_desc NVARCHAR(500)
	 BEGIN
		 INSERT INTO tblDefendant 
		 (
				Defendant_Name,
				Defendant_DisplayName,
				Defendant_Address,
				Defendant_State,
				Defendant_Zip,
				Defendant_Phone,
				Defendant_Fax,
				Defendant_Email
		 )

		 VALUES
		 (
				@s_a_defendant_name,
				@s_a_defendant_name,
				@s_a_defendant_address,
				@s_a_defendant_state,
				@s_a_defendant_zip,
				@s_a_defendant_phone,
				@s_a_defendant_fax,
				@s_a_defendant_email
		 )					

	 END 
	 SET @s_l_message='Settlement defendant added Successfully'
	 
	 SET @s_l_notes_desc = 'Settlement defendant created-'+@s_a_defendant_name
	 EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_l_user_name,@s_a_notes_type='Defendant'
	 
	 SELECT @s_l_message AS [MESSAGE]
END

