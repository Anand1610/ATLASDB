--STP_DSP_GET_CASEDOCUMENTNODELIST_NEW '1908','1'      
CREATE PROCEDURE [dbo].[STP_DSP_GET_CASEDOCUMENTNODELIST_NEW]  -- [STP_DSP_GET_CASEDOCUMENTNODELIST_NEW] 'GLF','GLF18-10001',0,1111  
(    
@DomainId NVARCHAR(50),  
 @CASEID   NVARCHAR(256)='',      
 @ISARCHIVED  NCHAR='0',  
 @UserId NVARCHAR(50)  
)    
AS   
BEGIN    
SET NOCOUNT ON
DECLARE @tblCaseNodeList AS TABLE 
	(NodeID NVARCHAR(100),
	ParentID INT,
	Nodename_code NVARCHAR(MAX),
	NodeIcon NVARCHAR(200),
	NodeLevel INT,
	Expanded INT,
	orderby NVARCHAR(MAX))  
  
IF @ISARCHIVED='0'   
INSERT INTO @tblCaseNodeList     
  SELECT     
   cast(T.NodeID AS NVARCHAR) NodeID,    
   T.ParentID,       
   '<input class=''c'' type=''checkbox'' id=''' + convert(NVARCHAR(50),T.NodeID) + ''' onclick=''ob_t2c(this)''>' + T.NodeName,     
   T.NodeIcon,     
   T.NodeLevel,     
   T.Expanded,    
   T.NodeName    
  FROM     
   tblTags T WITH(NOLOCK) WHERE CaseID=@CASEID and DomainId=@DomainId  
  UNION      
  SELECT     
   'IMG-' + CAST(I.ImageID AS NVARCHAR),     
   T.NodeID,       
   '<input class=''c'' type=''checkbox'' id=''IMG-' + convert(nvarchar(50),I.ImageID) + ''' onclick=''ob_t2c(this)''> <a href='''+    
   --s.ParameterValue+I.FilePath+I.FileName +''' target=''imageframe'' onclick=''VisibleFrame();''>'+I.FileName+'</a>',  'page.gif',     
   case when isnull( is_saga_doc,0) =0 then    
 REPLACE( B.VirtualBasePath +'/'+I.FilePath+I.FileName ,char(39),'&#39;')+''' target=''imageframe'' onclick=''VisibleFrame();'' >'    
   else '/SagaDocument/' +'/'+I.FilePath+I.FileName +''' target=''imageframe'' onclick=''VisibleFrame();'' >' end  +I.FileName+'</a>', 'page.gif',     
   T.NodeLevel+1,     
   1,    
   T.NodeName AS orderby    
  FROM     
   
  tblTags T  WITH(NOLOCK) 
    INNER JOIN  tblImageTag IT WITH(NOLOCK) ON T.NodeID=IT.TagID 
  INNER JOIN  TBLDOCIMAGES I WITH(NOLOCK)  ON IT.ImageID=i.ImageID
	LEFT JOIN  tblBasePath B WITH(NOLOCK) ON B.BasePathId = I.BasePathId     
  WHERE T.DomainId=@DomainId  and T.CaseID=@CASEID    
   
ELSE    
INSERT INTO @tblCaseNodeList      
 SELECT     
  CAST(T.NodeID AS NVARCHAR) NodeID,     
  T.ParentID,       
  '<input class=''c'' type=''checkbox'' id=''' + CONVERT(NVARCHAR(50),T.NodeID) + ''' onclick=''ob_t2c(this)''>' + T.NodeName,     
  T.NodeIcon,     
  T.NodeLevel,     
  T.Expanded,    
  T.NodeName AS orderby    
 FROM     
  tblTags T WITH(NOLOCK)    
 WHERE     
  CaseID=@CASEID  
  AND DomainId=@DomainId  
   
 UNION      
 SELECT     
  'IMG-' + CAST(I.ImageID AS NVARCHAR),     
  T.NodeID,       
  '<input class=''c'' type=''checkbox'' id=''IMG-' + CONVERT(NVARCHAR(50),I.ImageID) + ''' onclick=''ob_t2c(this)''> <a href='''+    
  --s.ParameterValue+I.FilePath+I.FileName +''' target=''imageframe'' onclick=''VisibleFrame();''>'+I.FileName+'</a>',   'page.gif',     
  case when isnull( is_saga_doc,0) =0 then    
  REPLACE( B.VirtualBasePath+I.FilePath+I.FileName ,char(39),'&#39;') +''' target=''imageframe'' onclick=''VisibleFrame();'' >'    
  else '/SagaDocument/' +I.FilePath+I.FileName +''' target=''imageframe'' onclick=''VisibleFrame();'' >' end  +I.FileName+'</a>', 'page.gif',     
  T.NodeLevel+1,     
  1,    
  T.NodeName AS orderby    
 FROM   
  tblTags T  WITH(NOLOCK) 
    INNER JOIN  tblImageTag IT WITH(NOLOCK) ON T.NodeID=IT.TagID 
  INNER JOIN  TBLDOCIMAGES I WITH(NOLOCK)  ON IT.ImageID=i.ImageID
	LEFT JOIN  tblBasePath B WITH(NOLOCK) ON B.BasePathId = I.BasePathId     
  WHERE T.DomainId=@DomainId  and T.CaseID=@CASEID    
  
if @UserId=0     
SELECT * FROM @tblCaseNodeList   ORDER BY   nodelevel,orderby   
else  
SELECT * FROM @tblCaseNodeList   ORDER BY   nodelevel,orderby   
 --SELECT * FROM @tblCaseNodeList WHERE orderby in(select nodename from MST_DOCUMENT_NODES where DomainId=@DomainId and NodeID in   
 --(select nodeid from tbl_node_role where DomainId=@DomainId and roleid in (select Roleid from IssueTracker_Users where UserId =@UserID and DomainId=@DomainId)))    
 --ORDER BY   nodelevel,orderby   
 SET NOCOUNT OFF
END  
  