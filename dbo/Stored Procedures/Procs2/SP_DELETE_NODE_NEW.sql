CREATE PROCEDURE [dbo].[SP_DELETE_NODE_NEW] (
	@DomainId NVARCHAR(50)
	,@SZ_NODEID INT
	,@SZ_TYPE VARCHAR(MAX)
	,@UserID INT
	)
AS
BEGIN
	--N for Node & F for File
	IF (@SZ_TYPE = 'N') --N
	BEGIN
	 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  

		 --DELETE  
  --FROM tblDocImages  
  --WHERE ImageID IN (  
  --  SELECT ImageID  
  --  FROM tblImageTag  
  --  WHERE TagID = @SZ_NODEID  
  --   AND DomainId = @DomainId  
  --  )  
  
    
  --DELETE  
  --FROM tblDocImages  
  --WHERE ImageID IN (  
  --  SELECT ImageID  
  --  FROM tblImageTag  
  --  WHERE TagID IN (  
  --    SELECT NodeId  
  --    FROM tblTags  
  --    WHERE ParentID = @SZ_NODEID  
  --     AND DomainId = @DomainId  
  --    )  
  --  )  
  
  --DELETE  
  --FROM tblImageTag  
  --WHERE TagID = @SZ_NODEID  
  
  --DELETE  
  --FROM tblImageTag  
  --WHERE TagID IN (  
  --  SELECT NodeId  
  --  FROM tblTags  
  --  WHERE ParentID = @SZ_NODEID  
  --   AND DomainId = @DomainId  
  --  )  
  
  UPDATE tblDocImages SET IsDeleted=1  
  WHERE ImageID IN (  
    SELECT ImageID  
    FROM tblImageTag  
    WHERE TagID = @SZ_NODEID  
     AND DomainId = @DomainId  
    )  
  
  
        UPDATE tblDocImages SET IsDeleted=1  
  WHERE ImageID IN (  
    SELECT ImageID  
    FROM tblImageTag  
    WHERE TagID IN (  
      SELECT NodeId  
      FROM tblTags  
      WHERE ParentID = @SZ_NODEID  
       AND DomainId = @DomainId  
      )  
    )  
  
  UPDATE tblImageTag SET IsDeleted=1  
  WHERE TagID = @SZ_NODEID  
  
  UPDATE tblImageTag SET IsDeleted=1  
  WHERE TagID IN (  
    SELECT NodeId  
    FROM tblTags  
    WHERE ParentID = @SZ_NODEID  
     AND DomainId = @DomainId  
    )  
  
    ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
  
		DELETE
		FROM tblTags
		WHERE NodeID = @SZ_NODEID

		DELETE
		FROM tblTags
		WHERE ParentID = @SZ_NODEID
			AND DomainId = @DomainId
	END
	ELSE --F
	BEGIN
		DECLARE @caseId VARCHAR(100)
		DECLARE @fileName VARCHAR(100)
		DECLARE @Description VARCHAR(100)

		SELECT @caseId = tt.CaseID
			,@fileName = tdi.[Filename]
		FROM tblDocImages tdi(NOLOCK)
		JOIN tblImageTag tit(NOLOCK) ON tit.ImageID = tdi.ImageID
		JOIN tblTags tt(NOLOCK) ON tt.NodeID = tit.TagID
		WHERE tdi.ImageID = @SZ_NODEID
		  ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
         AND tdi.IsDeleted=0 AND tit.IsDeleted=0   
        ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  

		---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
  
  update tblImageTag  
   SET IsDeleted =1  
   WHERE ImageID = @SZ_NODEID  
  
  
      update tblDocImages  
   SET IsDeleted =1  
   WHERE ImageID = @SZ_NODEID  
   ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  

		SET @Description = @fileName + ', is deleted Successfully.'

		EXEC sp_document_log_insert @DomainId = @DomainId
			,@i_a_user_id = @UserID
			,@i_a_node_id = @SZ_NODEID
			,@s_a_document_name = @fileName
			,@s_a_operation = 'Deleted'
			,@s_a_log_action = @Description
			,@i_a_Case_id = @caseId
			---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
		--DELETE
		--FROM tblDocImages
		--WHERE ImageID = @SZ_NODEID

		--DELETE
		--FROM tblImageTag
		--WHERE ImageID = @SZ_NODEID
		--	AND DomainId = @DomainId
		---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  

		
	END
END