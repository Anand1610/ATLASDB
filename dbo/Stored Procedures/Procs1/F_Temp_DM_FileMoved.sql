-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[F_Temp_DM_FileMoved]  
   
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
  
 SELECT 
		  I.ImageID
		  , Filename  
		  , I.FilePath AS FilePath  
		  , T.DomainID + '\' +CaseID+'\' + NodeName +'\' AS NewFilePath  
		  --, Replace(Filename,'''','') AS NewFileName  
		  , Replace(Filename,'''','') AS NewFileName 
		  , statusdone
	from dbo.TBLDOCIMAGES I (NOLOCK)
	inner Join dbo.tblImageTag IT (NOLOCK) on IT.ImageID=i.ImageID 
	inner Join dbo.tblTags T (NOLOCK) on T.NodeID = IT.TagID 
	LEFT OUTER JOIN dbo.tblBasePath (NOLOCK) b ON I.BasePathID = b.BasePathID
	WHERE -- T.CaseID IN (SELECT LTRIM(RTRIM(items)) FROM dbo.STRING_SPLIT(@s_a_case_id,','))
	-- and 
	T.DomainId  ='GLF'
	--and nodename in ('DENIALS')
	AND replace(FilePath,'\','/') NOT like 'glf/G%'
	AND replace(FilePath,'\','/')  NOT like 'glf/ACT%'
	AND I.BasePathId = 2
	-- AND statusdone ='File Not Found'
	AND statusdone IS NULL
	---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
	AND I.IsDeleted=0 AND  IT.IsDeleted=0 
    ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
 order by I.ImageID  
      
END  
