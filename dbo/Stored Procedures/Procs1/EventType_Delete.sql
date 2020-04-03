

CREATE PROCEDURE [dbo].[EventType_Delete]
(
		 @i_a_EventTypeId      INT,
		 @s_a_EventTypeName		 VARCHAR(100),
         @s_a_DomainID			 VARCHAR(50),
	     @s_a_Created_By_User	 VARCHAR(100) 
)
AS
BEGIN
	 DECLARE @s_l_message					NVARCHAR(500),
			 @s_l_notes_desc				NVARCHAR(500)
			
	 BEGIN
		IF EXISTS(select EventTypeId from tblEvent WHERE EventTypeId = @i_a_EventTypeId and  DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message	=  'Event Type exists in Case..!!!'
	    END
	    ELSE
	    BEGIN
			BEGIN TRAN
	        
	        DELETE FROM tblEventType  WHERE EventTypeId = @i_a_EventTypeId and  DomainID =@s_a_DomainID 
	        
			SET @s_l_message= 'Event Type deleted'
			SET @s_l_notes_desc = 'Event Type deleted - ' + @s_a_EventTypeName 
		    
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_Created_By_User,@s_a_notes_type='Event Type',@DomainID =@s_a_DomainID 
		    
		    COMMIT TRAN 
		END	
		
		SELECT @s_l_message AS [MESSAGE]
		
	 END	
END
