CREATE PROCEDURE [dbo].[LCJ_DDL_EventType]
@DomainId NVARCHAR(50)
as
begin
	select  '' [EventTypeId], ' ---Select Event Type--- ' [EventTypeName]
	union
Select EventTypeId,EventTypeName from tblEventType WHERE DomainId=@DomainId
order by EventTypeName
end

