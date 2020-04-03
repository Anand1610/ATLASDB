CREATE PROCEDURE  [dbo].[sp_createDefaultDocTypesForTree] --[sp_createDefaultDocTypesForTree] 'FH13-159692','FH13-159692'        
( 
 @DomainId nvarchar(50),       
 @CID nvarchar(200)='7',        
 @NodeName nvarchar(200)='7'    
)        
AS        
BEGIN   

		DECLARE @Parent_ID INTEGER , @NodeLevel  INTEGER

		SET @Parent_ID = ( SELECT NodeID FROM tblTags (NOLOCK)
							WHERE DomainId = @DomainId AND CASEID = @CID AND ParentID IS NULL
						)
		-- SELECT * from tblTags WHERE CaseID = 'RFA18-227137'
		IF (@Parent_ID IS NULL)
		BEGIN
			INSERT INTO tblTags (PARENTID, NODENAME,CASEID, DOCTYPEID, NODEICON, NODELEVEL, EXPANDED, DOMAINID)        
			VALUES (null, @CID, @CID, null, 'Folder.gif', 0,1,@DomainId)     
			SET @Parent_id=@@IDENTITY    
		END
		IF NOT EXISTS(SELECT Top 1 NodeName from tblTags (NOLOCK) WHERE PARENTID IS NOT NULL AND CaseID = @CID AND DomainId =@DomainId)
		BEGIN
			DECLARE @tblNode AS TABLE
			(
				NodeID INT,
				NodeName VARCHAR(100),
				ParentID INT,
				NodeLevel INT,
				Expanded INT
			)
			INSERT INTO @tblNode
			SELECT    
				DISTINCT NodeID,NodeName,ParentID,NodeLevel ,Expanded  
			FROM   
				MST_DOCUMENT_NODES (NOLOCK)
			WHERE DomainId =  @DomainId        
			ORDER BY parentid,NodeName

			DECLARE @TotalCount INT = 0
			DECLARE @Counter INT = 1
			SET @TotalCount = ISNULL((SELECT MAX(NodeLevel) FROM @tblNode),0)

			WHILE(@Counter <= @TotalCount)
			BEGIN
				
				IF @Counter = 1
					INSERT INTO tblTags(NodeName,Expanded,ParentID,CaseID,NodeLevel,DomainId)         
					SELECT NodeName, Expanded , @Parent_ID,@CID,NodeLevel,@DomainId FROM @tblNode 
					WHERE ParentID = 0
					ORDER By NodeName
				ELSE
					INSERT INTO tblTags(NodeName,Expanded,ParentID,CaseID,NodeLevel,DomainId)         
					SELECT a.NodeName, a.Expanded ,T.NodeID , @CID ,a.NodeLevel,@DomainId  FROM @tblNode  a
					INNER JOIN @tblNode b on a.ParentID = b.NodeID
					INNER JOIN tblTags T (NOLOCK) on b.NodeName = T.NodeName and b.NodeLevel = T.NodeLevel 
					WHERE  CaseID = @CID 
					and a.NodeLevel = @Counter
					ORDER BY NodeName
				
				SET @Counter = @Counter + 1
			END
		END
--DECLARE @Parent_Id  INTEGER,        
--       @Sub_Parent_Id  int,        
--       @CaseID varchar(200),         
--       @SZ_NODE_NAME NVARCHAR(200),        
--       @I_PARENT_ID  int,        
--       @maxID INTEGER 
--set @CaseID=@CID  
--IF ((SELECT ISNULL(COUNT(caseid),0) from tblTags Where CaseID =@CaseID and ParentID is not null and DomainId=@DomainId)= 0)
--BEGIN
--       SET @Parent_id=  (Select TOP 1 ISNULL(NODEID,0) from tblTags where NodeName=@NodeName and caseid =@CID and DomainId=@DomainId)        
         
--       IF(@Parent_id is null)  
--       begin  
--           INSERT INTO tblTags (DomainId, PARENTID, NODENAME,CASEID, DOCTYPEID, NODEICON, NODELEVEL, EXPANDED)        
--           VALUES (@DomainId, null, @CASEID, @CASEID, null, 'Folder.gif', 0,1)     
--           set @Parent_id=@@IDENTITY    
--       end  
    
--       DECLARE NODE_CURSOR CURSOR FOR          
--            SELECT    
--             NodeName,ParentID   
--            FROM   
--             MST_DOCUMENT_NODES        
--            WHERE        
--             NODEID IN(SELECT PARENTID  FROM MST_DOCUMENT_NODES WHERe DomainId=@DomainId)        
--             OR PARENTID IN(SELECT NODEID FROM MST_DOCUMENT_NODES WHERE DomainId=@DomainId)        
--             OR PARENTID = 0         
--			 AND @DomainId = DomainId
--            ORDER BY parentid        
           
