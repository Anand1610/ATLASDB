CREATE PROCEDURE [dbo].[sp_assign_pending_work_desk]
	@DomainId VARCHAR(50),
	@Case_Id VARCHAR(100)
AS
BEGIN
	IF NOT EXISTS(SELECT * FROM tblcasedeskhistory  where Case_Id = @Case_Id and DomainId=@DomainId)
	BEGIN
		declare @To_User_ID as int
		set @To_User_ID = (select UserId from IssueTracker_Users  where DomainId=@DomainId and UserName = (select top 1 User_Id from tblnotes where case_id=@Case_Id and notes_desc like '%Case Opened%'))
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
			@CASE_ID,
			0,
			0,
			@To_User_ID,
			getdate(),
			null,
			1
		)
	END
END

