CREATE PROCEDURE [dbo].[STP_DSP_GET_CASEDOCUMENTNODELIST_LEAFED_NODES]  
 @DomainId NVARCHAR(50),  
 @CASEID NVARCHAR(255)='',  
 @ISARCHIVED NCHAR='0',  
 @OPERATION NVARCHAR(20)='LEAFED-NODES',  
 @UserId NVARCHAR(50)  
AS  
BEGIN  
  
CREATE TABLE #TEMP(NodeID NVARCHAR(100),ParentID INT,Nodename_code NVARCHAR(MAX),NodeIcon NVARCHAR(200),NodeLevel INT,Expanded INT,orderby NVARCHAR(MAX))  
  
 IF @OPERATION = 'LEAFED-NODES'  
 BEGIN  
 INSERT INTO #TEMP  
  SELECT   
    cast(T.NodeID AS NVARCHAR) NodeID,   
    T.ParentID,  
    '<input class=''c'' type=''checkbox'' id=''' + convert(nvarchar(50),T.NodeID) + ''' onclick=''ob_t2c(this)''>' + T.NodeName,   
    T.NodeIcon,   
    T.NodeLevel,   
    T.Expanded,  
    T.NodeName AS orderby  
   FROM   
    tblTags T   
   WHERE   
    CaseID= @CASEID AND   
    parentid IS NULL   
    and DomainId=@DomainId  
  UNION  
  SELECT   
    cast(NodeID AS NVARCHAR) NodeID,   
    TTAGS.ParentID,   
    '<input class=''c'' type=''checkbox'' id=''' + CONVERT(NVARCHAR(50),NodeID) + ''' onclick=''ob_t2c(this)''>' + TTAGS.NodeName,   
    TTAGS.NodeIcon,   
    TTAGS.NodeLevel,   
    TTAGS.Expanded,  
    TTAGS.NodeName AS orderby  
   FROM   
    TBLTAGS TTAGS   
   WHERE   
    NODEID IN (SELECT DISTINCT T.parentid  FROM tblTags T JOIN tblimagetag tit ON t.nodeid = tit.tagid WHERE CaseID = @CASEID AND parentid IS NOT NULL and T.DomainId=@DomainId) AND TTAGS.PARENTID IS NOT NULL  
    and DomainId=@DomainId  
     
  UNION   
  SELECT DISTINCT  
    (CAST(T.NodeID as nvarchar)) NodeID,   
    T.ParentID,   
    '<input class=''c'' type=''checkbox'' id=''' + convert(nvarchar(50),T.NodeID) + ''' onclick=''ob_t2c(this)''>' + T.NodeName,   
    T.NodeIcon,   
    T.NodeLevel,   
    T.Expanded,  
    T.NodeName AS orderby  
  FROM   
    tblTags T JOIN   
    tblimagetag tit ON t.nodeid = tit.tagid  
  WHERE   
    CaseID = @CASEID AND parentid IS NOT NULL   
    and t.DomainId=@DomainId  
  UNION  
  SELECT   
    'IMG-' + Cast(I.ImageID as nvarchar),   
    T.NodeID,   
    --'<input class=''c'' type=''checkbox'' id=''IMG-' + convert(nvarchar(50),I.ImageID) + ''' onclick=''ob_t2c(this)''> <a href='''+s.ParameterValue+I.FilePath+I.FileName +''' target=''imageframe'' onclick=''VisibleFrame();'' >'+I.FileName+'</a>', 'page.gif',   
    '<input class=''c'' type=''checkbox'' id=''IMG-' + convert(nvarchar(50),I.ImageID) + ''' onclick=''ob_t2c(this)''> <a href='''+  
      
    REPLACE( B.VirtualBasePath +'/'+I.FilePath+I.FileName ,char(39),'&#39;') +''' target=''imageframe'' onclick=''VisibleFrame();'' >'  
     + I.FileName+'</a>', 'page.gif',   
    T.NodeLevel+1,   
    1,  
    T.NodeName AS orderby  
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
     T.ParentID,   
     '<input class=''c'' type=''checkbox'' id=''' + convert(nvarchar(50),T.NodeID) + ''' onclick=''ob_t2c(this)''>' + T.NodeName,   
     T.NodeIcon,   
     T.NodeLevel,   
     T.Expanded,  
     T.NodeName AS orderby  
   FROM   
     tblTags T   
   WHERE   
     CaseID=@CASEID   
     and DomainId=@DomainId  
     
   UNION    
   SELECT   
     'IMG-' + Cast(I.ImageID as nvarchar),   
     T.NodeID,   
     --'<input class=''c'' type=''checkbox'' id=''IMG-' + convert(nvarchar(50),I.ImageID) + ''' onclick=''ob_t2c(this)''> <a href='''+s.ParameterValue+I.FilePath+I.FileName +''' target=''imageframe'' onclick=''VisibleFrame();''>'+I.FileName+'</a>', 'page.gif',   
     '<input class=''c'' type=''checkbox'' id=''IMG-' + convert(nvarchar(50),I.ImageID) + ''' onclick=''ob_t2c(this)''> <a href='''+  
      
    REPLACE( B.VirtualBasePath +'/'+I.FilePath+I.FileName ,char(39),'&#39;') +''' target=''imageframe'' onclick=''VisibleFrame();'' >'  
       
    + I.FileName+'</a>', 'page.gif',   
     T.NodeLevel+1,   
     1,  
     T.NodeName AS orderby  
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
    T.ParentID,  
    '<input class=''c'' type=''checkbox'' id=''' + convert(nvarchar(50),T.NodeID) + ''' onclick=''ob_t2c(this)''>' + T.NodeName,   
    T.NodeIcon,   
    T.NodeLevel,   
    T.Expanded,  
    T.NodeName AS orderby  
   FROM   
    tblTags T   
   WHERE   
    CaseID = @CASEID   
      
   UNION    
   SELECT   
    'IMG-' + Cast(I.ImageID as nvarchar),   
    T.NodeID,   
    --'<input class=''c'' type=''checkbox'' id=''IMG-' + convert(nvarchar(50),I.ImageID) + ''' onclick=''ob_t2c(this)''><a href='''+s.ParameterValue+I.FilePath+I.FileName +''' target=''imageframe'' onclick=''VisibleFrame();''>'+I.FileName+'</a>', 'page.gif',   
    '<input class=''c'' type=''checkbox'' id=''IMG-' + convert(nvarchar(50),I.ImageID) + ''' onclick=''ob_t2c(this)''> <a href='''+  
      
    REPLACE( B.VirtualBasePath +'/'+I.FilePath+I.FileName ,char(39),'&#39;') +''' target=''imageframe'' onclick=''VisibleFrame();'' >'  
    +I.FileName+'</a>', 'page.gif',   
    T.NodeLevel+1,   
    1,  
    T.NodeName AS orderby  
   FROM   
    tbldocimages I  INNER JOIN   
    tblImageTag IT ON IT.ImageID=i.ImageID  INNER JOIN   
    tblTags T ON T.NodeID=IT.TagID AND T.CaseID=@CASEID LEFT JOIN   
    tblBasePath B ON B.BasePathId = I.BasePathId  
    --tblApplicationSettings s ON s.parametername='ArchivedDocumentUploadLocation'     
   WHERE I.DomainId=@DomainId    
      
 END  
   
 if @UserId=0     
 SELECT * FROM #TEMP   ORDER BY   nodelevel,orderby   
 else  
 SELECT * FROM #TEMP WHERE orderby in(select nodename from MST_DOCUMENT_NODES where DomainId=@DomainId and NodeID in(select nodeid from dbo.tbl_node_role where DomainId=@DomainId and roleid in(select Roleid from dbo.IssueTracker_Users where DomainId=@DomainId and UserId =@UserID)))    
 ORDER BY   nodelevel,orderby   
   
  
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
  
  