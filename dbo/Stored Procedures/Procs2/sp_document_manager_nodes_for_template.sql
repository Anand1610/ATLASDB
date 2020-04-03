CREATE PROCEDURE [dbo].[sp_document_manager_nodes_for_template]     
 @DomainId VARCHAR(50),
 @CASE_ID VARCHAR(5000)=''  
AS    
BEGIN    
 declare @NodeID   INT    
 declare @NodeName  varchar(8000)    
 declare @parent_id  INT    
 declare @file_number VARCHAR(MAX)    
     
 create table #node_name     
 (    
  AUTO_ID INT IDENTITY(1,1) NOT NULL,    
  NodeId INT NOT NULL,    
  NodeName VARCHAR(8000) NOT NULL    
 )    
 declare node_cursor cursor for    
 select NodeId,NodeName,ParentID from tbltags  where CaseID=@CASE_ID AND DomainId = @DomainId    
 OPEN node_cursor;    
 FETCH NEXT FROM node_cursor    
 INTO @NodeID, @NodeName, @parent_id;     
 declare @PID int    
 declare @NID int    
 declare @strNode varchar(8000)    
 declare @items varchar(8000)    
 DECLARE @final_string varchar(8000)    
 WHILE @@FETCH_STATUS = 0    
 BEGIN    
  SET @file_number = ''    
      
  --SELECT @file_number = CASE_ID FROM dbo.tblcase WHERE Case_AutoId = @CASE_ID    
    SET   @file_number = @CASE_ID    
  IF @parent_id IS NULL    
  BEGIN    
   INSERT INTO #node_name (NodeId,NodeName) VALUES (@NodeID,@file_number)    
  END    
      
  IF @parent_id IS NOT NULL    
  BEGIN    
   SET @NID = @NodeID    
   SET @PID = (SELECT ParentID from tblTags where NodeID=@NodeID and DomainId=@DomainId)    
   SET @strNode = @NodeName    
   WHILE @PID IS NOT NULL    
   BEGIN    
    SET @strNode = @strNode + '\' + (select NodeName from tblTags where NodeID=@PID and DomainId=@DomainId)    
    SET @NID = @PID    
    SET @PID = (SELECT ParentID from tblTags where NodeID=@NID and DomainId=@DomainId)    
   END    
       
   SET @strNode = REPLACE(@strNode,@CASE_ID,@file_number)    
     
   SET @final_string = ''    
   DECLARE STRING_CURSOR CURSOR FOR    
   SELECT items from dbo.STRING_SPLIT(@strNode,'\') order by autoid desc    
   OPEN STRING_CURSOR;    
   FETCH NEXT FROM STRING_CURSOR    
   INTO @items       
   WHILE @@FETCH_STATUS = 0    
   BEGIN    
    SET @final_string = @final_string + '\' + @items    
    FETCH NEXT FROM STRING_CURSOR    
    INTO @items    
   END    
   CLOSE STRING_CURSOR    
   DEALLOCATE STRING_CURSOR    
   if(@final_string!='')  
   SET @final_string = (SELECT RIGHT(@final_string,LEN(@final_string)-1))      
   INSERT INTO #node_name (NodeId,NodeName) VALUES (@NodeID,@final_string)    
  END    
      
  FETCH NEXT FROM node_cursor    
  INTO @NodeID, @NodeName, @parent_id;    
 END    
    
 CLOSE node_cursor    
 DEALLOCATE node_cursor    
    
 SELECT * FROM #node_name  order by NodeName
 DROP TABLE #node_name     
END

--select * from tblTags where NodeID=1151150
--select * from tblTags where CONVERT(varchar, tblTags.TSTAMP,101)=CONVERT(varchar,getdate(),101) and ParentID is null
--update tblTags set ParentID=1120094 where  NodeID=1215725

