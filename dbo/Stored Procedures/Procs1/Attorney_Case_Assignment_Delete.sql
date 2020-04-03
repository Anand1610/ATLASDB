


CREATE PROCEDURE [dbo].[Attorney_Case_Assignment_Delete]
(
	@i_a_Attorney_Assign_Id			INT,
	@i_a_Attorney_Id			INT,
	@i_a_Attorney_Type_Id			INT,
	@i_a_Case_Id			NVARCHAR(50),
    @s_a_DomainID			VARCHAR(50),
	@s_a_Created_By_User	VARCHAR(100)
  
)

AS
BEGIN
	 DECLARE @s_l_message				NVARCHAR(500),
			 @s_l_notes_desc			NVARCHAR(500)


	
	    BEGIN
			BEGIN TRAN
	        
	        DELETE FROM tblAttorney_Case_Assignment  WHERE Assignment_Id = @i_a_Attorney_Assign_Id and  DomainID =@s_a_DomainID 
	        
			SET @s_l_message	= 'Attorney deleted'
			SET @s_l_notes_desc = 'Attorney deleted of Type ' + (Select Attorney_Type from tblAttorney_Type WHERE Attorney_Type_Id=@i_a_Attorney_Type_Id) + ' for Case ID -'+@i_a_Case_Id
		    
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_Created_By_User,@s_a_notes_type='Attorney',@DomainID =@s_a_DomainID 
		    
		    COMMIT TRAN 
		END	
		
		SELECT @s_l_message AS [MESSAGE]
		
	 	
END


