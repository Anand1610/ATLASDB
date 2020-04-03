
CREATE PROCEDURE [dbo].[Attorney_Type_Delete]
(
   @i_a_Attorney_Type_ID       INT,
   @s_a_Attorney_Type    VARCHAR(100),
   @s_a_DomainID        VARCHAR(50),
   @s_a_Created_By_User VARCHAR(100)
  
)
AS
BEGIN
	 DECLARE @s_l_message				NVARCHAR(500),
			 @s_l_notes_desc			NVARCHAR(500)
			 		
	 BEGIN
		IF EXISTS(SELECT Attorney_Type_Id FROM tblAttorney_Case_Assignment WHERE Attorney_Type_Id = @i_a_Attorney_Type_ID and  DomainID =@s_a_DomainID )
	    BEGIN
	       SET @s_l_message	=  'Attorney Type exists in Case..!!!'
	    END
	    ELSE
			
		BEGIN
	
			BEGIN TRAN	        
	        DELETE FROM tblAttorney_Type  WHERE Attorney_Type_ID = @i_a_Attorney_Type_ID and  DomainID =@s_a_DomainID 
	        
			SET @s_l_message= 'Attorney Type deleted'
			SET @s_l_notes_desc = 'Attorney Type deleted - ' + @s_a_Attorney_Type 
		    
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_Created_By_User,@s_a_notes_type='Attorney_Type',@DomainID =@s_a_DomainID 
		    
		    COMMIT TRAN 
		END	
		
		SELECT @s_l_message AS [MESSAGE]
		
	 END	
END

