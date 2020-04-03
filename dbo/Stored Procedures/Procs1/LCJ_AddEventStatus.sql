CREATE PROCEDURE [dbo].[LCJ_AddEventStatus]
(
@DomainId varchar(50),
@EventStatusName varchar(500)
)
as
begin
insert into tblEventStatus(DomainID,EventStatusName)  values (@DomainId, @EventStatusName)
end

