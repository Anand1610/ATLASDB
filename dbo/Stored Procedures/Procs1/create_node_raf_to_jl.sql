
CREATE PROC [dbo].[create_node_raf_to_jl] @DomainId VARCHAR(50)
AS
BEGIN
	DECLARE @LogDescription VARCHAR(255)
	DECLARE @RowCount INT

	BEGIN TRY
		BEGIN TRANSACTION

		SELECT DISTINCT CaseId
			,AtlasCaseID
		INTO #TEMP
		FROM XN_TEMP_GBB_ALL_RFA_JL
		WHERE isnull(NodeStatus, 0) = 0

		IF EXISTS (
				SELECT *
				FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
				WHERE TABLE_NAME = 'tbltags_rfa_import_temp'
				)
		BEGIN
			DROP TABLE tbltags_rfa_import_temp
		END

		SELECT ROW_NUMBER() OVER (
				ORDER BY t1.CaseID ASC
				) [RowID]
			,t1.*
			,t4.NodeName [ParentName]
		INTO tbltags_rfa_import_temp
		FROM [RFA_Atlas_Docs].dbo.tbltags t1
		JOIN [RFA_Atlas_Docs].dbo.tblImageTag it (NOLOCK) ON t1.NodeID = it.TagID
		JOIN #TEMP t2 ON t1.CaseID = t2.CaseID
		LEFT JOIN [RFA_Atlas_Docs].dbo.tbltags t4 ON t1.ParentID = t4.NodeID
		LEFT JOIN tblTags t3 ON t3.CaseID = t2.AtlasCaseID
			AND t1.NodeName = t3.NodeName
			AND @DomainId = t3.DomainId
		WHERE t3.NodeName IS NULL
		ORDER BY T1.NodeID

		DECLARE @Count INT = (
				SELECT count(RowID)
				FROM tbltags_rfa_import_temp
				)
		DECLARE @row INT = 1

		SET @LogDescription = 'Total No Of Tags and Node Name ' + CAST(@Count AS VARCHAR(5))

		INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
		VALUES (@LogDescription)

		WHILE @row < @Count
		BEGIN
			SET @LogDescription = 'Inside While Loop and counter is ' + CAST(@row AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@LogDescription)

			DECLARE @NodeName VARCHAR(600)
				,@CaseID VARCHAR(100)
				,@AtlasCaseID VARCHAR(100)
				,@ParentName VARCHAR(600)
				,@NodeLevel INT
				,@Expanded INT
				,@ParentID INT

			SELECT @NodeName = NodeName
				,@CaseID = CaseID
				,@ParentName = ParentName
				,@NodeLevel = NodeLevel
				,@Expanded = Expanded
			FROM tbltags_rfa_import_temp
			WHERE RowID = @row

			IF (@NodeName <> @CaseID)
			BEGIN
				SELECT @AtlasCaseID = AtlasCaseID
				FROM #TEMP
				WHERE CaseId = @CaseID

				SET @LogDescription = 'CaseID is ' + @AtlasCaseID + '@NodeName - ' + @NodeName

				INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
				VALUES (@LogDescription)

				IF NOT EXISTS (
						SELECT NodeID
						FROM tbltags(NOLOCK)
						WHERE CaseId = @AtlasCaseID
							AND NodeName = @NodeName
						)
				BEGIN
					SET @LogDescription = 'Node Does not Exists'

					INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
					VALUES (@LogDescription)

					
					IF (@ParentName = @CaseID)
					BEGIN
						SET @LogDescription = 'Parent Name is equal to Case ID'

						INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
						VALUES (@LogDescription)

						SET @ParentID = (
							SELECT NodeID
							FROM tbltags
							WHERE NodeName = @AtlasCaseID
								AND CaseID = @AtlasCaseID
							)

						INSERT INTO tbltags (
							ParentID
							,NodeName
							,CaseID
							,NodeLevel
							,Expanded
							,DomainId
							)
						VALUES (
							@ParentID
							,@NodeName
							,@AtlasCaseID
							,@NodeLevel
							,@Expanded
							,@DomainId
							)
					END
					ELSE
					BEGIN
						SET @LogDescription = 'ParentName is not equal to CaseID'

						INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
						VALUES (@LogDescription)

						SET @ParentID = (
								SELECT NodeID
								FROM tbltags
								WHERE NodeName = @ParentName
									AND CaseID = @AtlasCaseID
								)

						IF (@ParentID IS NOT NULL)
						BEGIN
							SET @LogDescription = 'ParentID is not null'

							INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
							VALUES (@LogDescription)

							INSERT INTO tbltags (
								ParentID
								,NodeName
								,CaseID
								,NodeLevel
								,Expanded
								,DomainId
								)
							VALUES (
								@ParentID
								,@NodeName
								,@AtlasCaseID
								,@NodeLevel
								,@Expanded
								,@DomainId
								)
						END
					END
				END
			END

			SET @row = @row + 1
		END

		SET @LogDescription = 'Updating XN_TEMP_GBB_ALL_RFA_JL setting nodeStatus to 1'

		INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
		VALUES (@LogDescription)

		UPDATE XN_TEMP_GBB_ALL_RFA_JL
		SET NodeStatus = 1
		WHERE isnull(NodeStatus, 0) = 0
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
