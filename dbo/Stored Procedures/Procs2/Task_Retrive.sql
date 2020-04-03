-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Task_Retrive]
(
	@Case_ID varchar(50),
	@DomainID varchar(50)
)
AS
BEGIN
	Select [Task_ID], [Case_ID], T.Task_Type_ID, TT.Description as TaskType, T.Priority_ID,TP.Description as TaskPriority,
	T.Task_Status_ID,TS.Description as TaskStatus, [Assign_User_ID],IU.DisplayName as Assign_User,
	CONVERT(VARCHAR(10), [TaskDate], 101) as [TaskDate], [Reminder], [ReminderDateTime],CONVERT(VARCHAR(10), [DueDate], 101) as [DueDate], T.Comments
	From Task T Left Join Task_Type TT on T.Task_Type_ID = TT.Task_Type_ID
	Left Join Task_Priority TP on T.Priority_ID = TP.Priority_ID 
	Left Join Task_Status TS on T.Task_Status_ID = TS.Task_Status_ID
	Left Join IssueTracker_Users IU on T.Assign_User_ID = IU.UserId
	 where Case_ID = @Case_ID and T.DomainID = @DomainID
END
