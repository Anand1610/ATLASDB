CREATE PROCEDURE [dbo].[F_M_Attorney]
		(
			@s_a_attorney_firstname			NVARCHAR(100),			
			@s_a_attorney_lastname			NVARCHAR(100),
			@s_a_attorney_address			VARCHAR(255),
			@s_a_attorney_zip				NVARCHAR(50),
			@s_a_attorney_state				NVARCHAR(20),
			@s_a_attorney_phone				NVARCHAR(50),
			@s_a_attorney_fax				NVARCHAR(50),
			@s_a_attorney_email				NVARCHAR(50),
			@s_a_defendant_id				NVARCHAR(50),
			@s_l_user_name					NVARCHAR(50)
		)

AS
BEGIN
	DECLARE @s_l_message				NVARCHAR(500),
			@desc						VARCHAR(200),
			@s_l_attorney_id			VARCHAR(50),
			@s_l_max_attorney_autoid	VARCHAR(20),
			@s_l_notes_desc				NVARCHAR(500)
	 
	 SET @s_l_max_attorney_autoid=(SELECT MAX(Attorney_AutoId+1) FROM tblAttorney)
	 SET @s_l_attorney_id='A' + RIGHT(CAST(DATEPART(year, GETDATE())AS VARCHAR),2) + '-' +@s_l_max_attorney_autoid
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
				@s_l_attorney_id,
				@s_a_defendant_id,
				@s_a_attorney_lastname,
				@s_a_attorney_firstname,
				@s_a_attorney_address,
				@s_a_attorney_state,
				@s_a_attorney_zip,
				@s_a_attorney_phone,
				@s_a_attorney_fax,
				@s_a_attorney_email
		 )					

	 END 
	 SET @s_l_message='Settlement attorney added Successfully'
	 
	 SET @s_l_notes_desc = 'Settlement attorney created-'+@s_a_attorney_firstname+' '+@s_a_attorney_lastname
	 EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_l_user_name,@s_a_notes_type='Attorney'
	 
	 SELECT @s_l_message AS [MESSAGE]
END

