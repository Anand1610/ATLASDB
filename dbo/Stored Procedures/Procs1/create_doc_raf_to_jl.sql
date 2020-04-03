
CREATE PROC [dbo].[create_doc_raf_to_jl] --- create_doc_raf_to_jl 'jl',5
 @DomainID VARCHAR(40)
	,@BasePatID INT
AS
BEGIN
	DECLARE @LogDescription VARCHAR(255)
	DECLARE @RowCount INT

	BEGIN TRY
		BEGIN TRANSACTION

		SELECT DISTINCT top 3 CaseId
			,AtlasCaseID
		INTO #TEMP
		FROM XN_TEMP_GBB_ALL_RFA_JL
		WHERE isnull(DownloadStatus, 0) = 0

		SELECT ROW_NUMBER() OVER (
				ORDER BY t1.imageID ASC
				) [RowID]
			,t1.imageID
			,t1.filename
			,t1.filepath
			,t3.nodename
			,t5.nodeid
		INTO #tempDocs
		FROM [RFA_Atlas_Docs].dbo.tblDocImages t1
		JOIN [RFA_Atlas_Docs].dbo.tblImageTag t2 ON t1.ImageID = t2.ImageID
		JOIN [RFA_Atlas_Docs].dbo.tbltags t3 ON t2.TagID = t3.NodeID
		JOIN #TEMP t4 ON t4.CaseId = t3.caseid
		JOIN tbltags t5 ON t5.caseid = t4.AtlasCaseID
			AND t3.nodename = t5.nodename
			AND t5.domainID = @DomainID

		DECLARE @Count INT = (
				SELECT count(RowID)
				FROM #tempDocs
				)
		DECLARE @row INT = 1

		SET @LogDescription = 'Total No Of Docs ' + CAST(@Count AS VARCHAR(5))

		INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
		VALUES (@LogDescription)

		WHILE @row < @Count
		BEGIN
	 
	 print @row
			SET @LogDescription = 'Inside While Loop and counter is ' + CAST(@row AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@LogDescription)

			DECLARE @filename VARCHAR(255)
				,@filepath VARCHAR(255)
				,@nodename VARCHAR(64)
				,@nodeid INT
			DECLARE @ImgID INT
				,@LoginId INT

			SELECT @filename = filename
				,@filepath = filepath
				,@nodename = nodename
				,@nodeid = nodeid
			FROM #tempDocs
			WHERE RowID = @row
			print  @filename
			print @nodeid
			IF NOT EXISTS (
					SELECT ImageID
					FROM tblDocImages
					WHERE @filename = filename
						AND @filepath = filepath
						AND BasePathId = @BasePatID
					)
			BEGIN
				SET @LogDescription = 'ImageID Does not Exists Inserting into TBLDOCIMAGES Table'

				INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
				VALUES (@LogDescription)

				INSERT INTO tblDocImages (
					Filename
					,FilePath
					,STATUS
					,from_flag
					,DomainId
					,statusdone
					,azure_statusdone
					,BasePathId
					)
				VALUES (
					@filename
					,@filepath
					,1
					,1
					,@DomainID
					,'Done'
					,'Done'
					,@BasePatID
					)

				SET @ImgID = SCOPE_IDENTITY()
				SET @LoginId = (
						SELECT UserId
						FROM IssueTracker_Users
						WHERE domainID = @DomainID
							AND UserName = 'admin'
						)
				SET @LogDescription = 'Inserting into TBLIMAGETAG table'
				print @ImgID
				INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
				VALUES (@LogDescription)
			
				INSERT INTO tblImageTag (
					ImageID
					,TagID
					,LoginID
					,DateInserted
					,DomainId
					)
				VALUES (
					@ImgID
					,@nodeid
					,@LoginId
					,getdate()
					,@DomainID
					)
			END

			SET @row = @row + 1
			SET @LogDescription = 'Updating XN_TEMP_GBB_ALL_RFA_JL setting nodeStatus to 1'

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@LogDescription)
		END

		UPDATE XN_TEMP_GBB_ALL_RFA_JL
		SET DownloadStatus = 1
		WHERE isnull(DownloadStatus, 0) = 0
			AND CaseId IN (
				SELECT CaseId
				FROM #TEMP
				)

		DROP TABLE #TEMP

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION

		PRINT '43'

		DECLARE @ErrorMessage VARCHAR(max)

		SET @ErrorMessage = ERROR_MESSAGE()
		SET @LogDescription = 'Exception : ' + @ErrorMessage

		INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
		VALUES (@LogDescription)

		RAISERROR (
				@ErrorMessage
				,16
				,1
				)
	END CATCH
END
