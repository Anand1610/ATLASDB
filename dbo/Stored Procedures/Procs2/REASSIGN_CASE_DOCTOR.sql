﻿CREATE PROCEDURE [dbo].[REASSIGN_CASE_DOCTOR] --'FH10-73702','lauren','tech','lauren'
	@DomainId NVARCHAR(50),
	@CASE_ID VARCHAR(50),
	@CURRENT_ASSIGNTOUSERNAME VARCHAR(50),
	@CURRENT_ASSIGNBYUSERNAME VARCHAR(50),
	@LOGIN_USERNAME VARCHAR(50)
AS
BEGIN
	DECLARE @CURRENT_ASSIGNTOUSERID AS INT
	DECLARE @CURRENT_ASSIGNBYUSERID AS INT
	DECLARE @LOGIN_USERID AS INT
	DECLARE @REASSIGN_ID AS INT
	DECLARE @HISTORY_ID AS INT

	SET @CURRENT_ASSIGNTOUSERID = (SELECT UserId FROM ISSUETRACKER_USERS WHERE USERNAME=@CURRENT_ASSIGNTOUSERNAME and DomainId=@DomainId)
	SET @CURRENT_ASSIGNBYUSERID = (SELECT UserId FROM ISSUETRACKER_USERS WHERE USERNAME=@CURRENT_ASSIGNBYUSERNAME and DomainId=@DomainId)
	SET @LOGIN_USERID = (SELECT UserId FROM ISSUETRACKER_USERS WHERE USERNAME=@LOGIN_USERNAME)
	SET @REASSIGN_ID = (SELECT UserId FROM ISSUETRACKER_USERS WHERE USERNAME='estamper' and DomainId=@DomainId)

	SET @HISTORY_ID = (SELECT TOP 1 HISTORY_ID FROM TBLCASEDESKHISTORY WHERE CASE_ID=@CASE_ID AND To_User_Id = @CURRENT_ASSIGNTOUSERID and DomainId=@DomainId)
	IF @HISTORY_ID <> NULL OR @HISTORY_ID <> 0
	BEGIN
		UPDATE TBLCASEDESKHISTORY SET BT_STATUS = 0 WHERE HISTORY_ID = @HISTORY_ID and DomainId=@DomainId
		INSERT INTO 
			TBLCASEDESKHISTORY
			(
				Case_Id,
				Login_User_Id,
				From_User_Id,
				To_User_Id,
				Date_Changed,
				Change_Reason,
				bt_status,
				DomainId
			)
		VALUES
			(
				@CASE_ID,
				@LOGIN_USERID,
				@CURRENT_ASSIGNTOUSERID,
				@REASSIGN_ID,
				GETDATE(),
				'RE-ASSIGNED by ' + @LOGIN_USERNAME,
				1,
				@DomainId
			)

		declare @desc nvarchar(500)

		declare @REASSIGN_USERNAME as nvarchar(50)

		set @REASSIGN_USERNAME = (select username from issuetracker_users where userid=@REASSIGN_ID and DomainId=@DomainId)
		set @desc = 'Case re-assigned to ' + @REASSIGN_USERNAME       
		exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@LOGIN_USERNAME,@ApplyToGroup = 0
	END	
END

