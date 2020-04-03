

CREATE PROCEDURE [dbo].[Assigned_Attorney_Delete]
(
   @i_a_Assigned_Attorney_Id INT,
   @s_a_Assigned_Attorney VARCHAR(100),
    @s_a_DomainID VARCHAR(50),
	@s_a_Created_By_User VARCHAR(100)
  
)

AS
BEGIN
	 DECLARE @s_l_message				NVARCHAR(500),
			 @s_l_notes_desc				NVARCHAR(500)
			
	 BEGIN
		IF EXISTS(SELECT Assigned_Attorney FROM tblcase (NOLOCK) WHERE Assigned_Attorney = @i_a_Assigned_Attorney_Id and  DomainID =@s_a_DomainID )
	    BEGIN
	       SET @s_l_message	=  'Assigned Attorney exists in Case..!!!'
	    END
	    ELSE
	    BEGIN
			BEGIN TRAN
	        
	        DELETE FROM Assigned_Attorney   WHERE PK_Assigned_Attorney_ID = @i_a_Assigned_Attorney_Id and  DomainID =@s_a_DomainID 
	        
			SET @s_l_message= 'Assigned Attorney deleted'
			SET @s_l_notes_desc = 'Assigned Attorney deleted - ' + @s_a_Assigned_Attorney 
		    
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_Created_By_User,@s_a_notes_type='Assigned Attorney',@DomainID =@s_a_DomainID 
		    
		    COMMIT TRAN 
		END	
		
		SELECT @s_l_message AS [MESSAGE]
		
	 END	
END

--  alter table tblcase add [Assigned_Attorney] [varchar](200); 
