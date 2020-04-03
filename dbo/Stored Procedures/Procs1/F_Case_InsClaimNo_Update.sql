CREATE PROCEDURE[dbo].[F_Case_InsClaimNo_Update]    
(    
	@s_a_case_id			NVARCHAR(10),  
	@s_a_user_name			NVARCHAR(50),
	@s_a_case_InsClaimNo_new	NVARCHAR(200)
)    
AS    
BEGIN      
	SET NOCOUNT ON     

	DECLARE @s_l_message VARCHAR(MAX)  
	DECLARE @desc varchar(200)
	
	
	UPDATE tblcase 
	SET Ins_Claim_Number  = @s_a_case_InsClaimNo_new
	WHERE Case_Id = @s_a_case_id


	SET @s_l_message = 'Case InsClaimNo updated successfully'   
	SELECT @s_l_message AS [MESSAGE], @s_a_case_id AS [RESULT],Ins_Claim_Number FROM tblcase 
	WHERE Case_Id =    @s_a_case_id    
	
	SET NOCOUNT OFF       
END

