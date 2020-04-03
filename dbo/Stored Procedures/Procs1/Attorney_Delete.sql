

CREATE PROCEDURE [dbo].[Attorney_Delete]
(
	@i_a_Attorney_Id			INT,
	@s_a_Attorney_Name				VARCHAR(100),
    @s_a_DomainID			VARCHAR(50),
	@s_a_Created_By_User	VARCHAR(100)
  
)

AS
BEGIN
	 DECLARE @s_l_message				NVARCHAR(500),
			 @s_l_notes_desc			NVARCHAR(500)


	 BEGIN
		IF EXISTS(SELECT Attorney_Id FROM tblcase WHERE Attorney_Id = @i_a_Attorney_Id and  DomainID =@s_a_DomainID )
		OR EXISTS(SELECT Attorney_Id FROM tblcase WHERE DomainID =@s_a_DomainID AND Attorney_Id IN (SELECT Attorney_Id from tblAttorney WHERE Attorney_AutoId = @i_a_Attorney_Id and  DomainID =@s_a_DomainID ))
	    BEGIN
	       SET @s_l_message	=  'Attorney exists in Case..!!!'
	    END
	    ELSE
	    BEGIN
			BEGIN TRAN
	        
	        DELETE FROM tblAttorney  WHERE Attorney_Id = @i_a_Attorney_Id and  DomainID =@s_a_DomainID 
	        
			SET @s_l_message	= 'Attorney deleted'
			SET @s_l_notes_desc = 'Attorney deleted - ' + @s_a_Attorney_Name 
		    
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_Created_By_User,@s_a_notes_type='Attorney',@DomainID =@s_a_DomainID 
		    
		    COMMIT TRAN 
		END	
		
		SELECT @s_l_message AS [MESSAGE]
		
	 END	
END

