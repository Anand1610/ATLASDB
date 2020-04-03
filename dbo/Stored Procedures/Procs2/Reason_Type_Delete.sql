
CREATE PROCEDURE [dbo].[Reason_Type_Delete]
(
   @i_a_DenialReasons_Id   INT,
   @s_a_DenialReasons_Type VARCHAR(100),
   @s_a_DomainID           VARCHAR(50),
   @s_a_Created_By_User    VARCHAR(100)  
)
AS
BEGIN
	 DECLARE @s_l_message	 NVARCHAR(500),
			 @s_l_notes_desc NVARCHAR(500)			
	 BEGIN
		IF EXISTS(SELECT DenialReasons_Type FROM tblTreatment WHERE DenialReasons_Type = @s_a_DenialReasons_Type and  DomainID =@s_a_DomainID)	
		OR EXISTS (SELECT DenialReasons_Id FROM TXN_tblTreatment WHERE DenialReasons_Id = @i_a_DenialReasons_Id and  DomainID =@s_a_DomainID)
	    BEGIN
	       SET @s_l_message	=  'Reason type exists in Case Treatment..!!!'
	    END
	    ELSE 
	    BEGIN
			BEGIN TRAN
	        	        
		    DELETE FROM tblDenialReasons  WHERE DenialReasons_Id = @i_a_DenialReasons_Id and  DomainID =@s_a_DomainID 
	        
			SET @s_l_message    = 'Reason type deleted'
			SET @s_l_notes_desc = 'Reason type deleted - ' + @s_a_DenialReasons_Type 
		    
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_Created_By_User,@s_a_notes_type='Reason_Type',@DomainID =@s_a_DomainID 
		    
		    COMMIT TRAN 
		END	
		
		SELECT @s_l_message AS [MESSAGE]
		
	 END	
END



