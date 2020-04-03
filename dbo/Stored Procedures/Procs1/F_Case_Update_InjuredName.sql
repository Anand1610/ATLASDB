CREATE PROCEDURE[dbo].[F_Case_Update_InjuredName]    
(    
	@s_a_case_id			NVARCHAR(10),  
	@s_a_user_name			NVARCHAR(50),
	@s_a_case_InjuredName_old	NVARCHAR(200),        	
	@s_a_case_InjuredFirstName_new	NVARCHAR(200),
	@s_a_case_InjuredLastName_new	NVARCHAR(200)
)    
AS    
BEGIN      
	SET NOCOUNT ON     

	DECLARE @s_l_message VARCHAR(MAX)  
	DECLARE @desc varchar(200)
	DECLARE @s_l_InjuredParty_Name_Old NVARCHAR(200)
	DECLARE @s_l_InjuredParty_Name_New NVARCHAR(200)
	
	SELECT @s_l_InjuredParty_Name_Old = ISNULL(cas.InjuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InjuredParty_LastName, N'')
	FROM tblCase cas
	WHERE cas.Case_Id = @s_a_case_id
	
	UPDATE tblcase 
	SET InjuredParty_FirstName=@s_a_case_InjuredFirstName_new, InjuredParty_LastName =@s_a_case_InjuredLastName_new
	WHERE Case_Id = @s_a_case_id
	
	SELECT @s_l_InjuredParty_Name_New = ISNULL(cas.InjuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InjuredParty_LastName, N'')
	FROM tblCase cas
	WHERE cas.Case_Id = @s_a_case_id

	IF (@s_l_InjuredParty_Name_Old <> @s_l_InjuredParty_Name_New)
	BEGIN
		SET @desc = 'Injured Name changed from ' + @s_l_InjuredParty_Name_Old +' to '+@s_l_InjuredParty_Name_New
		exec F_Add_Activity_Notes @s_a_case_id=@s_a_Case_Id,@s_a_notes_type='Activity',@s_a_ndesc = @desc,@s_a_user_Id=@s_a_user_name,@i_a_applytogroup = 0
	END	
		
	SET @s_l_message = 'Injured Name updated successfully'   
  
	SELECT @s_l_message AS [MESSAGE], @s_a_case_id AS [RESULT],@s_l_InjuredParty_Name_New as InjuredParty_Name FROM tblcase 
	WHERE Case_Id =    @s_a_case_id    
	
	SET NOCOUNT OFF       
END

