CREATE PROCEDURE [dbo].[F_CaseDeskHistory_Delete]
(	
	@i_a_history_id INT,
	@s_a_CaseId NVARCHAR(100),
	@s_a_UserName NVARCHAR(100)
)
AS
BEGIN
	DECLARE @s_l_message VARCHAR(MAX)   	

	DELETE FROM tblCaseDeskHistory WHERE History_Id = @i_a_history_id AND BT_STATUS=1
	
	SET @s_l_message = 'Assigned Case deleted successfully...!!'
	
	
	IF EXISTS(SELECT 1 FROM TXN_ASSIGN_SETTLED_CASES WHERE CASE_ID=@s_a_CaseId and USER_ID=@s_a_UserName and isChanged=1)
	BEGIN
		UPDATE TXN_ASSIGN_SETTLED_CASES SET isChanged = 0, DATE_CHANGED = getdate() WHERE CASE_ID=@s_a_CaseId and USER_ID=@s_a_UserName and isChanged=1
	END
		

	exec F_Add_Activity_Notes @s_a_case_id=@s_a_CaseId,@s_a_notes_type='Activity',@s_a_ndesc = 'Case deleted from default desk!' ,@s_a_user_Id=@s_a_UserName,@i_a_applytogroup = 0

	SELECT @s_l_message AS [Message]
END

