
--STP_DSP_GET_CASEDOCUMENTNODELIST_EX1_NEW1 'AF','AF19-204245',0,0        
create PROCEDURE [dbo].[STP_DSP_GET_CASEDOCUMENTNODELIST_EX1_NEW1]  -- [STP_DSP_GET_CASEDOCUMENTNODELIST_NEW] 'GLF','GLF18-10001',0,1111    
(      
 @DomainId NVARCHAR(50),    
 @CASEID   NVARCHAR(256)='',        
 @ISARCHIVED  NCHAR='0',    
 @UserId NVARCHAR(50)    
)      
AS     
BEGIN      
    
DECLARE @tblCaseNodeList AS TABLE   
 (NodeID NVARCHAR(100),  
 ParentID NVARCHAR(100),  
 NodeName NVARCHAR(MAX),  
 NodeIcon NVARCHAR(200),  
 NodeLevel INT,  
 Expanded INT,  
 BT_UPDATE int,
 NodeType varchar(12))    
    
IF @ISARCHIVED='0'     
INSERT INTO @tblCaseNodeList       
  SELECT       
cast(T.NodeID AS NVARCHAR) NodeID,      
cast(T.ParentID AS NVARCHAR) ParentID,         
T.NodeName  [NodeName],      
T.NodeIcon,       
T.NodeLevel,       
T.Expanded,
'0' as BT_UPDATE,   
t.NodeType    
  FROM       
   tblTags T WITH(NOLOCK) WHERE CaseID=@CASEID and DomainId=@DomainId    
  UNION        
  SELECT       
	'IMG-' + CAST(I.ImageID AS NVARCHAR) [NodeID],       
	cast(T.NodeID AS NVARCHAR) [ParentID],         
	'<a href='''+b.VirtualBasePath+'/'+I.FilePath+replace(I.FileName,',','%2C') +''' target=''imageframe'' onclick=''VisibleFrame();''>'+replace(I.FileName,',','%2C')+'</a>'[NodeName],
	'page.gif' [NodeIcon],       
	T.NodeLevel+1 [NodeLevel],       
	1 [Expanded],      
	'0' as BT_UPDATE,   
	t.NodeType  
	FROM       
   TBLDOCIMAGES I WITH(NOLOCK) INNER JOIN       
   tblImageTag IT WITH(NOLOCK) ON IT.ImageID=i.ImageID INNER JOIN       
   tblTags T WITH(NOLOCK) ON T.NodeID=IT.TagID AND T.CaseID=@CASEID LEFT JOIN      
   tblBasePath B WITH(NOLOCK) ON B.BasePathId = I.BasePathId     
   --tblApplicationSettings s ON s.parametername='DocumentUploadLocation'      
    WHERE I.DomainId = @DomainId  
	  ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		
     AND I.IsDeleted=0 AND IT.IsDeleted=0
  ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
ELSE      
INSERT INTO @tblCaseNodeList        
 SELECT       
cast(T.NodeID AS NVARCHAR) NodeID,      
cast(T.ParentID AS NVARCHAR) ParentID,        
T.NodeName  [NodeName],      
T.NodeIcon,       
T.NodeLevel,       
T.Expanded,
'0' as BT_UPDATE,   
t.NodeType      
 FROM       
  tblTags T WITH(NOLOCK)      
 WHERE       
  CaseID=@CASEID    
  AND DomainId=@DomainId    
     
 UNION        
        
  SELECT       
	'IMG-' + CAST(I.ImageID AS NVARCHAR) [NodeID],       
	cast(T.NodeID AS NVARCHAR)[ParentID],         
	'<a href='''+b.VirtualBasePath+'/'+I.FilePath+replace(I.FileName,',','%2C') +''' target=''imageframe'' onclick=''VisibleFrame();''>'+replace(I.FileName,',','%2C')+'</a>'[NodeName],
	'page.gif' [NodeIcon],       
	T.NodeLevel+1 [NodeLevel],       
	1 [Expanded],      
	'0' as BT_UPDATE,   
	t.NodeType           
 FROM       
  TBLDOCIMAGES I WITH(NOLOCK) INNER JOIN       
  tblImageTag IT WITH(NOLOCK) ON IT.ImageID=i.ImageID INNER JOIN       
  tblTags T WITH(NOLOCK) ON T.NodeID=IT.TagID and T.CaseID=@CASEID LEFT JOIN     
   tblBasePath B WITH(NOLOCK) ON B.BasePathId = I.BasePathId       
  --tblApplicationSettings s ON s.parametername='ArchivedDocumentUploadLocation'    
   WHERE I.DomainId=@DomainId   
     ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		   AND I.IsDeleted=0 AND IT.IsDeleted=0
   ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude 
    
if @UserId=0       
SELECT * FROM @tblCaseNodeList   ORDER BY   nodelevel,[NodeName]     
else    
SELECT * FROM @tblCaseNodeList   ORDER BY   nodelevel,NodeName     
 --SELECT * FROM @tblCaseNodeList WHERE orderby in(select nodename from MST_DOCUMENT_NODES where DomainId=@DomainId and NodeID in     
 --(select nodeid from tbl_node_role where DomainId=@DomainId and roleid in (select Roleid from IssueTracker_Users where UserId =@UserID and DomainId=@DomainId)))      
 --ORDER BY   nodelevel,orderby     
END    