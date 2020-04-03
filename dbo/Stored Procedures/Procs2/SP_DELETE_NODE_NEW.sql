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
		DELETE
		FROM tblDocImages
		WHERE ImageID IN (
				SELECT ImageID
				FROM tblImageTag
				WHERE TagID = @SZ_NODEID
					AND DomainId = @DomainId
				)

		DELETE
		FROM tblDocImages
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

		DELETE
		FROM tblImageTag
		WHERE TagID = @SZ_NODEID

		DELETE
		FROM tblImageTag
		WHERE TagID IN (
				SELECT NodeId
				FROM tblTags
				WHERE ParentID = @SZ_NODEID
					AND DomainId = @DomainId
				)

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

		SET @Description = @fileName + ', is deleted Successfully.'

		EXEC sp_document_log_insert @DomainId = @DomainId
			,@i_a_user_id = @UserID
			,@i_a_node_id = @SZ_NODEID
			,@s_a_document_name = @fileName
			,@s_a_operation = 'Deleted'
			,@s_a_log_action = @Description
			,@i_a_Case_id = @caseId

		DELETE
		FROM tblDocImages
		WHERE ImageID = @SZ_NODEID

		DELETE
		FROM tblImageTag
		WHERE ImageID = @SZ_NODEID
			AND DomainId = @DomainId

		
	END
END