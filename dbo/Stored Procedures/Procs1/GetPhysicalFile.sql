create procedure [dbo].[GetPhysicalFile]
@imageid int,
@DomainId varchar(10)
as
begin
select D.FilePath,D.filename,D.BasePathId 
from tblDocImages D (nolock) 
Left Join tblBasePath B ON B.BasePathId=D.BasePathId 
where D.imageid =  @imageid and D.DomainId= @DomainId
end