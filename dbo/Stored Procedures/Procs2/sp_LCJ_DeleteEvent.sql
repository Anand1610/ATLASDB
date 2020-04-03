CREATE PROCEDURE [dbo].[sp_LCJ_DeleteEvent]
(
@DomainId nvarchar(50),
@szEventID varchar(50)
)
as
Declare @id as nvarchar(50)
begin
set @id=(select case_id from tblevent  where event_id = @szEventID and DomainId=@DomainId)
	delete from tblevent  where event_id = @szEventID and DomainId=@DomainId

update tblevent
set status =1
where event_id in (select event_id from tblevent  where event_id in(select a.event_id from (select * from tblevent  where event_date=(select max(event_date) from tblevent  where case_id=@id)and case_id=@id)a where a.DomainId=@DomainId and a.event_time=(select max(a.event_time) from (select * from tblevent  where event_date=(select max(event_date) from tblevent  where case_id=@id and DomainId=@DomainId)and case_id=@id and DomainId=@DomainId)a)))
end

