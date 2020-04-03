
CREATE PROCEDURE [dbo].[Service_Type_Add]
(
   @i_a_ServiceType_ID			INT,
   @s_a_ServiceType				VARCHAR(100),     
   @s_a_ServiceDesc				NVARCHAR(200),
   @s_a_DomainID				VARCHAR(50),
   @s_a_Created_By_User			VARCHAR(100)
)
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @i_l_result				INT
	DECLARE @s_l_message			NVARCHAR(500)
	DECLARE @s_l_Status				VARCHAR(200)
	DECLARE @s_l_notes_desc			NVARCHAR(MAX)
	
	IF(@i_a_ServiceType_ID = 0)
	BEGIN
	    IF EXISTS(SELECT ServiceType FROM tblServiceType WHERE ServiceType = @s_a_ServiceType and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message		=  'Service Type already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO tblServiceType
		      (
			      ServiceType,
				  DomainID,				 
				  ServiceDesc,
			      created_by_user,
			      created_date
		      )
		      VALUES
		      (
                  @s_a_ServiceType,
				  @s_a_DomainID,				 		
				  @s_a_ServiceDesc,				
                  @s_a_Created_By_User,
                  GETDATE()
		      )
		      SET @s_l_message		=  'Service Type details saved successfully'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      
		      SET @s_l_notes_desc = 'Added Service Type-'+	@s_a_ServiceType


		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='ServiceType',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		BEGIN TRAN
		
		DECLARE @oldServiceType VARCHAR(200)

		SET @oldServiceType = (SELECT TOP 1 ServiceType FROM tblServiceType WHERE  ServiceType_ID = @i_a_ServiceType_ID and DomainID = @s_a_DomainID )
		
		IF NOT EXISTS(SELECT TOP 1 ServiceType FROM tblServiceType WHERE  ServiceType_ID <>  @i_a_ServiceType_ID and ServiceType= @s_a_ServiceType and DomainID = @s_a_DomainID )
		BEGIN
			UPDATE tblServiceType
			SET 
				 ServiceType		= @s_a_ServiceType,                 							
				 ServiceDesc		= @s_a_ServiceDesc,				 
				 modified_by_user	= @s_a_Created_By_User,
				 modified_date		= GETDATE()
			WHERE 
				 ServiceType_ID = @i_a_ServiceType_ID
				 and DomainID = @s_a_DomainID

			IF(@s_a_ServiceType<> @oldServiceType)
			BEGIN
				UPDATE tblTreatment
				SET SERVICE_TYPE		= @s_a_ServiceType
				WHERE SERVICE_TYPE  	= @oldServiceType  and DomainID = @s_a_DomainID 
			END

			SET @s_l_message	=  'Service Type details updated successfully'
			SET @i_l_result		=  @i_a_ServiceType_ID
		END
		ELSE
		BEGIN
			SET @s_l_message	=  'Service Type already exist. You can not change the Service Type '
			SET @i_l_result		=  @i_a_ServiceType_ID
		END
		
		
		SET @s_l_notes_desc = 'Updated Service Type-'+	@s_a_ServiceType
            
		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='ServiceType',@DomainID =@s_a_DomainID 
		                                         
		COMMIT TRAN			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END
