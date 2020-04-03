CREATE PROCEDURE [dbo].[LCJ_DDL_LocationAdd]
@DomainId NVARCHAR(50)
as
begin
select distinct a.Location_Id,a.location_address from mst_service_rendered_location a inner join tblcase b on b.location_id=a.Location_Id where 1=1 and b.DomainId=@DomainId order by a.Location_Id 
end
