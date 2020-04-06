--STP_DSP_GET_CASEDOCUMENTNODELIST_NEW '1908','1'    
CREATE PROCEDURE [dbo].[STP_DSP_GET_CASEDOCUMENTNODELIST_NEW1]  
(  
 @CASEID   NVARCHAR(1908)='',    
 @ISARCHIVED  NCHAR='0',
 @UserId NVARCHAR(50)
)  
AS 
BEGIN  

CREATE TABLE #TEMP(NodeID NVARCHAR(100),ParentID INT,Nodename_code NVARCHAR(MAX),NodeIcon NVARCHAR(200),NodeLevel INT,Expanded INT,orderby NVARCHAR(MAX))

IF @ISARCHIVED='0' 
INSERT INTO #TEMP   
  SELECT   
   cast(T.NodeID AS NVARCHAR) NodeID,  
   T.ParentID,     
   '<input class=''c'' type=''checkbox'' id=''' + convert(NVARCHAR(50),T.NodeID) + ''' onclick=''ob_t2c(this)''>' + T.NodeName,   
   T.NodeIcon,   
   T.NodeLevel,   
   T.Expanded,  
   T.NodeName  
  FROM   
   tblTags T WHERE CaseID=@CASEID 
  UNION    
  SELECT   
   'IMG-' + CAST(I.ImageID AS NVARCHAR),   
   T.NodeID,     
   '<input class=''c'' type=''checkbox'' id=''IMG-' + convert(nvarchar(50),I.ImageID) + ''' onclick=''ob_t2c(this)''> <a href='''+  
   --s.ParameterValue+I.FilePath+I.FileName +''' target=''imageframe'' onclick=''VisibleFrame();''>'+I.FileName+'</a>',  'page.gif',   
   case when isnull( is_saga_doc,0) =0 then  
  REPLACE( s.ParameterValue+I.FilePath+I.FileName ,char(39),'&#39;')+''' target=''imageframe'' onclick=''VisibleFrame();'' >'  
   else '/SagaDocument/' +I.FilePath+I.FileName +''' target=''imageframe'' onclick=''VisibleFrame();'' >' end  +I.FileName+'</a>', 'page.gif',   
   T.NodeLevel+1,   
   1,  
   T.NodeName AS orderby  
  FROM   
   TBLDOCIMAGES I INNER JOIN   
   tblImageTag IT ON IT.ImageID=i.ImageID INNER JOIN   
   tblTags T ON T.NodeID=IT.TagID AND T.CaseID=@CASEID LEFT JOIN   
   tblApplicationSettings s ON s.parametername='DocumentUploadLocation'  
    ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		 AND IT.isdeleted=0  and I.Isdeleted  =0 
  ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
ELSE  
INSERT INTO #TEMP    
 SELECT   
  CAST(T.NodeID AS NVARCHAR) NodeID,   
  T.ParentID,     
  '<input class=''c'' type=''checkbox'' id=''' + CONVERT(NVARCHAR(50),T.NodeID) + ''' onclick=''ob_t2c(this)''>' + T.NodeName,   
  T.NodeIcon,   
  T.NodeLevel,   
  T.Expanded,  
  T.NodeName AS orderby  
 FROM   
  tblTags T   
 WHERE   
  CaseID=@CASEID
 
 UNION    
 SELECT   
  'IMG-' + CAST(I.ImageID AS NVARCHAR),   
  T.NodeID,     
  '<input class=''c'' type=''checkbox'' id=''IMG-' + CONVERT(NVARCHAR(50),I.ImageID) + ''' onclick=''ob_t2c(this)''> <a href='''+  
  --s.ParameterValue+I.FilePath+I.FileName +''' target=''imageframe'' onclick=''VisibleFrame();''>'+I.FileName+'</a>',   'page.gif',   
  case when isnull( is_saga_doc,0) =0 then  
  REPLACE( s.ParameterValue+I.FilePath+I.FileName ,char(39),'&#39;') +''' target=''imageframe'' onclick=''VisibleFrame();'' >'  
  else '/SagaDocument/' +I.FilePath+I.FileName +''' target=''imageframe'' onclick=''VisibleFrame();'' >' end  +I.FileName+'</a>', 'page.gif',   
  T.NodeLevel+1,   
  1,  
  T.NodeName AS orderby  
 FROM   
  TBLDOCIMAGES I  INNER JOIN   
  tblImageTag IT ON IT.ImageID=i.ImageID INNER JOIN   
  tblTags T ON T.NodeID=IT.TagID and T.CaseID=@CASEID LEFT JOIN   
  tblApplicationSettings s ON s.parametername='ArchivedDocumentUploadLocation'
   ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		 AND IT.isdeleted=0  and I.Isdeleted  =0 
  ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
if @UserId=0   
SELECT * FROM #TEMP   ORDER BY   nodelevel,orderby 
else
SELECT * FROM #TEMP WHERE NodeName in(select nodename from MST_DOCUMENT_NODES where NodeID in(select nodeid from tbl_node_role where roleid in(select Roleid from IssueTracker_Users where UserId =@UserID)))  
ORDER BY   nodelevel,orderby 
END

