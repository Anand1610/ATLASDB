CREATE PROCEDURE [dbo].[CaseStatus_Delete]
(
		 @i_a_Id      INT,
		 @s_a_Name		 VARCHAR(100),
         @s_a_DomainID			 VARCHAR(50),
	     @s_a_Created_By_User	 VARCHAR(100) 
)
AS
BEGIN
	 DECLARE @s_l_message					NVARCHAR(500),
			 @s_l_notes_desc				NVARCHAR(500),
			 @Name                           VARCHAR(100) 
			
	 BEGIN
		IF EXISTS(select Initial_Status from tblCase where Initial_Status = @Name and DomainId = @s_a_DomainID )
	    BEGIN
	       SET @s_l_message	=  'Case Status exists in Case..!!!'
	    END
	    ELSE
	    BEGIN
			BEGIN TRAN
	        
	        DELETE FROM tblCaseStatus  WHERE id = @i_a_Id and  DomainId =@s_a_DomainID 
	        
			SET @s_l_message= 'Case Status deleted'
			SET @s_l_notes_desc = 'Case Status deleted - ' + @s_a_Name 
		    
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_Created_By_User,@s_a_notes_type='Case Status',@DomainID =@s_a_DomainID 
		    
		    COMMIT TRAN 
		END	
		
		SELECT @s_l_message AS [MESSAGE]
		
	 END	
END
