CREATE PROCEDURE [dbo].[LCJ_AddEventType]
(
@DomainId varchar(50),
@EventTypeName varchar(100)
)
as
begin
insert into tblEventType(DomainID,EventTypeName)  values (@EventTypeName,@DomainId)
end

