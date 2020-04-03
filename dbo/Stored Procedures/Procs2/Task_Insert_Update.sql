-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Task_Insert_Update] 
	@Task_ID int,
	@DomainID varchar(50),
	@Case_ID varchar(50),
	@Task_Type_ID int,
	@Priority_ID int,
	@Task_Status_ID int,
	@Assign_User_ID int,
	@TaskDate datetime,
	@Reminder bit,
	@ReminderDateTime datetime,
	@DueDate datetime,
	@Comments nvarchar(max),
	@Created_User_ID int
AS
BEGIN
	Declare @Completed_Date datetime =null;
	Declare @Completed_By_User int =null;
	Declare @TaskStatus varchar(100);

    Set @TaskStatus =(Select Description from Task_Status where Task_Status_ID=@Task_Status_ID)
	
	IF LTRIM(RTRIM(@TaskStatus)) = 'Completed'
	BEGIN
	 Set @Completed_Date = GetDate();
	 Set @Completed_By_User = @Created_User_ID;
	END

	If @Task_ID = 0
	BEGIN
		Insert into Task(DomainID, Case_ID, Task_Type_ID, Priority_ID, Task_Status_ID, Assign_User_ID, TaskDate, Reminder,
			ReminderDateTime, DueDate, Comments, CreatedDate, Created_User_ID, Completed_Date, Completed_By_User)
			Values(@DomainID, @Case_ID, @Task_Type_ID, @Priority_ID, @Task_Status_ID, @Assign_User_ID, @TaskDate, @Reminder,
			@ReminderDateTime, @DueDate, @Comments,GetDate(), @Created_User_ID, @Completed_Date, @Completed_By_User)
	END
	ELSE
	BEGIN
		Update Task set
		Task_Type_ID = @Task_Type_ID, Priority_ID = @Priority_ID, Task_Status_ID = @Task_Status_ID, Assign_User_ID = @Assign_User_ID,
		TaskDate = @TaskDate, Reminder=@Reminder, ReminderDateTime = @ReminderDateTime, DueDate = @DueDate, Comments = @Comments,
		RevisedDate = GetDate(), Revised_User_ID = @Created_User_ID, Completed_Date = @Completed_Date, Completed_By_User = @Completed_By_User
		Where Task_ID = @Task_ID and DomainID = @DomainID and Case_ID = @Case_ID
	END
END
