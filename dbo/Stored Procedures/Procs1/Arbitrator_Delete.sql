
CREATE PROCEDURE [dbo].[Arbitrator_Delete]
(
   @i_a_ARBITRATOR_ID      INT,
   @s_a_ARBITRATOR_NAME    VARCHAR(100),
   @s_a_DomainID           VARCHAR(50),
   @s_a_Created_By_User    VARCHAR(100)
  
)
AS
BEGIN
	 DECLARE @s_l_message				NVARCHAR(500),
			 @s_l_notes_desc			NVARCHAR(500)
			 		
	 BEGIN
		IF EXISTS(SELECT arbitrator_id FROM tblEvent WHERE arbitrator_id = @i_a_ARBITRATOR_ID and  DomainID =@s_a_DomainID )
		OR EXISTS(SELECT Arbitrator_ID FROM tblcase WHERE Arbitrator_ID = @i_a_ARBITRATOR_ID and  DomainID =@s_a_DomainID)
	    BEGIN
	       SET @s_l_message	=  'Judge/Arbitrator exists in Case..!!!'
	    END
	    ELSE
			
	 BEGIN
	
			BEGIN TRAN	        
	        DELETE FROM TblArbitrator  WHERE ARBITRATOR_ID = @i_a_ARBITRATOR_ID and  DomainID =@s_a_DomainID 
	        
			SET @s_l_message    = 'Judge/Arbitrator deleted'
			SET @s_l_notes_desc = 'Judge/Arbitrator deleted - ' + @s_a_ARBITRATOR_NAME 
		    
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_Created_By_User,@s_a_notes_type='Arbitrator',@DomainID =@s_a_DomainID 
		    
		    COMMIT TRAN 
		END	
		
		SELECT @s_l_message AS [MESSAGE]
		
	 END	
END

