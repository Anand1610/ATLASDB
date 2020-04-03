CREATE PROCEDURE [dbo].[F_CaseDeskHistory_Reassign] 
	@s_a_CaseId VARCHAR(50),
	@s_a_AssignedTo VARCHAR(50),
	@s_a_AssignedBy VARCHAR(50),
	@s_a_UserName VARCHAR(50)
AS
BEGIN
--DBCC FREEPROCCACHE
--DBCC DROPCLEANBUFFERS	

	DECLARE @i_l_AssignedTo_ID AS INT
	DECLARE @i_l_AssignedBy_ID AS INT
	DECLARE @i_a_User_ID AS INT
	DECLARE @i_l_HISTORY_ID AS INT
      
	SET @i_l_AssignedTo_ID = (SELECT UserId FROM ISSUETRACKER_USERS WHERE USERNAME=@s_a_AssignedTo)
	SET @i_l_AssignedBy_ID = (SELECT UserId FROM ISSUETRACKER_USERS WHERE USERNAME=@s_a_AssignedBy)
	SET @i_a_User_ID = (SELECT UserId FROM ISSUETRACKER_USERS WHERE USERNAME=@s_a_UserName)


	SET @i_l_HISTORY_ID = (SELECT TOP 1 HISTORY_ID FROM TBLCASEDESKHISTORY WHERE CASE_ID=@s_a_CaseId AND To_User_Id = @i_l_AssignedTo_ID)
	IF @i_l_HISTORY_ID <> NULL OR @i_l_HISTORY_ID <> 0
	BEGIN
		DELETE FROM TBLCASEDESKHISTORY WHERE HISTORY_ID = @i_l_HISTORY_ID
		INSERT INTO 
			TBLCASEDESKHISTORY
			(
				Case_Id,
				Login_User_Id,
				From_User_Id,
				To_User_Id,
				Date_Changed,
				Change_Reason,
				bt_status
			)
		VALUES
			(
				@s_a_CaseId,
				@i_a_User_ID,
				@i_l_AssignedTo_ID,
				@i_l_AssignedBy_ID,
				GETDATE(),
				'PENDING - RE-ASSIGNED',
				1
			)

		declare @desc nvarchar(500)
		declare @s_l_Reassign_Username as nvarchar(50)

		set @s_l_Reassign_Username = @s_a_AssignedBy--(select username from issuetracker_users where userid=@REASSIGN_ID)
		set @desc = 'Case re-assigned to ' + @s_l_Reassign_Username       
		exec F_Add_Activity_Notes @s_a_case_id=@s_a_CaseId,@s_a_notes_type='Activity',@s_a_ndesc = @desc,@s_a_user_Id=@s_a_UserName,@i_a_applytogroup = 0
		
		if Exists(select username from IssueTracker_Users where USERID =@i_l_AssignedBy_ID and UserName like 'la-%' and ((select Status from tblcase where Case_Id =@s_a_CaseId) ='Pending'))
		begin
		  update tblcase set Status='PENDING - RESOLVED' where Case_Id =@s_a_CaseId 
		    set @desc = 'Status changed from PENDING to PENDING - RESOLVED'   
			exec F_Add_Activity_Notes @s_a_case_id=@s_a_CaseId,@s_a_notes_type='Activity',@s_a_ndesc = @desc,@s_a_user_Id=@s_a_UserName,@i_a_applytogroup = 0
		end
		if Exists(select username from IssueTracker_Users where USERID =@i_l_AssignedBy_ID and UserName like 'la-%' and ((select Status from tblcase where Case_Id =@s_a_CaseId) ='AAA pending'))
		begin
		  update tblcase set Status='AAA PENDING- RESOLVED' where Case_Id =@s_a_CaseId 
			set @desc = 'Status changed from AAA PENDING to AAA PENDING- RESOLVED'   
			exec F_Add_Activity_Notes @s_a_case_id=@s_a_CaseId,@s_a_notes_type='Activity',@s_a_ndesc = @desc,@s_a_user_Id=@s_a_UserName,@i_a_applytogroup = 0
		end
		if Exists(select username from IssueTracker_Users where USERID =@i_l_AssignedBy_ID and UserName like 'la-%' and ((select Status from tblcase where Case_Id =@s_a_CaseId) ='AAA PPO PENDING'))
		begin
		  update tblcase set Status='AAA PPO PENDING- RESOLVED' where Case_Id =@s_a_CaseId 
			set @desc = 'Status changed from AAA PPO PENDING to AAA PPO PENDING- RESOLVED'   
			exec F_Add_Activity_Notes @s_a_case_id=@s_a_CaseId,@s_a_notes_type='Activity',@s_a_ndesc = @desc,@s_a_user_Id=@s_a_UserName,@i_a_applytogroup = 0
		end
		END	
--DBCC FREEPROCCACHE
--DBCC DROPCLEANBUFFERS	
END

