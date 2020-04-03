CREATE PROCEDURE [dbo].[F_Case_Settlement_Reset]

	(
		@s_a_case_id NVARCHAR(100),
		@s_a_user_name NVARCHAR(10)
	)

	AS
BEGIN
	DELETE FROM tblSettlements WHERE Case_Id = +@s_a_case_id

	UPDATE TBLCASE SET STATUS=Old_Status WHERE Case_Id = +@s_a_case_id
	
	
	DECLARE @desc varchar(2000)
	 
	SET @desc = 'Case Reset with/by ' + @s_a_user_name +' '+ (select Convert(Varchar(10),GETDATE(),101))
	exec F_Add_Activity_Notes @s_a_case_id=@s_a_Case_Id,@s_a_notes_type='Activity',@s_a_ndesc = @desc,@s_a_user_Id=@s_a_user_name,@i_a_applytogroup = 0

END

