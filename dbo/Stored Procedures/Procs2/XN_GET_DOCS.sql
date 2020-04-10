-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[XN_GET_DOCS]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
		Select  I.ImageId, 
		RTRIM(LTRIM(Filename)) as Filename, 
		--CaseID,
		FilePath, 
		'E:\LawSpades\Application\Atlas\'+ FilePath + RTRIM(LTRIM(Filename)) As FilePathOld,
		--'E:\LawSpades\Application\AtlasDocuments\'+ I.DomainID + '\' +CaseID +'\'+ Nodename+'\'+Replace(Replace(FilePath,'%',''),'(','') AS FilePathNew,
		--I.DomainID + '\' +CaseID +'\'+ Nodename+'\' AS FilePathN,
		Replace(Replace(FileName,'%',''),'(','') AS FilenameN,
		'3' AS BasePathID,
		--BasePathType,
		StatusDone
	from tblDocImages(NOLOCK) I 
	  --LEFT JOIN tblBasePath(NOLOCK) b on b.BasePathId=I.BasePathId --and b.DomainID = I.DomainID 
	  --inner Join dbo.tblImageTag IT on IT.ImageID=I.ImageID and IT.Domainid = I.Domainid
	  --INNER JOIN dbo.tblTags T on T.NodeID = IT.TagID and T.Domainid = IT.Domainid
	 where 
	 replace(filepath,'/','\') like '%\2019\%' and domainid = 'glf'
	 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
     AND I.IsDeleted=0  
     ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
		--and I.domainid = 'glf'
 --   delete from tblImageTag where imageid in (
	--select imageid delete from tbldocimages where statusdone in ('CaseIDnotExists')
	--)
		--and d.ImageId = 63942
END