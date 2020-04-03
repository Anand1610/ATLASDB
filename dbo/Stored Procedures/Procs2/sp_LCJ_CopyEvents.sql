CREATE PROCEDURE [dbo].[sp_LCJ_CopyEvents](
	@szEventID varchar(50)
)
AS
BEGIN
	INSERT INTO tblEvent(
		Case_Id,
		Event_Date,
		EventTypeId ,
		EventStatusId,
		Event_Time,
		Event_Notes,
		Assigned_To,
		User_Id
	)
	select Case_Id,Event_Date,EventTypeId,EventStatusId,Event_Time,Event_Notes,Assigned_To,User_Id
		from tblEvent where event_id = @szEventID
END

