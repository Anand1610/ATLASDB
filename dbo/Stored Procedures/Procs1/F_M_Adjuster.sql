CREATE PROCEDURE [dbo].[F_M_Adjuster]
		(
			@s_a_insurancecompany_id			NVARCHAR(50),
			@s_a_adjuster_lastname				NVARCHAR(100),
			@s_a_adjuster_firstname				NVARCHAR(100),
			@s_a_adjuster_address				VARCHAR(255),
			@s_a_adjuster_phone					NVARCHAR(50),
			@s_a_adjuster_fax					NVARCHAR(50),
			@s_a_adjuster_email					NVARCHAR(50),
			@s_a_adjuster_extension				NVARCHAR(50),
			@s_a_adjuster_id					NVARCHAR(50),
			@s_l_user_name						NVARCHAR(50),
			@s_l_mode							NVARCHAR(50)
		)

AS
BEGIN
	DECLARE @s_l_message NVARCHAR(500),
			@desc VARCHAR(200),
			@s_l_notes_desc NVARCHAR(500)
			
	 IF (@s_l_mode=1)	
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
			SET @s_l_message='Settlement Adjuster added Successfully'
			SET @s_l_notes_desc = 'Settlement Adjuster created-'+@s_a_adjuster_firstname+' '+@s_a_adjuster_lastname
			EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_l_user_name,@s_a_notes_type='Adjuster'
			SELECT @s_l_message AS [MESSAGE]
		END
	 IF (@s_l_mode=2)
		BEGIN
			SELECT * FROM tblAdjusters WHERE Adjuster_Id=@s_a_adjuster_id
		END
	 	
	
END

