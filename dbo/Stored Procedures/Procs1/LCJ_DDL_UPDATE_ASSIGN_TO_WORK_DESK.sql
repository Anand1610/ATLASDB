CREATE PROCEDURE [dbo].[LCJ_DDL_UPDATE_ASSIGN_TO_WORK_DESK]
@CASE_ID NVARCHAR(50),
@To_User_ID int=null,
@Login_User_ID int=null,
@Login_User_Name nvarchar(50)=null,
@From_User_Id int=null,
@From_User_Name nvarchar(50)=null,
@History_Id int =null

AS BEGIN
	Set @From_User_Id=(Select UserID from issuetracker_users where UserName=@From_User_Name)
	Set @Login_User_Id=(Select UserID from issuetracker_users where UserName=@Login_User_Name)
	Set @From_User_Id=(Select UserID from tblCase where case_id=@case_id)
	Set @History_Id=(Select History_Id from tblCasedeskHistory where case_id=@case_id and bt_status=1)
	Update tblCaseDeskHistory
	set bt_status=0
	where history_id=@history_id

	insert into tblCaseDeskHistory
	(
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
		@CASE_ID,
		@Login_User_Id,
		@From_User_Id,
		@To_User_ID,
		getdate(),
		null,
		1
	)


update tblCase set UserId=@To_User_Id where case_id=@case_id
END

--select * from tblCase

