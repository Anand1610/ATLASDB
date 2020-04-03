CREATE PROCEDURE [dbo].[F_M_Defendant_Insert]
		(
			@s_a_defendant_name					NVARCHAR(100),
			@s_a_defendant_address				VARCHAR(255),
			@s_a_defendant_zip					NVARCHAR(50),
			@s_a_defendant_city					NVARCHAR(50),
			@s_a_defendant_state				NVARCHAR(20),
			@s_a_defendant_phone				NVARCHAR(50),
			@s_a_defendant_fax					NVARCHAR(50),
			@s_a_defendant_email				NVARCHAR(50),
			@s_l_user_name						NVARCHAR(50),
			@i_a_defendant_id					INT,
			@s_a_active							NVARCHAR(10)
		)

AS
BEGIN
	DECLARE @s_l_message NVARCHAR(500),
			@desc VARCHAR(200),
			@s_l_notes_desc NVARCHAR(500),
			@i_l_result		INT
	IF (@i_a_defendant_id=0)	
		BEGIN
			INSERT INTO tblDefendant 
			(
				Defendant_Name,
				Defendant_DisplayName,
				Defendant_Address,
				Defendant_City,
				Defendant_State,
				Defendant_Zip,
				Defendant_Phone,
				Defendant_Fax,
				Defendant_Email,
				active
				
			)

			VALUES
			(
				@s_a_defendant_name,
				@s_a_defendant_name,
				@s_a_defendant_address,
				@s_a_defendant_city,
				@s_a_defendant_state,
				@s_a_defendant_zip,
				@s_a_defendant_phone,
				@s_a_defendant_fax,
				@s_a_defendant_email,
				@s_a_active
			)					
			SET @s_l_message='Defendant added Successfully'
			 SET @i_l_result		=  SCOPE_IDENTITY()
			SET @s_l_notes_desc = 'Defendant created-'+@s_a_defendant_name
			EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_l_user_name,@s_a_notes_type='Defendant'
			SELECT @s_l_message AS [MESSAGE],@i_l_result AS [RESULT]
	    END 
	IF (@i_a_defendant_id<>0)
		BEGIN
			UPDATE tblDefendant
				SET
					Defendant_Name=@s_a_defendant_name,
					Defendant_DisplayName=@s_a_defendant_name,
					Defendant_Address=@s_a_defendant_address,
					Defendant_City=@s_a_defendant_city,
					Defendant_State=@s_a_defendant_state,
					Defendant_Zip=@s_a_defendant_zip,
					Defendant_Phone=@s_a_defendant_phone,
					Defendant_Fax=@s_a_defendant_fax,
					Defendant_Email=@s_a_defendant_email
			  WHERE 
					Defendant_id=@i_a_defendant_id
			SET @s_l_message='Defendant updated Successfully'
			 SET @i_l_result		=  @i_a_defendant_id
			SET @s_l_notes_desc = 'Defendant created-'+@s_a_defendant_name
			EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_l_user_name,@s_a_notes_type='Defendant'
			SELECT @s_l_message AS [MESSAGE],@i_l_result AS [RESULT]
		END
		
END

