--STP_DSP_GET_CASEDOCUMENTNODELIST_LEAFED_NODES_EX1_NEW 'AF','AF19-204245',0,'LEAFED-NODES',0 
create PROCEDURE [dbo].[STP_DSP_GET_CASEDOCUMENTNODELIST_LEAFED_NODES_EX1_NEW]  
 @DomainId NVARCHAR(50),  
 @CASEID NVARCHAR(255)='',  
 @ISARCHIVED NCHAR='0',  
 @OPERATION NVARCHAR(20)='LEAFED-NODES',  
 @UserId NVARCHAR(50)  
AS  
BEGIN  
  
CREATE TABLE #TEMP(NodeID NVARCHAR(100),ParentID NVARCHAR(100),NodeName NVARCHAR(MAX),NodeIcon NVARCHAR(200),NodeLevel INT,Expanded INT, BT_UPDATE int,NodeType varchar(12))  
  
 IF @OPERATION = 'LEAFED-NODES'  
 BEGIN  
 INSERT INTO #TEMP  
  SELECT   
    cast(T.NodeID AS NVARCHAR) NodeID,      
	 cast(T.ParentID  AS NVARCHAR) [ParentID],         
	T.NodeName  [NodeName],      
	T.NodeIcon,       
	T.NodeLevel,       
	 1 [Expanded],
	'0' as BT_UPDATE,   
	t.NodeType  
   FROM   
    tblTags T   
   WHERE   
    CaseID= @CASEID AND   
    parentid IS NULL   
    and DomainId=@DomainId  

  UNION  
  SELECT   
   cast(TTAGS.NodeID AS NVARCHAR) NodeID,      
	cast(TTAGS.ParentID AS NVARCHAR) [ParentID],          
	TTAGS.NodeName  [NodeName],      
	TTAGS.NodeIcon,       
	TTAGS.NodeLevel,       
	 1 [Expanded],
	'0' as BT_UPDATE,   
	TTAGS.NodeType  
   FROM   
    TBLTAGS TTAGS   
   WHERE   
    NODEID IN (SELECT DISTINCT T.parentid  FROM tblTags T JOIN tblimagetag tit ON t.nodeid = tit.tagid WHERE CaseID = @CASEID AND parentid IS NOT NULL and T.DomainId=@DomainId) AND TTAGS.PARENTID IS NOT NULL  
    and DomainId=@DomainId  
     
  UNION   
  SELECT DISTINCT  
    (CAST(T.NodeID as nvarchar)) NodeID,   
    cast(T.ParentID AS NVARCHAR) [ParentID],  
     T.NodeName,   
    T.NodeIcon,   
    T.NodeLevel,   
    1 [Expanded],
	'0' as BT_UPDATE,   
	T.NodeType    
  FROM   
    tblTags T JOIN   
    tblimagetag tit ON t.nodeid = tit.tagid  
  WHERE   
    CaseID = @CASEID AND parentid IS NOT NULL   
    and t.DomainId=@DomainId  
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
    tbldocimages I JOIN   
    tblImageTag IT ON IT.ImageID=i.ImageID JOIN   
    tblTags T ON T.NodeID = IT.TagID AND T.CaseID = @CASEID LEFT JOIN   
    tblBasePath B ON B.BasePathId = I.BasePathId  
    --tblApplicationSettings s ON s.parametername='DocumentUploadLocation'   
  WHERE I.DomainId=@DomainId   
      
 END   
 ELSE  
 BEGIN  
  IF @ISARCHIVED='0'  
  INSERT INTO #TEMP  
   SELECT   
     CAST(T.NodeID as nvarchar) NodeID,   
    cast( T.ParentID AS NVARCHAR) [ParentID],  
     T.NodeName,   
     T.NodeIcon,   
     T.NodeLevel,   
      1 [Expanded],
	'0' as BT_UPDATE,   
	T.NodeType    
   FROM   
     tblTags T   
   WHERE   
     CaseID=@CASEID   
     and DomainId=@DomainId  
     
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
     tbldocimages I  INNER JOIN   
     tblImageTag IT ON IT.ImageID=i.ImageID  INNER JOIN   
     tblTags T ON T.NodeID=IT.TagID AND T.CaseID=@CASEID LEFT JOIN   
     tblBasePath B ON B.BasePathId = I.BasePathId  
     --tblApplicationSettings s ON s.parametername='DocumentUploadLocation'  
   WHERE I.DomainId=@DomainId  
       
     
  ELSE  
  INSERT iNTO #TEMP  
   SELECT   
    CAST(T.NodeID AS NVARCHAR) NodeID,   
    cast(T.ParentID AS NVARCHAR) [ParentID],   
    T.NodeName,   
    T.NodeIcon,   
    T.NodeLevel,   
     1 [Expanded],
	'0' as BT_UPDATE,   
	T.NodeType     
   FROM   
    tblTags T   
   WHERE   
    CaseID = @CASEID   
      
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
    tbldocimages I  INNER JOIN   
    tblImageTag IT ON IT.ImageID=i.ImageID  INNER JOIN   
    tblTags T ON T.NodeID=IT.TagID AND T.CaseID=@CASEID LEFT JOIN   
    tblBasePath B ON B.BasePathId = I.BasePathId  
    --tblApplicationSettings s ON s.parametername='ArchivedDocumentUploadLocation'     
   WHERE I.DomainId=@DomainId    
      
 END  
   
 if @UserId=0     
 SELECT * FROM #TEMP   ORDER BY   nodelevel,NodeName   
 else  
 SELECT * FROM #TEMP WHERE NodeName in(select nodename from MST_DOCUMENT_NODES where DomainId=@DomainId and NodeID in(select nodeid from dbo.tbl_node_role where DomainId=@DomainId and roleid in(select Roleid from dbo.IssueTracker_Users where DomainId=@DomainId and UserId =@UserID)))    
 ORDER BY   nodelevel,NodeName   
   
  
  SELECT   
   filename,  
   I.ImageID,  
   filepath,  
   nodename,  
   loginid,  
   REPLACE( B.VirtualBasePath+'/'+I.FilePath+I.FileName ,char(39),'&#39;')  as filepath ,   
   username  
  FROM   
   tbldocimages I  
   JOIN tblImageTag IT ON IT.ImageID=i.ImageID  
   JOIN tblTags T ON T.NodeID = IT.TagID and T.CaseID= @CASEID  
   LEFT JOIN tblBasePath B ON B.BasePathId = I.BasePathId  
   --tblApplicationSettings s ON s.parametername='DocumentUploadLocation'  
   LEFT JOIN dbo.IssueTracker_Users  ON UserId   = CASE WHEN  ISNUMERIC(loginid)= 1 THEN  loginid ELSE 1 END    
  WHERE I.DomainId = @DomainId  
  ORDER BY   
   nodelevel  
  
END  
  
  