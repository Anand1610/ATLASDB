CREATE PROCEDURE [dbo].[REASSIGN_CASE] --[REASSIGN_CASE]'FH10-73324','srichardson','system','tech'
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
	SET @REASSIGN_ID = (SELECT UserId FROM ISSUETRACKER_USERS WHERE USERNAME='la-supriya.a' and DomainId=@DomainId)

	SET @HISTORY_ID = (SELECT TOP 1 HISTORY_ID FROM TBLCASEDESKHISTORY WHERE CASE_ID=@CASE_ID AND To_User_Id = @CURRENT_ASSIGNTOUSERID and DomainId=@DomainId)
	IF @HISTORY_ID <> NULL OR @HISTORY_ID <> 0
	BEGIN
		DELETE FROM TBLCASEDESKHISTORY WHERE HISTORY_ID = @HISTORY_ID
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
				@CURRENT_ASSIGNBYUSERID,
				GETDATE(),
				'PENDING - RE-ASSIGNED',
				1,
				@DomainId
			)

		declare @desc nvarchar(500)
		declare @REASSIGN_USERNAME as nvarchar(50)

		set @REASSIGN_USERNAME = @CURRENT_ASSIGNBYUSERNAME--(select username from issuetracker_users where userid=@REASSIGN_ID)
		set @desc = 'Case re-assigned to ' + @REASSIGN_USERNAME       
		exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@LOGIN_USERNAME,@ApplyToGroup = 0
	if Exists(select username from IssueTracker_Users where USERID =@CURRENT_ASSIGNBYUSERID and UserName like 'la-%' and ((select Status from tblcase where Case_Id =@case_id and DomainId=@DomainId) ='Pending'))
	begin
	  update tblcase set Status='PENDING - RESOLVED' where Case_Id =@CASE_ID  and DomainId=@DomainId
	    set @desc = 'Status changed from PENDING to PENDING - RESOLVED'   
		exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@LOGIN_USERNAME,@ApplyToGroup = 0
	end
	if Exists(select username from IssueTracker_Users where USERID =@CURRENT_ASSIGNBYUSERID and UserName like 'la-%' and ((select Status from tblcase where Case_Id =@case_id and DomainId=@DomainId) ='AAA pending'))
	begin
	  update tblcase set Status='AAA PENDING- RESOLVED' where Case_Id =@CASE_ID  and DomainId=@DomainId
		set @desc = 'Status changed from AAA PENDING to AAA PENDING- RESOLVED'   
		exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@LOGIN_USERNAME,@ApplyToGroup = 0
	end
	if Exists(select username from IssueTracker_Users where USERID =@CURRENT_ASSIGNBYUSERID and UserName like 'la-%' and ((select Status from tblcase where Case_Id =@case_id and DomainId=@DomainId) ='AAA PPO PENDING'))
	begin
	  update tblcase set Status='AAA PPO PENDING- RESOLVED' where Case_Id =@CASE_ID  and DomainId=@DomainId
		set @desc = 'Status changed from AAA PPO PENDING to AAA PPO PENDING- RESOLVED'   
		exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@LOGIN_USERNAME,@ApplyToGroup = 0
	end
		if Exists(select username from IssueTracker_Users where USERID =@CURRENT_ASSIGNBYUSERID and UserName like 'la-%' and ((select Status from tblcase where Case_Id =@case_id and DomainId=@DomainId) like 'AAA PACKAGE INCOMPLETE%'))
	begin
	  update tblcase set Status='AAA ISSUE RESOLVED' where Case_Id =@CASE_ID  and DomainId=@DomainId
		set @desc = 'Status changed from AAA PACKAGE INCOMPLETE... to AAA ISSUE RESOLVED'   
		exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@LOGIN_USERNAME,@ApplyToGroup = 0
	end
	END	
END

