
--document_manager_master_nodes 'amt'

CREATE PROCEDURE [dbo].[document_manager_master_nodes]       
 @DomainId	VARCHAR(50)   
AS      
BEGIN      
	declare @NodeID   INT      
	declare @NodeName  varchar(8000)      
	declare @parent_id  INT      
	declare @file_number VARCHAR(MAX)      
       
	create table #node_name       
	(      
		AUTO_ID		INT IDENTITY(1,1) NOT NULL,      
		NodeId		INT NOT NULL,      
		NodeName	VARCHAR(MAX) NOT NULL      
	)   
	   
	DECLARE node_cursor CURSOR FOR      
		select NodeId,NodeName,ParentID from MST_DOCUMENT_NODES  where DomainId = @DomainId      
	OPEN node_cursor;      
	FETCH NEXT FROM node_cursor INTO @NodeID, @NodeName, @parent_id;       
	declare @PID int      
	declare @NID int      
	declare @strNode varchar(8000)      
	declare @items varchar(8000)      
	DECLARE @final_string varchar(8000)      
	WHILE @@FETCH_STATUS = 0      
	BEGIN
		IF @parent_id IS NULL      
		BEGIN      
			INSERT INTO #node_name (NodeId,NodeName) VALUES (@NodeID,@NodeName)      
		END      
        
		IF @parent_id IS NOT NULL      
		BEGIN      
			SET @NID = @NodeID      
			SET @PID = (SELECT CASE WHEN ParentID = 0 THEN NULL ELSE ParentID END from MST_DOCUMENT_NODES where NodeID=@NodeID and DomainId=@DomainId)   
			SET @strNode = @NodeName      
			WHILE @PID IS NOT NULL      
			BEGIN      
				SET @strNode = @strNode + '\' + (select NodeName from MST_DOCUMENT_NODES where NodeID=@PID and DomainId=@DomainId)  
				SET @NID = @PID      
				SET @PID = (SELECT CASE WHEN ParentID = 0 THEN NULL ELSE ParentID END from MST_DOCUMENT_NODES where NodeID=@NID and DomainId=@DomainId)      
			END       
       
			SET @final_string = ''      
			DECLARE STRING_CURSOR CURSOR FOR      
				SELECT items from dbo.STRING_SPLIT(@strNode,'\') order by autoid desc      
			OPEN STRING_CURSOR;      
			FETCH NEXT FROM STRING_CURSOR INTO @items         
			WHILE @@FETCH_STATUS = 0      
			BEGIN      
					SET @final_string = @final_string + '\' + @items
					  
				FETCH NEXT FROM STRING_CURSOR INTO @items      
			END      
			CLOSE STRING_CURSOR      
			DEALLOCATE STRING_CURSOR 
			    
			IF(@final_string!='')    
				SET @final_string = (SELECT RIGHT(@final_string,LEN(@final_string)-1))        
   
			INSERT INTO #node_name (NodeId,NodeName) VALUES (@NodeID,@final_string)      
		END
	FETCH NEXT FROM node_cursor INTO @NodeID, @NodeName, @parent_id;      
 END      
      
 CLOSE node_cursor      
 DEALLOCATE node_cursor      
      
	SELECT
		0 AS AUTO_ID,0 AS NodeId,'--SELECT--' AS NodeName
	UNION
	SELECT * FROM #node_name  order by NodeName  
 DROP TABLE #node_name       
END  

  
