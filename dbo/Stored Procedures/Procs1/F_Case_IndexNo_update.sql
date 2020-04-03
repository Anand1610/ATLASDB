CREATE PROCEDURE[dbo].[F_Case_IndexNo_update]    
(    
	@s_a_case_id			NVARCHAR(10),  
	@s_a_user_name			NVARCHAR(50),
	@s_a_case_IndexNo_new	NVARCHAR(200)
)    
AS    
BEGIN      
	SET NOCOUNT ON     

	DECLARE @s_l_message VARCHAR(MAX)  
	DECLARE @desc varchar(200)
	
	
	UPDATE tblcase 
	SET IndexOrAAA_Number  = @s_a_case_IndexNo_new
	WHERE Case_Id = @s_a_case_id

	SET @desc = 'IndexNo changed from to '+@s_a_case_IndexNo_new
	exec F_Add_Activity_Notes @s_a_case_id=@s_a_Case_Id,@s_a_notes_type='Activity',@s_a_ndesc = @desc,@s_a_user_Id=@s_a_user_name,@i_a_applytogroup = 0
	
	SET @s_l_message = 'Case IndexNo updated successfully'   
	SELECT @s_l_message AS [MESSAGE], @s_a_case_id AS [RESULT],IndexOrAAA_Number FROM tblcase 
	WHERE Case_Id =    @s_a_case_id    
	
	SET NOCOUNT OFF       
END

