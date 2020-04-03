CREATE PROCEDURE [dbo].[LCJ_AddEvent]  
(  
 @Case_Id nvarchar(50),  
 @Event_Date datetime,  
 @EventTypeId nvarchar(100),  
 @EventStatusId nvarchar(200),  
 @Event_Time datetime,  
 @Event_Notes varchar(500),  
 @Assigned_To varchar(500),  
 @User_Id varchar(500),  
 @I_EVENT_ID INT,
 @arbitrator_id INT = null
)  
AS
BEGIN  
	DECLARE @EVENTTYPENAME AS NVARCHAR(100)
	DECLARE @desc AS NVARCHAR(100)
	
	-- serge has added (2) as a ---select arbitrator field --- in the DB
	if(@arbitrator_id = 2 OR @arbitrator_id = 0)
	begin
		set @arbitrator_id = null
	end
 IF EXISTS (SELECT EVENT_ID FROM tblEvent WHERE EVENT_ID =@I_EVENT_ID)  
 BEGIN  
  UPDATE tblEvent  
  SET Event_Date = @Event_Date,  
   EventTypeId = @EventTypeId,  
   EventStatusId = @EventStatusId,  
   Event_Notes = @Event_Notes,  
   Assigned_To = @Assigned_To,  
   User_Id = @User_Id,  
   Event_Time = @Event_Time , arbitrator_id = @arbitrator_id 
  WHERE EVENT_ID = @I_EVENT_ID 
	
	SET @EVENTTYPENAME = (SELECT EVENTTYPENAME FROM TBLEVENTTYPE WHERE EVENTTYPEID = @EventTypeId)
	set @desc = @EVENTTYPENAME + ' for ' + convert(nvarchar(12),@Event_Date,101) + ' assigned to ' + @Assigned_To
	EXEC LCJ_AddNotes @Case_Id,'Activity', @desc,@User_Id,0
 END 
  ELSE  
  BEGIN  
 INSERT INTO tblEvent  
    (  
     Case_Id,  
     Event_Date,  
     EventTypeId ,  
     EventStatusId,  
     Event_Time,  
     Event_Notes,  
     Assigned_To,  
     User_Id,
	arbitrator_id
    )  
  
    VALUES(   
     @Case_Id,  
     @Event_Date,  
     @EventTypeId,  
     @EventStatusId,  
     @Event_Time ,  
     @Event_Notes ,  
     @Assigned_To,  
     @User_Id  , @arbitrator_id
    )
    SET @EVENTTYPENAME = (SELECT EVENTTYPENAME FROM TBLEVENTTYPE WHERE EVENTTYPEID = @EventTypeId)
	set @desc = @EVENTTYPENAME + ' for ' + convert(nvarchar(12),@Event_Date,101) + ' assigned to ' + @Assigned_To
	EXEC LCJ_AddNotes @Case_Id,'Activity', @desc,@User_Id,0 
END 
update tblevent
set status =0 where case_id=@case_id
update tblevent
set status =1
where event_id in (select event_id from tblevent where event_id in(select a.event_id from (select * from tblevent where event_date=(select max(event_date) from tblevent where case_id=@Case_Id)and case_id=@Case_Id)a where a.event_time=(select max(a.event_time) from (select * from tblevent where event_date=(select max(event_date) from tblevent where case_id=@Case_Id)and case_id=@Case_Id)a)))
  
END

--
--select * from tblevent
--select distinct event_id from tblevent

