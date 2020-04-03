CREATE PROCEDURE [dbo].[F_Case_Update_InitialStatus]    
(    
	@DomainId				NVARCHAR(50),
	@s_a_case_id			NVARCHAR(50),  
	@s_a_user_name			NVARCHAR(50),
	@s_a_case_InitialStatus_old	NVARCHAR(200),        	
	@s_a_case_InitialStatus_new	NVARCHAR(200),
	@s_a_case_InitialStatusId	NVARCHAR(10)
)    
AS    
BEGIN      
	SET NOCOUNT ON     
	DECLARE @i_l_count  INT     
	DECLARE @s_l_message VARCHAR(MAX)  
	
	declare @desc varchar(200)

			UPDATE tblcase  
			SET Initial_Status = @s_a_case_InitialStatus_new
			WHERE Case_Id = @s_a_case_id
			AND DomainId = @DomainId
			
			SET @desc = 'Case Initial Status changed from ' + @s_a_case_InitialStatus_old +' to '+@s_a_case_InitialStatus_new
			exec F_Add_Activity_Notes @DomainId=@DomainId, @s_a_case_id=@s_a_Case_Id,@s_a_notes_type='Activity',@s_a_ndesc = @desc,@s_a_user_Id=@s_a_user_name,@i_a_applytogroup = 0
	
	SET @s_l_message = 'Case Initial Status updated successfully'   
  
	SELECT @s_l_message AS [MESSAGE], @s_a_case_id AS [RESULT], Initial_Status,@s_a_case_InitialStatusId as Initial_StatusId  FROM tblcase  WHERE Case_Id = @s_a_case_id and DomainId = @DomainId
	
	SET NOCOUNT OFF       
END

