  
CREATE PROCEDURE [dbo].[get_docs_for_azure_delete]  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
   
  Select  Top 1000000
	  I.ImageID, 
	  Filename, 
	  FilePath, 
	  ISNULL(FilePathOld,FilePath)+Filename As PhysicalFilePath,
	  I.BasePathId, BasePathType ,
	  --CaseID +'/'+Nodename+'/' AS FilePathNew,
	  '\'+ FilePath AS FilePathNew,
	  statusdone,
	  azure_statusdone
  from tblDocImages(NOLOCK) I 
	  LEFT JOIN tblBasePath(NOLOCK) b on b.BasePathId=I.BasePathId --and b.DomainID = I.DomainID 
	  inner Join dbo.tblImageTag IT on IT.ImageID=I.ImageID and IT.Domainid = I.Domainid
	  INNER JOIN dbo.tblTags T on T.NodeID = IT.TagID and T.Domainid = IT.Domainid
	   ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
      AND I.IsDeleted=0 AND IT.IsDeleted=0  
   ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
  where b.BasePathType=2 
  and I.statusdone ='Done'
   and T.DomainID = 'DK'
   and Filename <>''
  and I.azure_statusdone IS null  
  --and statusdone is not null
  --and I.azure_statusdone like  'Done'
  --and FilePathOld is null
 
  --and T.DomainId NOT in ('GLF')
  --and caseid ='ACT-AF-100001'
  
END  