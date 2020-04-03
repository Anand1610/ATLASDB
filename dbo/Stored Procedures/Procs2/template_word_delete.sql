
CREATE PROCEDURE [dbo].[template_word_delete]
(
   @s_a_DomainID VARCHAR(50),
   @i_a_template_id INT,
   @s_a_template_name VARCHAR(100),
   @s_a_template_file_name VARCHAR(100),
   @s_a_Created_By_User VARCHAR(100) 
)

AS
BEGIN
	 DECLARE @s_l_message				NVARCHAR(500),
			 @s_l_notes_desc				NVARCHAR(500)
			
	 BEGIN
	    
			BEGIN TRAN
	        
	        DELETE FROM tbl_template_word  WHERE pk_template_id = @i_a_template_id and  DomainID =@s_a_DomainID 
	        
			SET @s_l_message= 'Template deleted'
			SET @s_l_notes_desc = 'Template deleted - ' + @s_a_template_name + ', File Name : ' +@s_a_template_file_name
		    
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_Created_By_User,@s_a_notes_type='Template Word',@DomainID =@s_a_DomainID 
		    
		    COMMIT TRAN 
			
		
		SELECT @s_l_message AS [MESSAGE]
		
	 END	
END

--  alter table tblcase add [Rebuttal_Status] [varchar](200); 
