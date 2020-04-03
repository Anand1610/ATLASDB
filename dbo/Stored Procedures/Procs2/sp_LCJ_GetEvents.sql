CREATE PROCEDURE [dbo].[sp_LCJ_GetEvents] 
(
@User_id varchar(50),
@Event_Date datetime
)
as
begin
select evt.event_id [Event],evt.case_id [Case],evtType.EventTypeName,evtStatus.EventStatusName [Status], isnull(convert(nvarchar(5),evt.Event_Time,114),'')
[Event &_Time],isnull(evt.Event_Notes,'') [Notes],evt.assigned_to from tblevent evt join tbleventtype evtType on evtType.eventtypeid = evt.eventtypeid 
join tbleventstatus evtStatus on evtStatus.eventstatusid = evt.eventstatusid where evt.event_date = @Event_date  and User_id=@User_id order by  evt.Event_Time asc
end

