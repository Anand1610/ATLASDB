CREATE PROCEDURE [dbo].[ASSIGN_PENDINGCASES_TO_CASE_OPENER]
	@DomainId nvarchar(50),
	@CASEID VARCHAR(100)
AS
BEGIN
	DECLARE @CASEOPENERUSER_ID AS VARCHAR(50)
	DECLARE @CASEOPENERUSER_NAME AS VARCHAR(50)
	DECLARE @desc AS VARCHAR(200)
	SET @CASEOPENERUSER_ID = (SELECT TOP 1 USERID FROM ISSUETRACKER_USERS WHERE DomainId=@DomainId and USERNAME = (SELECT TOP 1 User_Id FROM TBLNOTES WHERE CASE_ID=@CASEID AND NOTES_DESC='Case Opened'))
	SET @CASEOPENERUSER_NAME = (SELECT TOP 1 User_Id FROM TBLNOTES WHERE CASE_ID=@CASEID AND NOTES_DESC='Case Opened' and DomainId=@DomainId)

	IF NOT EXISTS(select top 1 1 from tblcasedeskhistory where case_id=@CASEID and To_User_Id = @CASEOPENERUSER_ID AND BT_STATUS=1 and DomainId=@DomainId) 	
	BEGIN
		insert into tblCaseDeskHistory
			(
				Case_Id,
				Login_User_ID,
				From_User_ID,
				To_User_ID,
				Date_Changed,
				Change_Reason,
				Bt_Status,
				DomainId
			)
			values
			(
				@CASEID,
				0,
				NULL,
				@CASEOPENERUSER_ID,
				getdate(),
				'PENDING',
				1,
				@DomainId
			)

			SET @desc = 'Assigned To changed to ' + @CASEOPENERUSER_NAME
			exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@CASEID,@Notes_Type='Activity',@Ndesc = @desc,@user_Id='system',@ApplyToGroup = 0
	END
END

