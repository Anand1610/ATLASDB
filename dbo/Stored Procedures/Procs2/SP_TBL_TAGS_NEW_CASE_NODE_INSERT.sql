CREATE PROCEDURE  [dbo].[SP_TBL_TAGS_NEW_CASE_NODE_INSERT]   
(    
	@DomainId NVARCHAR(50),
	@s_a_case_id nvarchar(200)  
)    
AS    
	BEGIN       
	DECLARE @main_parent_id INT,@i_l_duplicate INT,@Parent_Id  INT,@node_level INT,@parent_name VARCHAR(MAX),
	@Sub_Parent_Id  INT,@sz_node_name NVARCHAR(200),@I_PARENT_ID  INT,@maxID INT  
	SET @maxID   = 0  
	SET @main_parent_id = 0  
	SET @i_l_duplicate = 0

	SELECT @i_l_duplicate = COUNT(*) FROM tblTags WHERE caseid = @s_a_case_id and DomainId=@DomainId
  
	IF(@i_l_duplicate = 0)
	BEGIN  
		DECLARE NODE_CURSOR CURSOR FOR  
		SELECT    
			nodename,parentid,nodelevel  
		FROM   
			MST_DOCUMENT_NODES    
		WHERE    
			NODEID IN(SELECT PARENTID  FROM MST_DOCUMENT_NODES WHERE DomainId=@DomainId)  OR PARENTID IN(SELECT NODEID FROM MST_DOCUMENT_NODES WHERE DomainId=@DomainId)  OR PARENTID = 0     
		ORDER BY   
			parentid    
		OPEN NODE_CURSOR      
		FETCH NEXT FROM NODE_CURSOR INTO @sz_node_name,@Sub_Parent_Id,@node_level  
		WHILE @@FETCH_STATUS = 0      
		BEGIN   
			IF(@maxID = 0)  
			BEGIN  
				INSERT INTO tblTags(ParentID,NodeName,CaseID,DocTypeID,NodeIcon,NodeLevel,Expanded,NodeType,CaseType,DomainId)  
				VALUES(NULL,@s_a_case_id,@s_a_case_id,NULL,'Folder.gif',0,1,NULL,NULL,@DomainId)  
				SET @main_parent_id = SCOPE_IDENTITY()  
			END         
			IF(@node_level=1)  
				BEGIN        
					INSERT INTO tblTags(ParentID,NodeName,CaseID,DocTypeID,NodeIcon,NodeLevel,Expanded,NodeType,CaseType,DomainId)  
					VALUES(@main_parent_id,@sz_node_name,@s_a_case_id,NULL,NULL,@node_level,0,NULL,NULL,@DomainId)  
				END    
			ELSE    
			BEGIN    
				SET @Parent_id  = 0    
				SET @parent_name = ''  

				SELECT @Parent_id = parentid FROM mst_document_nodes WHERE NodeName = @sz_node_name and DomainId=@DomainId  
				SELECT @parent_name = nodename FROM mst_document_nodes WHERE Nodeid = @Parent_id and DomainId=@DomainId
				SET @Parent_id  = 0  
				SELECT @Parent_id = NodeID FROM tblTags WHERE NodeName=@parent_name AND CaseID = @s_a_case_id and DomainId=@DomainId  

				INSERT INTO tblTags(ParentID,NodeName,CaseID,DocTypeID,NodeIcon,NodeLevel,Expanded,NodeType,CaseType,DomainId)  
				VALUES(@Parent_id,@sz_node_name,@s_a_case_id,NULL,NULL,@node_level,0,NULL,NULL,@DomainId)  
			END    
  
			SET @maxID = @maxID +1  
		FETCH NEXT FROM NODE_CURSOR INTO @sz_node_name,@Sub_Parent_Id,@node_level  
   END   
   CLOSE NODE_CURSOR      
   DEALLOCATE NODE_CURSOR  

	SET @Parent_Id		=	0
	
	IF(NOT EXISTS(SELECT * FROM tblTags WHERE caseid = @s_a_case_id  AND nodename = 'Settlement' and DomainId=@DomainId))
	BEGIN
		SELECT TOP 1 @Parent_Id = NodeID  FROM tblTags WHERE DomainId=@DomainId and caseid = @s_a_case_id and (nodeName = @s_a_case_id OR parentid IS NULL)
		
		INSERT INTO tblTags(ParentID,NodeName,CaseID,DocTypeID,NodeIcon,NodeLevel,Expanded,NodeType,CaseType,DomainId)  
				VALUES(@Parent_Id,'Settlement',@s_a_case_id,NULL,NULL,1,0,NULL,NULL,@DomainId)  
	END  
  END  
END

