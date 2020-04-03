CREATE PROCEDURE[dbo].[F_Case_DateOfAccident_update]    
(    
	@s_a_case_id			NVARCHAR(10),  
	@s_a_user_name			NVARCHAR(50),
	@s_a_case_DateOfAccident_new	NVARCHAR(200)
)    
AS    
BEGIN      
	SET NOCOUNT ON     

	DECLARE @s_l_message VARCHAR(MAX)  
	DECLARE @desc varchar(200)
	
	
	UPDATE tblcase 
	SET Accident_Date  = @s_a_case_DateOfAccident_new
	WHERE Case_Id = @s_a_case_id


	SET @s_l_message = 'Accident Date updated successfully'   
	SELECT @s_l_message AS [MESSAGE], @s_a_case_id AS [RESULT],convert(varchar(50),Accident_Date,101)Accident_Date FROM tblcase 
	WHERE Case_Id =    @s_a_case_id    
	
	SET NOCOUNT OFF       
END

