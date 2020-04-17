
CREATE procedure [dbo].[GetMedicalReports]
@InsuranceCompany_Id varchar(max),
@Provider_Id varchar(max),
@nodename varchar(128)
as
begin

declare @basepath varchar(2000)=(select ParameterValue from tblApplicationSettings where ParameterName='DocumentUploadLocationPhysical')
select t1.case_id,
docimg.Filename,
docimg.FilePath,
@basepath+docimg.FilePath+docimg.Filename [FullPath]
from tblcase t1
right join tblTags tgs  with(nolock)    on tgs.CASEID=t1.Case_Id
left JOIN tblImageTag tblImg with(nolock)  ON tgs.Nodeid = tblImg.tagid
---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		AND tblImg.IsDeleted =0  
---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
left JOIN tblDocImages docimg with(nolock)  on tblImg.ImageID = docimg.ImageID
---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		  AND docimg.IsDeleted=0
---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
where Provider_Id IN (SELECT  cast(items as INT )  FROM dbo.STRING_SPLIT(@Provider_Id,',')) and  
InsuranceCompany_Id IN (SELECT  cast(items as INT )  FROM dbo.STRING_SPLIT(@InsuranceCompany_Id,','))
and tgs.nodename=@nodename and  Filename not like'%mr.pdf%'

order by t1.Case_Id

end 




