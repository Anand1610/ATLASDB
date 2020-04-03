
CREATE PROCEDURE [dbo].[Service_Type_Delete]
(
    @i_a_ServiceType_ID			INT,
    @s_a_ServiceType			VARCHAR(100),     
    @s_a_DomainID				VARCHAR(50),
	@s_a_Created_By_User		VARCHAR(100)
  
)

AS
BEGIN
	 DECLARE @s_l_message				NVARCHAR(500),
			 @s_l_notes_desc			NVARCHAR(500)
			
			
	 BEGIN
		IF EXISTS(SELECT SERVICE_TYPE FROM tblTreatment WHERE SERVICE_TYPE = @s_a_ServiceType and  DomainID =@s_a_DomainID )
	    BEGIN
	       SET @s_l_message	=  'Service Type exists in Case..!!!'
	    END
	    ELSE
	    BEGIN
			BEGIN TRAN
	        
	        DELETE FROM tblServiceType  WHERE ServiceType_ID = @i_a_ServiceType_ID and  DomainID =@s_a_DomainID 
	        
			SET @s_l_message	= 'Service Type deleted'
			SET @s_l_notes_desc = 'Service Type deleted - ' + @s_a_ServiceType 
		    
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_Created_By_User,@s_a_notes_type='ServiceType',@DomainID =@s_a_DomainID 
		    
		    COMMIT TRAN 
		END	
		
		SELECT @s_l_message AS [MESSAGE]
		
	 END	
END

