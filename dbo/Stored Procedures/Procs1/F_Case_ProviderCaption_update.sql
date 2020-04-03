CREATE PROCEDURE[dbo].[F_Case_ProviderCaption_update]    
(    
	@s_a_case_id			NVARCHAR(10),  
	@s_a_user_name			NVARCHAR(50),
	@s_a_case_ProviderCaption_new	NVARCHAR(200)
)    
AS    
BEGIN      
	SET NOCOUNT ON     

	DECLARE @s_l_message VARCHAR(MAX)  
	DECLARE @desc varchar(200)
	
	
	UPDATE tblcase 
	SET Provider_Caption  = @s_a_case_ProviderCaption_new
	WHERE Case_Id = @s_a_case_id


	SET @s_l_message = 'Case ProviderCaption updated successfully'   
  
	SET @desc = 'ProviderCaption changed to '+@s_a_case_ProviderCaption_new
	exec F_Add_Activity_Notes @s_a_case_id=@s_a_Case_Id,@s_a_notes_type='Activity',@s_a_ndesc = @desc,@s_a_user_Id=@s_a_user_name,@i_a_applytogroup = 0
	  
	SELECT @s_l_message AS [MESSAGE], @s_a_case_id AS [RESULT],Provider_Caption AS Provider_Caption FROM tblcase 
	INNER JOIN TblProvider ON tblprovider.Provider_Id = tblcase.Provider_Id
	WHERE Case_Id =    @s_a_case_id    
	
	SET NOCOUNT OFF       
END

