CREATE PROCEDURE [dbo].[F_Case_Update_InsuranceCompany]    
(    
	@s_a_case_id			NVARCHAR(10),  
	@s_a_user_name			NVARCHAR(50),
	@s_a_case_InsuranceCompany_old	NVARCHAR(200),        	
	@s_a_case_InsuranceCompany_new	NVARCHAR(200),
	@s_a_case_InsuranceCompanyId NVARCHAR(10)
)    
AS    
BEGIN      
	SET NOCOUNT ON     

	DECLARE @s_l_message VARCHAR(MAX)  
	DECLARE @desc varchar(200)
	
	
	UPDATE tblcase 
	SET InsuranceCompany_Id = @s_a_case_InsuranceCompanyId
	WHERE Case_Id = @s_a_case_id

	SET @desc = 'InsuranceCompany changed from ' + @s_a_case_InsuranceCompany_old +' to '+@s_a_case_InsuranceCompany_new
	exec F_Add_Activity_Notes @s_a_case_id=@s_a_Case_Id,@s_a_notes_type='Activity',@s_a_ndesc = @desc,@s_a_user_Id=@s_a_user_name,@i_a_applytogroup = 0
			
	SET @s_l_message = 'Case InsuranceCompany updated successfully'   
  
	SELECT @s_l_message AS [MESSAGE], @s_a_case_id AS [RESULT],InsuranceCompany_Name,tblcase.InsuranceCompany_Id FROM tblcase 
	INNER JOIN TblInsuranceCompany ON tblInsuranceCompany.InsuranceCompany_Id = tblcase.InsuranceCompany_Id
	WHERE Case_Id =    @s_a_case_id    
	
	SET NOCOUNT OFF       
END

