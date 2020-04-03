CREATE PROCEDURE [dbo].[F_Case_Update_InsuredName]    
(    
	@s_a_case_id			NVARCHAR(10),  
	@s_a_user_name			NVARCHAR(50),
	@s_a_case_InsuredName_old	NVARCHAR(200),        	
	@s_a_case_InsuredFirstName_new	NVARCHAR(200),
	@s_a_case_InsuredLastName_new	NVARCHAR(200)
)    
AS    
BEGIN      
	SET NOCOUNT ON     

	DECLARE @s_l_message VARCHAR(MAX)  
	DECLARE @desc varchar(200)
	DECLARE @s_l_InsuredParty_Name_Old NVARCHAR(200)
	DECLARE @s_l_InsuredParty_Name_New NVARCHAR(200)
	
	SELECT @s_l_InsuredParty_Name_Old = ISNULL(cas.InsuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InsuredParty_LastName, N'')
	FROM tblCase cas
	WHERE cas.Case_Id = @s_a_case_id
	
	UPDATE tblcase 
	SET InsuredParty_FirstName=@s_a_case_InsuredFirstName_new, InsuredParty_LastName =@s_a_case_InsuredLastName_new
	WHERE Case_Id = @s_a_case_id
	
	SELECT @s_l_InsuredParty_Name_New = ISNULL(cas.InsuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InsuredParty_LastName, N'')
	FROM tblCase cas
	WHERE cas.Case_Id = @s_a_case_id

	IF (@s_l_InsuredParty_Name_Old <> @s_l_InsuredParty_Name_New)
	BEGIN
		SET @desc = 'Insured Name changed from ' + @s_l_InsuredParty_Name_Old +' to '+@s_l_InsuredParty_Name_New
		exec F_Add_Activity_Notes @s_a_case_id=@s_a_Case_Id,@s_a_notes_type='Activity',@s_a_ndesc = @desc,@s_a_user_Id=@s_a_user_name,@i_a_applytogroup = 0
	END	
		
	SET @s_l_message = 'Insured Name updated successfully'   
  
	SELECT @s_l_message AS [MESSAGE], @s_a_case_id AS [RESULT],@s_l_InsuredParty_Name_New as InsuredParty_Name FROM tblcase 
	WHERE Case_Id =    @s_a_case_id    
	
	SET NOCOUNT OFF       
END

