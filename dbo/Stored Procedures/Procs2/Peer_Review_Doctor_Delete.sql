
CREATE PROCEDURE [dbo].[Peer_Review_Doctor_Delete]
(
   @i_a_Doctor_id		INT,
   @s_a_Doctor_Name		VARCHAR(100),
   @s_a_DomainID        VARCHAR(50),
   @s_a_Created_By_User VARCHAR(100)
  
)
AS
BEGIN
	 DECLARE @s_l_message				NVARCHAR(500),
			 @s_l_notes_desc			NVARCHAR(500)
			 		
	 BEGIN
		IF EXISTS(SELECT Doctor_id  FROM tblcase WHERE Doctor_id  = @i_a_Doctor_id and  DomainID =@s_a_DomainID )
		OR EXISTS(SELECT Doctor_Id FROM tblTreatment WHERE Doctor_Id   = @i_a_Doctor_id and  DomainID =@s_a_DomainID)
		OR EXISTS(SELECT DOCTOR_ID FROM TXN_CASE_PEER_REVIEW_DOCTOR   WHERE DOCTOR_ID   = @i_a_Doctor_id and  DomainID =@s_a_DomainID)
	    BEGIN
	       SET @s_l_message	=  'Doctor name exists in Case..!!!'
	    END
	    ELSE
			
	 BEGIN
	
			BEGIN TRAN	        
	        DELETE FROM TblReviewingDoctor  WHERE Doctor_id  = @i_a_Doctor_id and  DomainID =@s_a_DomainID 
	        
			SET @s_l_message= 'Doctor details deleted'
			SET @s_l_notes_desc = 'Doctor details deleted - ' + @s_a_Doctor_Name 
		    
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_Created_By_User,@s_a_notes_type='Review Doctor',@DomainID =@s_a_DomainID 
		    
		    COMMIT TRAN 
		END	
		
		SELECT @s_l_message AS [MESSAGE]
		
	 END	
END

