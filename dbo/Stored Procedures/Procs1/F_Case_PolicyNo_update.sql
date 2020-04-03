CREATE PROCEDURE[dbo].[F_Case_PolicyNo_update]    
(    
	@s_a_case_id			NVARCHAR(10),  
	@s_a_user_name			NVARCHAR(50),
	--@s_a_case_PolicyNo_old	NVARCHAR(200),        	
	@s_a_case_PolicyNo_new	NVARCHAR(200)
)    
AS    
BEGIN      
	SET NOCOUNT ON     

	DECLARE @s_l_message VARCHAR(MAX)  
	DECLARE @desc varchar(200)
	
	
	UPDATE tblcase 
	SET Policy_Number  = @s_a_case_PolicyNo_new
	WHERE Case_Id = @s_a_case_id

	SET @desc = 'PolicyNo changed to '+@s_a_case_PolicyNo_new
	exec F_Add_Activity_Notes @s_a_case_id=@s_a_Case_Id,@s_a_notes_type='Activity',@s_a_ndesc = @desc,@s_a_user_Id=@s_a_user_name,@i_a_applytogroup = 0

	SET @s_l_message = 'Case PolicyNo updated successfully'   
	SELECT @s_l_message AS [MESSAGE], @s_a_case_id AS [RESULT],Policy_Number FROM tblcase 
	WHERE Case_Id =    @s_a_case_id    
	
	SET NOCOUNT OFF       
END

