CREATE PROCEDURE [dbo].[Task_Type_Delete]
(

   @i_a_Task_Type_ID	 INT,
   @s_a_Description		 VARCHAR(100),
   @s_a_DomainID		 VARCHAR(50),
   @s_a_Created_By_User	 VARCHAR(100)
  
)

AS
BEGIN
	 DECLARE @s_l_message				NVARCHAR(500),
			 @s_l_notes_desc			NVARCHAR(500)
			
	 BEGIN
		IF EXISTS(SELECT Task_Type_ID FROM Task WHERE Task_Type_ID = @i_a_Task_Type_ID and  DomainID =@s_a_DomainID)	
	    BEGIN
	       SET @s_l_message	=  'Task type exists in case..!!!'
	    END
	    ELSE 
	    BEGIN
			BEGIN TRAN
	        
	        DELETE FROM Task_Type  WHERE Task_Type_ID = @i_a_Task_Type_ID and  DomainID =@s_a_DomainID 
	        
			SET @s_l_message	= 'Task  deleted'
			SET @s_l_notes_desc = 'Task  deleted - ' + @s_a_Description 
		    
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_Created_By_User,@s_a_notes_type='TaskType',@DomainID =@s_a_DomainID 
		    
		    COMMIT TRAN 
		END
	END	
		
		SELECT @s_l_message AS [MESSAGE]
		
END
