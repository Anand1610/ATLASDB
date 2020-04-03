CREATE PROCEDURE [dbo].[LCJ_AddServiceType]
(
@DomainId nvarchar(50),
@ServiceType varchar(100),
@ServiceDesc varchar(100)
)
as
begin
insert into tblservicetype(ServiceType, ServiceDesc, DomainID)  values (@ServiceType,@ServiceDesc,@DomainId)
end

