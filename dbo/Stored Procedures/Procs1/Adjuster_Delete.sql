

CREATE PROCEDURE [dbo].[Adjuster_Delete]
(
	@i_a_Adjuster_Id			INT,
	@s_a_Adjuster_Name				VARCHAR(100),
    @s_a_DomainID			VARCHAR(50),
	@s_a_Created_By_User	VARCHAR(100)
  
)

AS
BEGIN
	 DECLARE @s_l_message				NVARCHAR(500),
			 @s_l_notes_desc			NVARCHAR(500)
			
	 BEGIN
		IF EXISTS(SELECT Adjuster_Id FROM tblcase WHERE Adjuster_Id = @i_a_Adjuster_Id and  DomainID =@s_a_DomainID )
	    BEGIN
	       SET @s_l_message	=  'Adjuster exists in Case..!!!'
	    END
	    ELSE
	    BEGIN
			BEGIN TRAN
	        
	        DELETE FROM tblAdjusters  WHERE Adjuster_Id = @i_a_Adjuster_Id and  DomainID =@s_a_DomainID 
	        
			SET @s_l_message	= 'Adjuster deleted'
			SET @s_l_notes_desc = 'Adjuster deleted - ' + @s_a_Adjuster_Name 
		    
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_Created_By_User,@s_a_notes_type='Adjuster',@DomainID =@s_a_DomainID 
		    
		    COMMIT TRAN 
		END	
		
		SELECT @s_l_message AS [MESSAGE]
		
	 END	
END

