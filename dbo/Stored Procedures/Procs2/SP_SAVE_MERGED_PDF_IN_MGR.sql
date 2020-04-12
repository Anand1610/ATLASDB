CREATE PROCEDURE [dbo].[SP_SAVE_MERGED_PDF_IN_MGR] @DomainId NVARCHAR(50)
	,@p_szCaseID NVARCHAR(50)
	,@p_szFileName NVARCHAR(255)
	,@p_szYearPath NVARCHAR(255)
	,@p_szLoginId NVARCHAR(20)
	,@i_a_BasePathId INT
	,@NodeName VARCHAR(20) = ''
AS
DECLARE @szCaseID NVARCHAR(50)
DECLARE @iImageID INT
DECLARE @iNodeID INT
DECLARE @iDocCount INT
DECLARE @ParentID INT
DECLARE @NodeLevel INT = 0

BEGIN
	SET @szCaseId = @p_szCaseID
	SET @iDocCount = (
			SELECT count(imageid)
			FROM tbldocimages(NOLOCK)
			WHERE DomainId = @DomainId
				AND lower([filename]) = lower(@p_szFileName)
				AND lower(filepath) = lower(@p_szYearPath)
						   ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
                AND IsDeleted=0  
                ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
			)
	
	SET @ParentID = (
			SELECT MIN(nodeid)
			FROM tbltags(NOLOCK)
			WHERE caseid = @szCaseId
				AND DomainId = @DomainId
			)

	IF NOT EXISTS (
			SELECT 1
			FROM tblTags(NOLOCK)
			WHERE (
					@NodeName = ''
					OR NodeName = @NodeName
					)
				AND ParentID = @ParentID
				AND CaseID = @szCaseId
				AND DomainId = @DomainId
			)
	BEGIN
		SELECT @NodeLevel = nodelevel + 1
		FROM tbltags(NOLOCK)
		WHERE nodeid = @ParentID
			AND DomainId = @DomainId

		INSERT INTO tblTags (
			NodeName
			,Expanded
			,ParentID
			,CaseID
			,NodeLevel
			,NodeIcon
			,DomainId
			)
		VALUES (
			@NodeName
			,1
			,@ParentID
			,@szCaseId
			,@NodeLevel
			,'Folder.gif'
			,@DomainId
			)

		SET @iNodeID = SCOPE_IDENTITY()
	END
	ELSE IF (@NodeName <> '')
	BEGIN
		SET @iNodeID = (
				SELECT nodeid
				FROM tblTags(NOLOCK)
				WHERE NodeName = @NodeName
					AND ParentID = @ParentID
					AND CaseID = @szCaseId
					AND DomainId = @DomainId
				)
	END
	ELSE
	BEGIN
		SET @iNodeID = (
				SELECT MIN(nodeid)
				FROM tbltags(NOLOCK)
				WHERE caseid = @szCaseId
					AND DomainId = @DomainId
				)
	END

	IF (@iDocCount = 0)
	BEGIN
		INSERT INTO tbldocimages (
			DomainId
			,[filename]
			,filepath
			,ocrdata
			,[status]
			,BasePathId
			)
		VALUES (
			@DomainId
			,@p_szFileName
			,@p_szYearPath
			,''
			,1
			,@i_a_BasePathId
			)

		SET @iImageID = SCOPE_IDENTITY()

		INSERT INTO tblimagetag (
			DomainId
			,imageid
			,tagid
			,loginid
			,dateinserted
			,datemodified
			)
		VALUES (
			@DomainId
			,@iImageID
			,@iNodeID
			,@p_szLoginId
			,GETDATE()
			,NULL
			)
	END
END

GO


