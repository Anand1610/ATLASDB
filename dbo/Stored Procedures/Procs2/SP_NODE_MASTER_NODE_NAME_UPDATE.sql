CREATE PROCEDURE [dbo].[SP_NODE_MASTER_NODE_NAME_UPDATE]
(  
	@NodeID		INT				=	NULL,
	@ParentID	INT				=	NULL,
	@NodeName	NVARCHAR(MAX)	=	'',      
	@UserID		BIGINT			=	NULL,
	@DomainId varchar(50)
)
AS      
BEGIN
	DECLARE @pk_update_queue_id		BIGINT			=	NULL
	DECLARE @result					INT				=	0
	DECLARE @CurrentParentID		BIGINT			=	NULL
	DECLARE @NewParentID			BIGINT			=	NULL
	DECLARE @i_l_fk_master_node_id	INT				=	NULL	
	DECLARE @FriendlyName			VARCHAR(MAX)	=	''
	DECLARE @Node_ID				BIGINT			=	NULL
	DECLARE @Parent_ID				BIGINT			=	NULL
	DECLARE @CaseID					VARCHAR(MAX)	=	''	
	DECLARE @node_level				INT				=	1
	
	SELECT @CurrentParentID = ParentID FROM MST_DOCUMENT_NODES WHERE NodeID = @NodeID and DomainId=@DomainId
	IF(ISNULL(@ParentID,0) <> @CurrentParentID)
		SET @NewParentID = @ParentID

	IF((SELECT NodeName FROM MST_DOCUMENT_NODES WHERE NodeID = @NodeID and DomainId=@DomainId) = @NodeName)
	BEGIN
		IF((SELECT ParentID FROM MST_DOCUMENT_NODES WHERE NodeID = @NodeID and DomainId=@DomainId) = @ParentID)
		BEGIN
			SET @result = 3
			SELECT @result AS [message]
			RETURN
		END		
	END

	--IF EXISTS(SELECT 1 FROM mst_document_nodes_update_queue WHERE node_id = @NodeID AND parent_id = @ParentID AND node_name = @NodeName AND ISNULL(is_updated,0) = 0)
	--BEGIN
	--	SET @result = 2
	--	SELECT @result AS [message]
	--	RETURN
	--END

	--INSERT INTO mst_document_nodes_update_queue
	--(
	--	node_id,				
	--	parent_id,
	--	node_name,
	--	node_level,
	--	expanded,
	--	friendly_name,		
	--	new_node_name,
	--	new_parent_id,
	--	fk_requested_by_id,
	--	requested_date,
	--	has_images,
	--	is_updated
	--)
	--SELECT
	--	NodeID,
	--	ParentID,
	--	NodeName,
	--	NodeLevel,
	--	Expanded,
	--	FriendlyName,		
	--	@NodeName,
	--	--@NewParentID,
	--	@ParentID,
	--	@UserID,
	--	GETDATE(),
	--	0,
	--	0
	--FROM
	--	MST_DOCUMENT_NODES
	--WHERE
	--	NodeID = @NodeID

	--SET @pk_update_queue_id = SCOPE_IDENTITY()
		
	CREATE TABLE #TEMP_NODE_LIST_UPDATE
	(
		NodeID INT
	)
	
	;WITH subnode_tree_update AS
	(
		SELECT
			NodeID,ParentID,NodeName
		FROM 
			MST_DOCUMENT_NODES
		WHERE 
			NodeID = @NodeID and DomainId=@DomainId
		UNION ALL
		SELECT 
			C.NodeID AS NodeID, C.ParentID,c.NodeName
		FROM 
			MST_DOCUMENT_NODES c
			JOIN subnode_tree_update p ON C.ParentID = P.NodeID 
	)

	--INSERT INTO #TEMP_NODE_LIST_UPDATE
	--SELECT NodeID FROM subnode_tree_update OPTION (MAXRECURSION 0)

	--DECLARE NODE_CURSOR_IMAGE_CHK CURSOR FOR          
	--	SELECT
	--		NodeID
	--	FROM
	--		#TEMP_NODE_LIST_UPDATE
	--	ORDER BY
	--		NodeID ASC
	--OPEN NODE_CURSOR_IMAGE_CHK          
	--FETCH NEXT FROM NODE_CURSOR_IMAGE_CHK INTO @i_l_fk_master_node_id            
	--WHILE @@FETCH_STATUS = 0          
	--BEGIN
	--		IF EXISTS (SELECT ImageID FROM tblDocImages WHERE ImageID IN (SELECT ImageID FROM tblImageTag WHERE TagID IN (SELECT NodeID FROM tblTags WHERE fk_master_node_id = @i_l_fk_master_node_id)))
	--		BEGIN
	--			SET @result = 1				
	--			BREAK
	--		END
						        
	--	FETCH NEXT FROM NODE_CURSOR_IMAGE_CHK INTO @i_l_fk_master_node_id       
	--END
	--CLOSE NODE_CURSOR_IMAGE_CHK
	--DEALLOCATE NODE_CURSOR_IMAGE_CHK
		
	--IF(@result = 1)
	--BEGIN
	--		UPDATE 
	--			mst_document_nodes_update_queue
	--		SET
	--			has_images			=	1
	--		WHERE
	--			pk_update_queue_id	=	@pk_update_queue_id
	--END
	--ELSE
	--BEGIN
	--		IF(@NewParentID IS NULL)
	--		BEGIN
	--			SELECT @FriendlyName	=	ISNULL(FriendlyName,'') FROM MST_DOCUMENT_NODES WHERE NodeID = @ParentID

	--			IF(ISNULL(@ParentID,0) = 0)
	--				SET @node_level	= 1
	--			ELSE
	--				SET @node_level	= 2
	--		END
	--		ELSE
	--		BEGIN
	--			SELECT @FriendlyName	=	ISNULL(FriendlyName,'') FROM MST_DOCUMENT_NODES WHERE NodeID = @NewParentID

	--			IF(ISNULL(@NewParentID,0) = 0)
	--				SET @node_level	= 1
	--			ELSE
	--				SET @node_level	= 2
	--		END

	--		IF(@FriendlyName = '')
	--			SET	@FriendlyName = @NodeName
	--		ELSE
	--			SET @FriendlyName = @FriendlyName +' - '+@NodeName 

	--		DECLARE NODE_CURSOR_IMAGE_CHK CURSOR FOR          
	--			SELECT
	--				NodeID
	--			FROM
	--				#TEMP_NODE_LIST_UPDATE
	--			ORDER BY
	--				NodeID ASC
	--		OPEN NODE_CURSOR_IMAGE_CHK          
	--		FETCH NEXT FROM NODE_CURSOR_IMAGE_CHK INTO @i_l_fk_master_node_id            
	--		WHILE @@FETCH_STATUS = 0          
	--		BEGIN
	--				DECLARE NODE_CURSOR_NEW CURSOR FOR
	--					SELECT
	--						NodeID,
	--						CaseID
	--					FROM
	--						tblTags
	--					WHERE
	--						fk_master_node_id = @i_l_fk_master_node_id
	--				OPEN NODE_CURSOR_NEW          
	--				FETCH NEXT FROM NODE_CURSOR_NEW INTO @Node_ID,@CaseID
	--				WHILE @@FETCH_STATUS = 0          
	--				BEGIN
						
	--					UPDATE
	--						tblTags
	--					SET
	--						NodeName			=	@NodeName,
	--						NodeLevel			=	@node_level
	--					WHERE
	--						NodeID				=	@Node_ID

	--					IF(@NewParentID IS NOT NULL)
	--					BEGIN
	--						SELECT @Parent_ID	=	NodeID FROM tblTags WHERE CaseID = @CaseID AND fk_master_node_id = @ParentID
	--						UPDATE
	--							tblTags
	--						SET
	--							ParentID			=	@Parent_ID
	--						WHERE
	--							NodeID				=	@Node_ID								
	--					END

	--					FETCH NEXT FROM NODE_CURSOR_NEW INTO @Node_ID,@CaseID
	--				END
	--				CLOSE NODE_CURSOR_NEW
	--				DEALLOCATE NODE_CURSOR_NEW
						        
	--			FETCH NEXT FROM NODE_CURSOR_IMAGE_CHK INTO @i_l_fk_master_node_id       
	--		END
	--		CLOSE NODE_CURSOR_IMAGE_CHK
	--		DEALLOCATE NODE_CURSOR_IMAGE_CHK
			
			UPDATE
				MST_DOCUMENT_NODES
			SET
				ParentID		=	@ParentID,
				NodeName		=	@NodeName,				
				NodeLevel		=	@node_level
			WHERE
				NodeID			=	@NodeID and DomainId=@DomainId

	--		UPDATE 
	--			mst_document_nodes_update_queue
	--		SET
	--			is_updated			=	1
	--		WHERE
	--			pk_update_queue_id	=	@pk_update_queue_id
	--END
	
	DROP TABLE #TEMP_NODE_LIST_UPDATE

	SELECT @result AS [message]
END  

