
CREATE PROCEDURE [dbo].[InsuranceCompanyGroup_Add]
(
   @i_a_InsuranceCompanyGroup_ID		INT,
   @s_a_InsuranceCompanyGroup_Name		VARCHAR(100),
   @s_a_DomainID						VARCHAR(50),
   @s_a_Created_By_User					VARCHAR(100)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--select * from tblInsuranceCompanyGroup
	--InsuranceCompanyGroup_ID	InsuranceCompanyGroup_Name
	SET NOCOUNT ON;
	DECLARE @i_l_result						INT
	DECLARE @s_l_message					NVARCHAR(500)
	DECLARE @s_l_InsuranceCompanyGroup_Name	VARCHAR(200)
	DECLARE @s_l_notes_desc					NVARCHAR(MAX)
	
	IF(@i_a_InsuranceCompanyGroup_ID = 0)
	BEGIN
	    IF EXISTS(SELECT InsuranceCompanyGroup_Name FROM tblInsuranceCompanyGroup WHERE InsuranceCompanyGroup_Name = @s_a_InsuranceCompanyGroup_Name and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message	=  'Insurance Company Group Name already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO tblInsuranceCompanyGroup
		      (
			      InsuranceCompanyGroup_Name,
				  DomainID,				  
			      created_by_user,
			      created_date
		      )
		      VALUES
		      (
                  @s_a_InsuranceCompanyGroup_Name,
				  @s_a_DomainID,
                  @s_a_Created_By_User,
                  GETDATE()
		      )
		      SET @s_l_message	=  'Insurance Company Group details saved successfully'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      
		      SET @s_l_notes_desc = 'Added Insurance Company Group-'+	 @s_a_InsuranceCompanyGroup_Name	


		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Insurance Company Group',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		IF NOT EXISTS(SELECT InsuranceCompanyGroup_Name FROM tblInsuranceCompanyGroup WHERE InsuranceCompanyGroup_Name = @s_a_InsuranceCompanyGroup_Name and DomainID = @s_a_DomainID and InsuranceCompanyGroup_Name <> @s_a_InsuranceCompanyGroup_Name)
		BEGIN
			BEGIN TRAN
		
			DECLARE @oldInsuranceCompanyGroup_Name VARCHAR(200)

			SET @oldInsuranceCompanyGroup_Name = (SELECT TOP 1 InsuranceCompanyGroup_Name FROM tblInsuranceCompanyGroup WHERE  InsuranceCompanyGroup_ID = @i_a_InsuranceCompanyGroup_ID and DomainID = @s_a_DomainID )
		
			IF(@s_a_InsuranceCompanyGroup_Name<> @oldInsuranceCompanyGroup_Name)
			BEGIN
				UPDATE tblInsuranceCompanyGroup
				SET 
					 InsuranceCompanyGroup_Name		= @s_a_InsuranceCompanyGroup_Name,
					
					 modified_by_user	= @s_a_Created_By_User,
					 modified_date		= GETDATE()
				WHERE 
					 InsuranceCompanyGroup_ID = @i_a_InsuranceCompanyGroup_ID
					 and DomainID = @s_a_DomainID

				UPDATE tblInsuranceCompany
				SET InsuranceCompany_GroupName = @s_a_InsuranceCompanyGroup_Name 					
				WHERE InsuranceCompany_GroupName = @oldInsuranceCompanyGroup_Name  and DomainID = @s_a_DomainID 

				SET @s_l_notes_desc = 'Updated Insurance Company Group-' + @oldInsuranceCompanyGroup_Name + ' to '+	@oldInsuranceCompanyGroup_Name + @s_a_InsuranceCompanyGroup_Name	
				EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Insurance Company Group',@DomainID =@s_a_DomainID 
		      
			END

			SET @s_l_message	=  'Insurance Company Group details updated successfully'
			SET @i_l_result	=  @i_a_InsuranceCompanyGroup_ID
                                   
			COMMIT TRAN		
		END
		ELSE
		BEGIN
			SET @s_l_message	=  'Cannot save,Insurance Company Group already exist...' 
			SET @i_l_result	=  @i_a_InsuranceCompanyGroup_ID
		END			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END
