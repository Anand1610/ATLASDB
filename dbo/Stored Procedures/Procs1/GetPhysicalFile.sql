create procedure [dbo].[GetPhysicalFile]
@imageid int,
@DomainId varchar(10)
as
begin
select D.FilePath,D.filename,D.BasePathId 
from tblDocImages D (nolock) 
Left Join tblBasePath B ON B.BasePathId=D.BasePathId 
where D.imageid =  @imageid and D.DomainId= @DomainId
---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
	AND D.IsDeleted=0	
---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
end