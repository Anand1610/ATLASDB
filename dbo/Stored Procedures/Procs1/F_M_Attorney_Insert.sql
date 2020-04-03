CREATE PROCEDURE [dbo].[F_M_Attorney_Insert]
		(
			@i_a_attorney_autoid			INT,
			@s_a_attorney_firstname			NVARCHAR(100),			
			@s_a_attorney_lastname			NVARCHAR(100),
			@s_a_attorney_address			VARCHAR(255),
			@s_a_attorney_zip				NVARCHAR(50),
			@s_a_attorney_city				NVARCHAR(50),
			@s_a_attorney_state				NVARCHAR(20),
			@s_a_attorney_phone				NVARCHAR(50),
			@s_a_attorney_fax				NVARCHAR(50),
			@s_a_attorney_email				NVARCHAR(50),
			@s_a_defendant_id				NVARCHAR(50),
			@s_l_user_name					NVARCHAR(50)
		)

AS
BEGIN
	DECLARE @i_l_maxattorney_id_identity    INTEGER,  
			@s_l_message					NVARCHAR(500),
			@desc							VARCHAR(200),
			@s_l_attorney_id				NVARCHAR(50),
			@s_l_max_attorney_autoid		VARCHAR(20),
			@s_l_notes_desc					NVARCHAR(500),
			@i_l_result						INT
	 
	 --SET @s_l_max_attorney_autoid=(SELECT MAX(Attorney_AutoId+1) FROM tblAttorney)
	 --SET @s_l_attorney_id='A' + RIGHT(CAST(DATEPART(year, GETDATE())AS VARCHAR),2) + '-' +@s_l_max_attorney_autoid
	 IF ( @i_a_attorney_autoid=0)
		BEGIN
			INSERT INTO tblAttorney 
			 (
				  Attorney_Id,   
				  Defendant_Id,  
				  Attorney_LastName,  
				  Attorney_FirstName,  
				  Attorney_Address,
				  --Attorney_City,  
				  Attorney_State,  
				  Attorney_Zip,  
				  Attorney_Phone,  
				  Attorney_Fax,  
				  Attorney_Email
			)

			VALUES
			(
				'',
				@s_a_defendant_id,
				@s_a_attorney_lastname,
				@s_a_attorney_firstname,
				@s_a_attorney_address,
				--@s_a_attorney_city,
				@s_a_attorney_state,
				@s_a_attorney_zip,
				@s_a_attorney_phone,
				@s_a_attorney_fax,
				@s_a_attorney_email
			)	
			 SET @i_l_maxattorney_id_identity = @@IDENTITY  
			 SET @s_l_attorney_id  = 'A' + RIGHT(CAST(DATEPART(YEAR, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@i_l_maxattorney_id_identity AS NVARCHAR)  	
			 UPDATE tblAttorney SET Attorney_Id = @s_l_attorney_id where Attorney_AutoId = @i_l_maxattorney_id_identity  			
			 SET @s_l_message='Attorney added Successfully'
			 SET @i_l_result		=  SCOPE_IDENTITY()
			 SET @s_l_notes_desc = 'Attorney created-'+@s_a_attorney_firstname+' '+@s_a_attorney_lastname
			 EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_l_user_name,@s_a_notes_type='Attorney'
			 SELECT @s_l_message AS [MESSAGE],@i_l_result AS [RESULT]
		END 
	 IF (@i_a_attorney_autoid<>0)
		BEGIN
			UPDATE tblAttorney 
				SET 
					Attorney_LastName=@s_a_attorney_lastname,
					Attorney_FirstName=@s_a_attorney_firstname,
					Attorney_Address=@s_a_attorney_address,
					 --Attorney_City=s_a_attorney_city,  
					  Attorney_State=@s_a_attorney_state,  
					  Attorney_Zip=@s_a_attorney_zip,  
					  Attorney_Phone=@s_a_attorney_phone,  
					  Attorney_Fax=@s_a_attorney_fax,  
					  Attorney_Email=@s_a_attorney_email,
					  Defendant_Id=@s_a_defendant_id
				WHERE
					Attorney_AutoId=@i_a_attorney_autoid	
			 SET @s_l_message='Attorney updated Successfully'
			 SET @i_l_result		=  @i_a_attorney_autoid
			 SET @s_l_notes_desc = 'Attorney created-'+@s_a_attorney_firstname+' '+@s_a_attorney_lastname
			 EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_l_user_name,@s_a_notes_type='Attorney'
			 SELECT @s_l_message AS [MESSAGE],@i_l_result AS [RESULT]
		END
END

