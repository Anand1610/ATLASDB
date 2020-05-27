-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[Downlaod_Documents]-- [Downlaod_Documents] 'DK20-91831','DK'  
 (  
  @s_a_case_id varchar(max)= CaseID,--'RFA14-166802'  
  @s_a_DomainID VARCHAR(50)='DK'  
 )-- Add the parameters for the stored procedure here  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
     
 SELECT REPLACE(FilePath + Filename,'/','\')  AS ImagePath,  
  CaseID+'\' + Filename AS ImagePathNew,  
  I.BasePathId,  
  BasePathType ,
  CaseID 
 from dbo.TBLDOCIMAGES I  (nolock) 
 inner Join dbo.tblImageTag IT (nolock)  on IT.ImageID=i.ImageID   
 inner Join dbo.tblTags T (nolock)  on T.NodeID = IT.TagID   
 LEFT OUTER JOIN dbo.tblBasePath b (nolock)  ON I.BasePathID = b.BasePathID  
 WHERE -- T.CaseID IN (SELECT LTRIM(RTRIM(items)) FROM dbo.STRING_SPLIT(@s_a_case_id,','))  
  
 --AND
  T.DomainId  = @s_a_DomainID
  --and  NodeName like '%VERIFICATION RESPONSE%' 
 and   CaseID in (select value from string_split(@s_a_case_id ,','))
--  and filepath like '%LGM%'
--and filepath not like 'glf\glf%'
--and filepath not like 'glf/glf%'
--and filepath not like 'glf\act%'
--and filepath not like 'glf/act%'
--and filepath not like 'glf/POM%'
--and filepath not like 'glf\POM%'  
  
END  