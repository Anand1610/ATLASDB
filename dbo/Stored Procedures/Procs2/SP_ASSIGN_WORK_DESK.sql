CREATE PROCEDURE [dbo].[SP_ASSIGN_WORK_DESK]
@DomainId			NVARCHAR(50),
@CASE_ID			NVARCHAR(50)=null,
@To_User_ID			int=null,
@Login_User_ID		int=null,
@Login_User_Name	nvarchar(50)=null,
@From_User_Id		int=null,
@From_User_Name		nvarchar(50)=null,
@History_Id			int =null

AS BEGIN

	Set @Login_User_Id=(Select top 1 UserID from IssueTracker_Users  where userid=@To_User_ID and @DomainId=DomainId)

SET @CASE_ID=(LTRIM(RTRIM(@CASE_ID)))
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
		@Login_User_Id,
		@From_User_Id,
		@To_User_ID,
		getdate(),
		null,
		1
	)
declare @desc nvarchar(500)

declare @to_username as nvarchar(50)

set @to_username = (select top 1 username from IssueTracker_Users  where userid=@To_User_ID and @DomainId=DomainId)
set @desc = 'Assigned To changed to ' + @to_username       
exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@Login_User_Name,@ApplyToGroup = 0        

				----if Exists(select username from IssueTracker_Users  where username = @Login_User_Name and UserName not like 'ls-%' and DomainId=@DomainId) 
				----begin
				----if Exists(select username from IssueTracker_Users  where username =@to_username and DomainId=@DomainId and UserName like 'ls-%' and ((select Status from tblcase  where Case_Id =@case_id and DomainId=@DomainId) ='Pending')) 
				----	begin
				----	  update tblcase  set Status='PENDING - RESOLVED' where Case_Id =@CASE_ID and DomainId=@DomainId
				----		set @desc = 'Status changed from PENDING to PENDING - RESOLVED'   
				----		exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@Login_User_Name,@ApplyToGroup = 0
				----	end
				----end
				----if Exists(select username from IssueTracker_Users  where username =@Login_User_Name and UserName not like 'ls-%' and DomainId=@DomainId) 
				----begin
				----	if Exists(select username from IssueTracker_Users  where username =@to_username and DomainId=@DomainId and UserName like 'ls-%' and ((select Status from tblcase  where Case_Id =@case_id and DomainId=@DomainId) ='AAA pending'))
				----	begin
				----	  update tblcase  set Status='AAA PENDING- RESOLVED' where Case_Id =@CASE_ID and @DomainId=DomainId
				----		set @desc = 'Status changed from AAA PENDING to AAA PENDING- RESOLVED'   
				----		exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@Login_User_Name,@ApplyToGroup = 0
				----	end
				----end
				----if Exists(select username from IssueTracker_Users  where username =@Login_User_Name and UserName not like 'ls-%' and @DomainId=DomainId) 
				----begin
				----	if Exists(select username from IssueTracker_Users  where @DomainId=DomainId and username =@to_username and UserName like 'ls-%' and ((select Status from tblcase  where Case_Id =@case_id and @DomainId=DomainId) ='AAA PPO PENDING'))
				----	begin
				----	  update tblcase  set Status='AAA PPO PENDING- RESOLVED' where Case_Id =@CASE_ID and @DomainId=DomainId
				----		set @desc = 'Status changed from AAA PPO PENDING to AAA PPO PENDING- RESOLVED'   
				----		exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@Login_User_Name,@ApplyToGroup = 0
				----	end
				----end
END

