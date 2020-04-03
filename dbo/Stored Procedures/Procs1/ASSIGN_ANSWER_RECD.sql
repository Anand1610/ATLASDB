CREATE PROCEDURE [dbo].[ASSIGN_ANSWER_RECD]
	@DomainId NVARCHAR(50),
	@CASEID VARCHAR(100)
AS
BEGIN
	DECLARE @JOEUSER_ID AS VARCHAR(50)
	DECLARE @ERINUSER_ID AS VARCHAR(50)
	DECLARE @DANAUSER_ID AS VARCHAR(50)
	DECLARE @desc AS VARCHAR(200)
	SET @JOEUSER_ID = (SELECT USERID FROM IssueTracker_Users WHERE USERNAME = 'jarmao' and DomainId=@DomainId)
	SET @ERINUSER_ID = (SELECT USERID FROM IssueTracker_Users WHERE USERNAME = 'estamper' and DomainId=@DomainId)
	SET @DANAUSER_ID = (SELECT USERID FROM IssueTracker_Users WHERE USERNAME = 'dgold' and DomainId=@DomainId)

	--JOE ARMAO
	IF NOT EXISTS(select top 1 1 from tblcasedeskhistory where case_id=@CASEID and To_User_Id = @JOEUSER_ID AND BT_STATUS=1  and DomainId=@DomainId)	
	BEGIN
		insert into tblCaseDeskHistory
			(
				DomainId,
				Case_Id,
				Login_User_ID,
				From_User_ID,
				To_User_ID,
				Date_Changed,
				Change_Reason,
				Bt_Status
			)
			values
			(
				@DomainId,
				@CASEID,
				0,
				NULL,
				@JOEUSER_ID,
				getdate(),
				'ANSWER RECEIVED',
				1
			)

			SET @desc = 'Assigned To changed to jarmao'
			exec F_Add_Activity_Notes @DomainId=@DomainId,@s_a_case_id=@CASEID,@s_a_notes_type='Activity',@s_a_ndesc = @desc,@s_a_user_Id='system',@i_a_applytogroup = 0
	END
	--ERIN STAMPER
	IF NOT EXISTS(select top 1 1 from tblcasedeskhistory where case_id=@CASEID and To_User_Id = @ERINUSER_ID AND BT_STATUS=1 and DomainId=@DomainId)
	BEGIN
		insert into tblCaseDeskHistory
			(
				DomainId,
				Case_Id,
				Login_User_ID,
				From_User_ID,
				To_User_ID,
				Date_Changed,
				Change_Reason,
				Bt_Status
			)
			values
			(
				@DomainId,
				@CASEID,
				0,
				null,
				@ERINUSER_ID,
				getdate(),
				'ANSWER RECEIVED',
				1
			)

			SET @desc = 'Assigned To changed to estamper'
			exec F_Add_Activity_Notes @DomainId=@DomainId,@s_a_case_id=@CASEID,@s_a_notes_type='Activity',@s_a_ndesc = @desc,@s_a_user_Id='system',@i_a_applytogroup = 0
	END
	--DANA GOLD
	IF NOT EXISTS(select top 1 1 from tblcasedeskhistory where case_id=@CASEID and To_User_Id = @DANAUSER_ID AND BT_STATUS=1 and DomainId=@DomainId)
	BEGIN
		insert into tblCaseDeskHistory
			(
				DomainId,
				Case_Id,
				Login_User_ID,
				From_User_ID,
				To_User_ID,
				Date_Changed,
				Change_Reason,
				Bt_Status
			)
			values
			(
				@DomainId,
				@CASEID,
				0,
				null,
				@DANAUSER_ID,
				getdate(),
				'ANSWER RECEIVED',
				1
			)

			SET @desc = 'Assigned To changed to dgold'
			exec F_Add_Activity_Notes @DomainId=@DomainId,@s_a_case_id=@CASEID,@s_a_notes_type='Activity',@s_a_ndesc = @desc,@s_a_user_Id='system',@i_a_applytogroup = 0
	END
END

