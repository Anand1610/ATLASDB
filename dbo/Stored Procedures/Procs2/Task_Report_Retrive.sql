-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Task_Report_Retrive]
	@s_a_DomainID varchar(50),
	@i_a_User_ID int,
	@dt_a_FromDate datetime = null,
	@dt_a_ToDate datetime = null,
	@b_a_TaskAll bit = 0, 
	@dt_a_DueDate datetime=null,
	@i_a_AssignToID int,
	@i_a_AssignedBy int,
	@i_a_Status int
AS
BEGIN
	Declare @RoleName varchar(100)=''
	Set @RoleName = (Select RoleName From IssueTracker_Roles R Left Join IssueTracker_Users U
	ON R.RoleId = U.RoleId Where UserId = @i_a_User_ID)
	--IF @RoleName is not null and lower(Ltrim(Rtrim(@RoleName)))='administrator' 
	
	  Select 
			[Task_ID]
			, [Case_ID]
			, T.Task_Type_ID
			, TT.Description as TaskType
			, T.Priority_ID
			, TP.Description as TaskPriority
			, T.Task_Status_ID
			, TS.Description as TaskStatus
			, [Assign_User_ID]
			, IU.UserName as Assign_User
			, UTABy.UserName as Assign_By_User
			, CONVERT(VARCHAR(10), [TaskDate], 101) as [TaskDate]
			, T.Comments
			, CONVERT(VARCHAR(10), DueDate, 101) as DueDate
			, UTC.UserName AS Completed_By_User
			, CONVERT(VARCHAR(10), T.Completed_Date, 101) as [Completed_Date]
		From Task T Left Join Task_Type TT on T.Task_Type_ID = TT.Task_Type_ID
		Left Join Task_Priority TP on T.Priority_ID = TP.Priority_ID 
		Left Join Task_Status TS on T.Task_Status_ID = TS.Task_Status_ID
		Left Join IssueTracker_Users IU on T.Assign_User_ID = IU.UserId
		Left Join IssueTracker_Users UTABy on T.Created_User_ID = UTABy.UserId
		Left Join IssueTracker_Users UTC on T.Completed_By_User = UTC.UserId
		 where T.DomainID = @s_a_DomainID 
		 and  (@b_a_TaskAll = 1  OR ISNULL(TS.Description,'') !='completed')
	     and  (@dt_a_FromDate is null OR TaskDate between @dt_a_FromDate and @dt_a_ToDate)
		 and  (@RoleName = 'administrator' or  [Assign_User_ID] = @i_a_User_ID)
		 and  (@dt_a_DueDate is null or DueDate <= @dt_a_DueDate)
		 --and  (@i_a_AssignToID = 0 or Assign_User_ID = @i_a_AssignToID OR Created_User_ID = @i_a_AssignToID or Completed_By_User = @i_a_AssignToID OR Revised_User_ID = @i_a_AssignToID)
		 and  (@i_a_AssignToID = 0 or Assign_User_ID = @i_a_AssignToID)
		 and  (@i_a_AssignedBy = 0 or Created_User_ID = @i_a_AssignedBy)
		 and  (@i_a_Status = 0 or TS.Task_Status_ID=@i_a_Status)
	ORDER BY TaskDate DESC
	
END