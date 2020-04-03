
--Get_Case_NodeId_From_NodeName 'localhost','GLF18-102889','VERIFICATION RESPONSE'
--[Get_Case_NodeId_From_NodeName] 'amt','AMT18-102837','VERIFICATION REQUEST'
CREATE PROCEDURE [dbo].[Get_Case_NodeId_From_NodeName] -- [Get_Case_NodeId_From_NodeName] 'AF','ACT-AF-145825','VERIFICATION REQUEST'
(     
	@DomainId	VARCHAR(50),
	@CaseId		VARCHAR(MAX),
	@NodeName	VARCHAR(MAX)
)
AS      
BEGIN      
	DECLARE @i_l_node_id INT;   
	SET @i_l_node_id = ISNULL((SELECT top 1 ISNULL(NodeID,0) from tblTags  WHERE CaseID = @CaseId AND NodeName = @NodeName AND DomainId = @DomainId),0)
	IF(@i_l_node_id = 0)  
	BEGIN  
		EXEC sp_createDefaultDocTypesForTree  @DomainId,  @CaseId, @CaseId 
		Declare @ParentID int;
		DECLARE @NodeLevel INT = 0   
		
		Select TOP 1 @ParentID = NodeID from tbltags Where NodeName = @CaseId
		SELECT @NodeLevel = nodelevel+1 FROM tbltags WHERE nodeid=@ParentID and DomainId=@DomainId

		INSERT INTO tblTags    
		 (      
		  NodeName,Expanded,ParentID,CaseID,NodeLevel,NodeIcon,DomainId    
		 )             
		 VALUES    
		 (      
		  @NodeName,1,@ParentID,@CaseID,@NodeLevel,'Folder.gif',@DomainId    
		 )    

	END  

	
	SELECT TOP 1
		T.NodeID
	FROM
		tblTags T (NOLOCK)
	WHERE		
		T.DomainId			=	@DomainId AND
		T.CaseID			=	@CaseId AND
		LOWER(T.NodeName)	=	LOWER(@NodeName)
END  

  
