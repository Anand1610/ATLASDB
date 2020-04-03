CREATE PROCEDURE [dbo].[F_M_Adjuster_Insert]
		(
			@s_a_insurancecompany_id			NVARCHAR(50),
			@s_a_adjuster_lastname				NVARCHAR(100),
			@s_a_adjuster_firstname				NVARCHAR(100),
			@s_a_adjuster_address				VARCHAR(255),
			@s_a_adjuster_phone					NVARCHAR(50),
			@s_a_adjuster_fax					NVARCHAR(50),
			@s_a_adjuster_email					NVARCHAR(50),
			@s_a_adjuster_extension				NVARCHAR(50),
			@i_a_adjuster_id					INT,
			@s_l_user_name						NVARCHAR(50)
		)

AS
BEGIN
	DECLARE @s_l_message NVARCHAR(500),
			@desc VARCHAR(200),
			@s_l_notes_desc NVARCHAR(500),
			@i_l_result		INT
			
	 IF ( @i_a_adjuster_id=0)	
		BEGIN
			INSERT INTO tblAdjusters 
			(
				InsuranceCompany_Id, 
				Adjuster_LastName,
				Adjuster_FirstName,
				Adjuster_Address,
				Adjuster_Phone,
				Adjuster_Fax,
				Adjuster_Email,
				Adjuster_Extension
			)

			VALUES
			(
				@s_a_insurancecompany_id,
				@s_a_adjuster_lastname,
				@s_a_adjuster_firstname,
				@s_a_adjuster_address,
				@s_a_adjuster_phone,
				@s_a_adjuster_fax,
				@s_a_adjuster_email,
				@s_a_adjuster_extension
			)					
			SET @s_l_message='Adjuster added Successfully'
			 SET @i_l_result		=  SCOPE_IDENTITY()
			SET @s_l_notes_desc = 'Adjuster created-'+@s_a_adjuster_firstname+' '+@s_a_adjuster_lastname
			EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_l_user_name,@s_a_notes_type='Adjuster'
			SELECT @s_l_message AS [MESSAGE],@i_l_result AS [RESULT]
		END
	 IF ( @i_a_adjuster_id<>0)
		BEGIN
			UPDATE tblAdjusters 
				SET 
					Adjuster_FirstName=@s_a_adjuster_firstname,
					Adjuster_LastName=@s_a_adjuster_lastname,
					InsuranceCompany_Id=@s_a_insurancecompany_id,
					Adjuster_Phone=@s_a_adjuster_phone,
					Adjuster_Fax=@s_a_adjuster_fax,
					Adjuster_Email=@s_a_adjuster_email,
					Adjuster_Extension=@s_a_adjuster_extension,
					Adjuster_Address=@s_a_adjuster_address
				WHERE
					Adjuster_Id=@i_a_adjuster_id	
			SET @s_l_message='Adjuster updated Successfully'
			 SET @i_l_result		=  @i_a_adjuster_id
			SET @s_l_notes_desc = 'Adjuster created-'+@s_a_adjuster_firstname+' '+@s_a_adjuster_lastname
			EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_l_user_name,@s_a_notes_type='Adjuster'
			SELECT @s_l_message AS [MESSAGE],@i_l_result AS [RESULT]
		END
END

