CREATE PROCEDURE [dbo].[F_Case_Update_Provider]    
(    
	@s_a_case_id			NVARCHAR(10),  
	@s_a_user_name			NVARCHAR(50),
	@s_a_case_provider_old	NVARCHAR(200),        	
	@s_a_case_provider_new	NVARCHAR(200),
	@s_a_case_providerid NVARCHAR(10)
)    
AS    
BEGIN      
	SET NOCOUNT ON     

	DECLARE @s_l_message VARCHAR(MAX)  
	DECLARE @desc varchar(200)
	
	
	UPDATE tblcase 
	SET Provider_Id = @s_a_case_providerid
	WHERE Case_Id = @s_a_case_id

	SET @desc = 'Provider changed from ' + @s_a_case_provider_old +' to '+@s_a_case_provider_new
	exec F_Add_Activity_Notes @s_a_case_id=@s_a_Case_Id,@s_a_notes_type='Activity',@s_a_ndesc = @desc,@s_a_user_Id=@s_a_user_name,@i_a_applytogroup = 0
			
	SET @s_l_message = 'Case provider updated successfully'   
  
	SELECT @s_l_message AS [MESSAGE], @s_a_case_id AS [RESULT],Provider_Name,tblcase.Provider_Id FROM tblcase 
	INNER JOIN TblProvider ON TblProvider.Provider_Id = tblcase.Provider_Id
	WHERE Case_Id =    @s_a_case_id    
	
	SET NOCOUNT OFF       
END

