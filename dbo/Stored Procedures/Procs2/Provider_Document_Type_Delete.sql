
CREATE PROCEDURE [dbo].[Provider_Document_Type_Delete]
(
   @i_a_Doc_Id           INT,
   @s_a_ProviderDoc_Type VARCHAR(100),
   @s_a_DomainID         VARCHAR(50),
   @s_a_Created_By_User  VARCHAR(100)
  
)
AS
BEGIN
	 DECLARE @s_l_message				NVARCHAR(500),
			 @s_l_notes_desc			NVARCHAR(500)
			 		
	 BEGIN
		IF EXISTS(SELECT DocType_ID FROM Provider_Documents WHERE DocType_ID = @i_a_Doc_Id and  DomainID =@s_a_DomainID )
	    BEGIN
	       SET @s_l_message	=  'Document type exists in Provider Documents..!!!'
	    END
	    ELSE
			
	 BEGIN
	
			BEGIN TRAN	        
	        DELETE FROM Provider_Document_Type  WHERE Doc_Id = @i_a_Doc_Id and  DomainID =@s_a_DomainID 
	        
			SET @s_l_message= 'Document type deleted'
			SET @s_l_notes_desc = 'Document type deleted - ' + @s_a_ProviderDoc_Type 
		    
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_Created_By_User,@s_a_notes_type='Provider Document Type',@DomainID =@s_a_DomainID 
		    
		    COMMIT TRAN 
		END	
		
		SELECT @s_l_message AS [MESSAGE]
		
	 END	
END