--       OPEN NODE_CURSOR          
--       FETCH NEXT FROM NODE_CURSOR INTO @SZ_NODE_NAME,@Sub_Parent_Id              
--       WHILE @@FETCH_STATUS = 0          
--       BEGIN          
--               IF @Sub_Parent_Id=0         
--               BEGIN            
--                INSERT INTO tblTags(DomainId, NodeName,Expanded,ParentID,CaseID,NodeLevel)         
--                VALUES(@DomainId, @SZ_NODE_NAME,0,@Parent_ID,@CaseID,1)        
--               END        
--              ELSE        
--              BEGIN        
--               SET @I_PARENT_ID =  
--               (  
--                Select   
--                 max(NodeID)   
--                from   
--                 tblTags         
--                WHERE   
--                 NODENAME=(SELECT NODENAME FROM MST_DOCUMENT_NODES WHERE NODEID=@Sub_Parent_Id and DomainId=@DomainId) and caseid=@CID  AND DomainId = @DomainId
--               )  
--               INSERT INTO tblTags  
--               (  
--                DomainId, NodeName,Expanded,ParentID,CaseID,NodeLevel  
--               )         
--               VALUES  
--               (  
--                @DomainId, @SZ_NODE_NAME,0,@I_PARENT_ID,@CaseID,2  
--               )        
--              END           
              
--             FETCH NEXT FROM NODE_CURSOR INTO @SZ_NODE_NAME,@Sub_Parent_Id        
--      END          
           
--   CLOSE NODE_CURSOR          
--   DEALLOCATE NODE_CURSOR        
        
         
--END       
--else 
--begin
--	SET @Parent_id=  (Select TOP 1 ISNULL(NODEID,0) from tblTags where NodeName=@CID and DomainId=@DomainId and caseid=@CID)        
--	DECLARE NODE_CURSOR CURSOR FOR          
--	SELECT    
--	NodeName,ParentID   
--	FROM   
--	MST_DOCUMENT_NODES        
--	WHERE        
--	(NODEID IN(SELECT PARENTID  FROM MST_DOCUMENT_NODES WHERE DomainId=@DomainId)        
--	OR PARENTID IN(SELECT NODEID FROM MST_DOCUMENT_NODES WHERE DomainId=@DomainId)        
--	OR PARENTID = 0)    
--	and NodeName not in(Select distinct NodeName from tbltags where CaseId=@CID AND DomainId = @DomainId)
--	and DomainId=@DomainId
--	ORDER BY parentid        

--	OPEN NODE_CURSOR          
--	FETCH NEXT FROM NODE_CURSOR INTO @SZ_NODE_NAME,@Sub_Parent_Id              
--	WHILE @@FETCH_STATUS = 0          
--	BEGIN 
	
--		IF NOT EXISTS(SELECT NODEID FROM tblTags WHERE NodeName =@SZ_NODE_NAME and CaseID=@CID AND @DomainId = DomainId)
--		BEGIN
--		print(@SZ_NODE_NAME)
--			IF @Sub_Parent_Id=0         
--			BEGIN            
--				INSERT INTO tblTags(DomainId, NodeName,Expanded,ParentID,CaseID,NodeLevel)         
--				VALUES(@DomainId, @SZ_NODE_NAME,0,@Parent_ID,@CID,1)        
--			END        
--			ELSE        
--			BEGIN        
--				SET @I_PARENT_ID =  
--				(  
--				Select   
--				max(NodeID)   
--				from   
--				tblTags         
--				WHERE   
--				NODENAME=(SELECT NODENAME FROM MST_DOCUMENT_NODES WHERE NODEID=@Sub_Parent_Id and DomainId=@DomainId) and caseid=@CID AND DomainId = @DomainId 
--				)  
--				INSERT INTO tblTags  
--				(  
--				DomainId, NodeName,Expanded,ParentID,CaseID,NodeLevel  
--				)         
--				VALUES  
--				(  
--				@DomainId, @SZ_NODE_NAME,0,@I_PARENT_ID,@CID,2  
--				)        
--			END           	
--		END
--		FETCH NEXT FROM NODE_CURSOR INTO @SZ_NODE_NAME,@Sub_Parent_Id        
--	END          

--	CLOSE NODE_CURSOR          
--	DEALLOCATE NODE_CURSOR
--end    


END

