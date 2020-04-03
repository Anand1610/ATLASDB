CREATE PROCEDURE [dbo].[F_ECMC_Delete]--[dbo].[F_ECMC_Retrieve] 'FH13-160356','24343','21ST CENTURY ASSURANCE COMPANY','4354','2013-10-17 17:00:00.000',-1,'ERIC'
	(								
		@s_a_FHKP_case_id NVARCHAR(50),
		@s_a_user_name NVARCHAR(50)
	)
	AS
	BEGIN
	DECLARE @desc varchar(200),
			@s_l_message NVARCHAR(500),
			@strsql varchar(MAX),
			@denialreason_type VARCHAR(8000)
		
		DELETE FROM ECMC WHERE FHKP_Case_Id=@s_a_FHKP_case_id
		
		DELETE FROM tbl_Case_Denial WHERE Case_Id=@s_a_FHKP_case_id
		
		SET @s_l_message	=  'ECMC Data Deleted successfuly'
		
		
		 SET @desc = 'ECMC Case deleted'
		EXEC F_Add_Activity_Notes @s_a_case_id=@s_a_FHKP_case_id,@s_a_notes_type='Activity',@s_a_ndesc = @desc,@s_a_user_Id=@s_a_user_name,@i_a_applytogroup = 0
	
		SELECT @s_l_message AS [MESSAGE]
		 
	END

