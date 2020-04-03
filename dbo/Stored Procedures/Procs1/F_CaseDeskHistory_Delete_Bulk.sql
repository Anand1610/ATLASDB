CREATE PROCEDURE [dbo].[F_CaseDeskHistory_Delete_Bulk]
(	
	@s_a_history_id NVARCHAR(MAX),
	@s_a_UserName NVARCHAR(100)
)
AS
BEGIN
	DECLARE @s_l_message VARCHAR(MAX)   	
	
	IF EXISTS(SELECT 1 FROM TXN_ASSIGN_SETTLED_CASES WHERE CASE_ID IN  (SELECT Distinct CASE_ID FROM tblCaseDeskHistory WHERE History_Id  IN (SELECT items FROM dbo.SplitStringInt(@s_a_history_id,',')) ) AND USER_ID=@s_a_UserName and isChanged=1)
	BEGIN
		UPDATE TXN_ASSIGN_SETTLED_CASES SET isChanged = 0, DATE_CHANGED = getdate() WHERE CASE_ID IN  (SELECT Distinct CASE_ID FROM tblCaseDeskHistory WHERE History_Id  IN (SELECT items FROM dbo.SplitStringInt(@s_a_history_id,',')) ) and USER_ID=@s_a_UserName and isChanged=1
	END
	
	INSERT INTO tblNotes (Case_Id,Notes_Type,Notes_Desc,User_Id,Notes_Priority)
	SELECT Distinct CASE_ID,'Activity','Case deleted from default desk!',@s_a_UserName,0 FROM tblCaseDeskHistory WHERE History_Id  IN (SELECT items FROM dbo.SplitStringInt(@s_a_history_id,',')) 
	

	DELETE FROM tblCaseDeskHistory WHERE History_Id  IN (SELECT items FROM dbo.SplitStringInt(@s_a_history_id,','))
	
	SET @s_l_message = 'Assigned Case deleted successfully...!!'
	

	SELECT @s_l_message AS [Message]
END

