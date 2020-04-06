

create Procedure [dbo].[GetNodeDocuments]
@DOMAINID varchar(20),
@CASEID varchar(50),
@NODENAME varchar(50)
as
begin
if(@NODENAME='ALL')
begin
SELECT docimg.FilePath,docimg.[Filename]

from tblTags tgs with(nolock) 
 JOIN tblImageTag tblImg ON tgs.Nodeid = tblImg.tagid
 JOIN tblDocImages docimg on tblImg.ImageID = docimg.ImageID
 join tblBasePath on tblBasePath.BasePathId=docimg.BasePathId

where tgs.nodename in ('Correspondence' ,'Defense pleadings','DISCOVERY','MOTIONS/RESPONSES','Plaintiff pleadings','Proof of Notice','Checks and Releases','Settlement Letter')
and tgs.caseid=@CASEID and tgs.DomainId=@DOMAINID 


---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
	AND tblImg.IsDeleted=0 AND docimg.IsDeleted=0 	
---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude

end
else
begin
SELECT docimg.FilePath,docimg.[Filename]

from tblTags tgs with(nolock) 
 JOIN tblImageTag tblImg ON tgs.Nodeid = tblImg.tagid
 JOIN tblDocImages docimg on tblImg.ImageID = docimg.ImageID
 join tblBasePath on tblBasePath.BasePathId=docimg.BasePathId

where tgs.nodename =@NODENAME
and tgs.caseid=@CASEID and tgs.DomainId=@DOMAINID and tblImg.DomainId=@DOMAINID and docimg.DomainId=@DOMAINID
---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
AND tblImg.IsDeleted=0 AND docimg.IsDeleted=0 	
---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
end
end





