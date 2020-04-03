CREATE PROCEDURE [dbo].[Provider_Document_Type_Add]
(
   @i_a_Doc_Id		       INT,
   @s_a_ProviderDoc_Type   VARCHAR(100),
   @s_a_DomainID		   VARCHAR(50),
   @s_a_Created_By_User    VARCHAR(100)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--select * from Provider_Document_Type
	--Doc_Id	ProviderDoc_Type
	SET NOCOUNT ON;
	DECLARE @i_l_result	    INT
	DECLARE @s_l_message	NVARCHAR(500)
	DECLARE @s_l_ProviderDoc_TypeType	VARCHAR(200)
	DECLARE @s_l_notes_desc	NVARCHAR(MAX)
	
	IF(@i_a_Doc_Id = 0)
	BEGIN
	    IF EXISTS(SELECT ProviderDoc_Type FROM Provider_Document_Type WHERE ProviderDoc_Type = @s_a_ProviderDoc_Type and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message	=  'Document type already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO Provider_Document_Type
		      (
			      ProviderDoc_Type,
				  DomainID,
			      created_by_user,
			      created_date
		      )
		      VALUES
		      (
                  @s_a_ProviderDoc_Type,
				  @s_a_DomainID,
                  @s_a_Created_By_User,
                  GETDATE()
		      )
		      SET @s_l_message	=  'Document type details saved successfully'
		      SET @i_l_result		=  SCOPE_IDENTITY()		     		      
		      SET @s_l_notes_desc = 'Added Document Type-'+	 @s_a_ProviderDoc_Type	

		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Provider Document Type',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		BEGIN TRAN
		
		DECLARE @oldProviderDoc_Type VARCHAR(200)

		SET @oldProviderDoc_Type = (SELECT TOP 1 ProviderDoc_Type FROM Provider_Document_Type WHERE  Doc_Id = @i_a_Doc_Id and DomainID = @s_a_DomainID )
		
		IF NOT EXISTS(SELECT TOP 1 ProviderDoc_Type FROM Provider_Document_Type WHERE  Doc_Id <>  @i_a_Doc_Id and ProviderDoc_Type= @s_a_ProviderDoc_Type and DomainID = @s_a_DomainID )
		BEGIN
			UPDATE Provider_Document_Type
			SET 
				 ProviderDoc_Type	= @s_a_ProviderDoc_Type,
				 modified_by_user	= @s_a_Created_By_User,
				 modified_date		= GETDATE()
			WHERE 
				 Doc_Id = @i_a_Doc_Id
				 and DomainID = @s_a_DomainID

		 
			SET @s_l_message	=  'Document type updated successfully'
			SET @i_l_result	=  @i_a_Doc_Id
		END
		ELSE
		BEGIN
			SET @s_l_message	=  'Document type already exist. You can not change the document type '
			SET @i_l_result	=  @i_a_Doc_Id
		END
		
		
		SET @s_l_notes_desc = 'Updated Document  Type-'+	 @s_a_ProviderDoc_Type	
            
		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Provider Document Type',@DomainID =@s_a_DomainID 
		                                         
		COMMIT TRAN			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END
