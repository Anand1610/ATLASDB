--sp_document_manager_nodes_for late_new'1'  
  
CREATE PROCEDURE [dbo].[sp_document_manager_nodes_for late_new]   
 @CASE_ID VARCHAR(5000)  
AS  
BEGIN  
 declare @NodeID INT  
 declare @NodeName varchar(8000)  
 declare @parent_id INT  
 create table #node_name   
 (  
  AUTO_ID INT IDENTITY(1,1) NOT NULL,  
  NodeId INT NOT NULL,  
  NodeName VARCHAR(8000) NOT NULL  
 )  
 declare node_cursor cursor for  
 select NodeId,NodeName,ParentID from tbltags where CaseID=@CASE_ID  
  
 OPEN node_cursor;  
 FETCH NEXT FROM node_cursor  
 INTO @NodeID, @NodeName, @parent_id;  
   
 declare @PID int  
 declare @NID int  
 declare @strNode varchar(8000)  
 declare @items varchar(8000)  
 DECLARE @final_string varchar(8000)  
 declare @filename varchar(max)
 DECLARE @CHKPID varchar(max)
 
 SET @filename = (SELECT file_number from IRIS.dbo.tbl_case_details where pk_case_id=@CASE_ID)
 PRINT(@filename)
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
    
  IF @parent_id IS NULL  
  BEGIN  
   INSERT INTO #node_name (NodeId,NodeName) VALUES (@NodeID,@filename)  
  END  
    
  IF @parent_id IS NOT NULL  
  BEGIN  
   SET @NID = @NodeID  
   SET @PID = (SELECT ParentID from tblTags where NodeID=@NodeID)  
   SET @strNode = @NodeName  
   WHILE @PID IS NOT NULL  
   BEGIN  
	SET @CHKPID = (SELECT ParentID from tblTags where NodeID=@PID)
	print(@CHKPID)
	IF @CHKPID IS NULL
	BEGIN
		SET @strNode = @strNode + '\' + @filename  
	END
	ELSE
	BEGIN
		SET @strNode = @strNode + '\' + (select NodeName from tblTags where NodeID=@PID)  
	END
    SET @NID = @PID  
    SET @PID = (SELECT ParentID from tblTags where NodeID=@NID)  
   END  
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
   SET @final_string = (SELECT RIGHT(@final_string,LEN(@final_string)-1))  
   INSERT INTO #node_name (NodeId,NodeName) VALUES (@NodeID,@final_string)  
  END  
    
  FETCH NEXT FROM node_cursor  
  INTO @NodeID, @NodeName, @parent_id;  
 END  
  
 CLOSE node_cursor  
 DEALLOCATE node_cursor  
  
 SELECT * FROM #node_name    order by NodeName
 DROP TABLE #node_name   
END

