
CREATE PROCEDURE [dbo].[ImportRFATransactionTable] (
	@provider ProviderImport READONLY,
	@DomainID VARCHAR(20)
	,@Flag BIT
	)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		DECLARE @BeforeInsertCount INT
		DECLARE @NewInsertCount INT
		DECLARE @AfterInsertCount INT
		DECLARE @Description VARCHAR(255)

		SELECT *
		INTO #Provider
		FROM @provider

		SET @AfterInsertCount = @@ROWCOUNT
		SET @Description = 'Total Count Of Providers to Import Data is ' + CAST(@AfterInsertCount AS VARCHAR(5))

		INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
		VALUES (@Description)

		IF (@Flag = 1)
		BEGIN
			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'tblClientAccount_rfa_import_temp'
					)
			BEGIN
				DROP TABLE tblClientAccount_rfa_import_temp
			END

			SELECT Account_Id_old 
			INTO #tempAccountIdOld
			FROM tblClientAccount 
			WHERE DomainId = @DomainID

			SELECT t1.*
			INTO tblClientAccount_rfa_import_temp 
			FROM [RFA_Atlas].dbo.tblClientAccount t1
			JOIN #Provider ON t1.Provider_Id = #Provider.ProviderId
			LEFT JOIN #tempAccountIdOld ON t1.Account_Id = #tempAccountIdOld.Account_Id_old
			WHERE t1.Account_Id IS NULL

			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblClientAccount
			WHERE DomainId = @DomainID

			INSERT INTO tblClientAccount (
				Provider_Id
				,Gross_Amount
				,Firm_Fees
				,Cost_Balance
				,Applied_Cost
				,Final_Remit
				,Account_Date
				,Invoice_Image
				,Last_Printed
				,Prev_Cost_Balance
				,DomainId
				,Account_Id_old
				)
			SELECT t1.ATLAS_PROVIDER_ID
				,t.Gross_Amount
				,t.Firm_Fees
				,t.Cost_Balance
				,t.Applied_Cost
				,t.Final_Remit
				,t.Account_Date
				,t.Invoice_Image
				,t.Last_Printed
				,t.Prev_Cost_Balance
				,@DomainID
				,t.Account_Id
			FROM tblClientAccount_rfa_import_temp t
			--JOIN tblProvider_rfa_import_temp t1 ON t.Provider_Id = t1.Provider_Id
			JOIN RFA_JL_PROVIDERID_MAPPING t1 ON t.Provider_Id = t1.RFA_PROVIDER_ID AND t1.DomainId = @DomainID
			--JOIN tblProvider t2 ON t1.Provider_Name = t2.Provider_Name AND t2.Provider_Local_Address = t1.Provider_Local_Address
			--WHERE  t.Account_Id NOT IN (SELECT Account_Id_old FROM tblClientAccount WHERE DomainId = @DomainID) 

			SET @NewInsertCount = @@ROWCOUNT

			SELECT @AfterInsertCount = COUNT(*)
			FROM tblClientAccount
			WHERE DomainId = @DomainID

			SET @Description = 'tblClientAccount : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblClientAccount
			WHERE DomainId = @DomainID

			SET @Description = 'tblClientAccount : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		IF (@Flag = 1)
		BEGIN
			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'tblTransactions_rfa_import_temp'
					)
			BEGIN
				DROP TABLE tblTransactions_rfa_import_temp
			END

			SELECT DISTINCT AtlasCaseID,CaseId
			INTO	#tempCases
			FROM	XN_TEMP_GBB_ALL_RFA_JL
			WHERE	XN_TEMP_GBB_ALL_RFA_JL.Transferd_Status = 'Partially'

			SELECT Transactions_Id_OLD 
			INTO #tempTansactionIdOld
			FROM tblTransactions 
			WHERE DomainId = @DomainID

			SELECT t1.*
			INTO tblTransactions_rfa_import_temp
			FROM [RFA_Atlas].dbo.tblTransactions t1
			JOIN #Provider ON t1.Provider_Id = #Provider.ProviderId
			LEFT JOIN #tempTansactionIdOld ON t1.Transactions_Id = #tempTansactionIdOld.Transactions_Id_OLD
			WHERE t1.Transactions_Id IS NULL

			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblTransactions
			WHERE DomainId = @DomainID

			INSERT INTO tblTransactions (
				Case_Id
				,Transactions_Type
				,Transactions_Date
				,Transactions_Amount
				,Transactions_Description
				,Provider_Id
				,[User_Id]
				,Transactions_Fee
				,Transactions_status
				,Invoice_Id
				,Rfund_Deposite_Amount
				,FF_Paid_By
				,ChequeNo
				,CheckDate
				,BatchNo
				,DomainId
				,Transactions_Id_OLD
				)
			SELECT 
				t.AtlasCaseID
				,Transactions_Type
				,Transactions_Date
				,Transactions_Amount
				,Transactions_Description
				,t3.ATLAS_PROVIDER_ID
				,'Admin'
				,Transactions_Fee
				,Transactions_status
				,t2.Account_Id
				,Rfund_Deposite_Amount
				,FF_Paid_By
				,Check_Date
				,Check_Number
				,BatchNo
				,@DomainID
				,t1.Transactions_Id
			FROM tblTransactions_rfa_import_temp t1 (NOLOCK)
			LEFT JOIN tblClientAccount t2 (NOLOCK) ON t2.Account_Id_old = t1.Invoice_Id
			LEFT JOIN RFA_JL_PROVIDERID_MAPPING t3 (NOLOCK) ON t3.RFA_PROVIDER_ID = t1.provider_id AND t3.DomainId = @DomainID
			JOIN #tempCases t ON t1.Case_Id = t.CaseId 
			--WHERE t1.Transactions_Id NOT IN (SELECT Transactions_Id_OLD FROM #tempTansactionIdOld)
			--LEFT JOIN tblProvider_rfa_import_temp t3 ON t3.provider_id = t1.provider_id
			--LEFT JOIN tblProvider t4 ON t3..Provider_Name = t4.Provider_Name

			SET @NewInsertCount = @@ROWCOUNT

			SELECT @AfterInsertCount = COUNT(*)
			FROM tblTransactions
			WHERE DomainId = @DomainID

			SET @Description = 'tblTransactions : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblTransactions
			WHERE DomainId = @DomainID

			SET @Description = 'tblTransactions : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		IF (@Flag = 1)
		BEGIN
			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'tblsettlement_type_rfa_import_temp'
					)
			BEGIN
				DROP TABLE tblsettlement_type_rfa_import_temp
			END

			SELECT DISTINCT t1.*
			INTO tblsettlement_type_rfa_import_temp
			FROM [RFA_Atlas].dbo.tblsettlement_type t1
			WHERE Settlement_Type IS NOT NULL

			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblsettlement_type
			WHERE DomainId = @DomainID

			INSERT INTO tblsettlement_type (
				Settlement_Type
				,DomainId
				,created_by_user
				,created_date
				)
			SELECT t1.Settlement_Type
				,@DomainID
				,'admin'
				,getdate()
			FROM tblsettlement_type_rfa_import_temp t1
			LEFT JOIN tblSettlement_Type t2 ON t1.Settlement_Type = t2.Settlement_Type
				AND t2.domainid = @DomainID
			WHERE t2.Settlement_Type IS NULL

			SET @NewInsertCount = @@ROWCOUNT

			SELECT @AfterInsertCount = COUNT(*)
			FROM tblsettlement_type
			WHERE DomainId = @DomainID

			SET @Description = 'tblsettlement_type : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblsettlement_type
			WHERE DomainId = @DomainID

			SET @Description = 'tblsettlement_type : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		IF (@Flag = 1)
		BEGIN
			IF EXISTS (
					SELECT *
					FROM [LS_ATLAS_DB].INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'tblSettlements_rfa_import_temp'
					)
			BEGIN
				DROP TABLE tblSettlements_rfa_import_temp
			END

			SELECT	Settlement_Id_Old
			INTO	#tempSettlementIdOld
			FROM	tblSettlements
			WHERE	DomainId = @DomainID

			SELECT t1.*
			INTO tblSettlements_rfa_import_temp
			FROM [RFA_Atlas].dbo.tblSettlements t1
			JOIN tblcase_rfa_import_temp t2 ON t1.Case_Id = t2.case_id
			LEFT JOIN #tempSettlementIdOld ON t1.Settlement_Id = #tempSettlementIdOld.Settlement_Id_Old
			WHERE t1.Settlement_Id IS NULL

			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblSettlements
			WHERE DomainId = @DomainID

			INSERT INTO tblSettlements (
				Settlement_Amount
				,Settlement_Int
				,Settlement_Af
				,Settlement_Ff
				,Settlement_Total
				,Settlement_Date
				,Treatment_Id
				,Case_Id
				,[User_Id]
				,SettledWith
				,Settlement_Notes
				,Settlement_Rfund_PR
				,Settlement_Rfund_Int
				,Settlement_Rfund_Total
				,Settlement_Rfund_date
				,Settlement_Rfund_Batch
				,Settlement_Rfund_UserId
				,Settlement_Batch
				,Settlement_SubBatch
				,Settled_With_Name
				,Settled_With_Phone
				,Settled_With_Fax
				,Settled_Type
				,Settled_by
				,Settled_Percent
				,DomainId
				,Settlement_Id_Old
				)
			SELECT Settlement_Amount
				,Settlement_Int
				,Settlement_Af
				,Settlement_Ff
				,Settlement_Total
				,Settlement_Date
				,t2.Treatment_Id
				,t2.AtlasCaseID
				,'Admin'
				,SettledWith
				,Settlement_Notes
				,Settlement_Rfund_PR
				,Settlement_Rfund_Int
				,Settlement_Rfund_Total
				,Settlement_Rfund_date
				,Settlement_Rfund_Batch
				,Settlement_Rfund_UserId
				,Settlement_Batch
				,Settlement_SubBatch
				,Settled_With_Name
				,Settled_With_Phone
				,Settled_With_Fax
				,st.SettlementType_Id
				,Settled_by
				,Settled_Percent
				,@DomainID
				,t1.Settlement_Id
			FROM tblSettlements_rfa_import_temp t1
			JOIN XN_TEMP_GBB_ALL_RFA_JL t2 ON t1.Treatment_Id = t2.RFA_Treatment_ID
				AND t1.Case_Id = t2.CaseId AND t2.Transferd_Status = 'Partially'
			LEFT JOIN tblsettlement_type_rfa_import_temp t ON t1.Settled_Type = t.SettlementType_Id
			LEFT JOIN tblsettlement_type st (NOLOCK) ON  st.Settlement_Type = t.Settlement_Type AND st.DomainId = @DomainID

			SET @NewInsertCount = @@ROWCOUNT

			SELECT @AfterInsertCount = COUNT(*)
			FROM tblSettlements
			WHERE DomainId = @DomainID

			SET @Description = 'tblSettlements : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(5)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblSettlements
			WHERE DomainId = @DomainID

			SET @Description = 'tblSettlements : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		IF (@Flag = 1)
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblNotes
			WHERE DomainId = @DomainID

			--SELECT DISTINCT CaseId,AtlasCaseID 
			--INTO #tempCase 
			--FROM XN_TEMP_GBB_ALL_RFA_JL   
			--where isnull(DownloadStatus,0)=0
			--AND XN_TEMP_GBB_ALL_RFA_JL.Transferd_Status = 'Partially'

			SELECT Notes_Id_Old
			INTO	#tempNotesIdOld
			FROM	dbo.tblNotes (NOLOCK)
			WHERE   DomainId = @DomainID

			SELECT	rn.*,t.AtlasCaseID
			INTO	#temp
			FROM	tblNotes n
			JOIN	#tempCases t ON n.Case_Id = t.AtlasCaseID 
			JOIN	[RFA_Atlas].dbo.tblNotes rn ON t.CaseId = rn.Case_Id AND n.Notes_Desc = rn.Notes_Desc
			LEFT	JOIN #tempNotesIdOld ON n.Notes_ID = #tempNotesIdOld.Notes_Id_Old
			WHERE   n.Notes_ID IS NULL


			INSERT INTO dbo.tblNotes (
				Notes_Desc
				,Notes_Type
				,Notes_Priority
				,Case_Id
				,Notes_Date
				,User_Id
				,DomainId
				,Notes_Id_Old
				)
			SELECT Notes_Desc
				,Notes_Type
				,Notes_Priority
				,AtlasCaseID
				,Notes_Date
				,'system'
				,@DomainID
				,Notes_ID
			FROM #temp --t1
			--JOIN #tempCases tc ON tc.CaseId = t1.Case_Id
			--WHERE t1. Notes_ID NOT IN (SELECT Notes_ID FROM #temp)
			--ORDER BY Notes_Date DESC

			SET @NewInsertCount = @@ROWCOUNT

			SELECT @AfterInsertCount = COUNT(*)
			FROM tblNotes
			WHERE DomainId = @DomainID

			SET @Description = 'tblNotes : Before Insert - ' + CAST(@BeforeInsertCount AS VARCHAR(10)) + ',New Rows Inserted - ' + CAST(@NewInsertCount AS VARCHAR(5)) + ',Total Count After Insert - ' + CAST(@AfterInsertCount AS VARCHAR(10))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END
		ELSE
		BEGIN
			SELECT @BeforeInsertCount = COUNT(*)
			FROM tblNotes
			WHERE DomainId = @DomainID

			SET @Description = 'tblNotes : No Rows Inserted Total Row Count is - ' + CAST(@BeforeInsertCount AS VARCHAR(5))

			INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
			VALUES (@Description)
		END

		UPDATE	t
		SET		t.Ins_Claim_Number = t2.Ins_Claim_Number,
				t.IndexOrAAA_Number = t2.IndexOrAAA_Number,
				t.DenialReasons_Type = t2.DenialReasons_Type,
				t.Date_AAA_Arb_Filed = t2.Date_AAA_Arb_Filed,
				t.Court_Id = tc.Court_Id
		FROM	tblCase t 
		JOIN	#tempCases t1 ON t.Case_Id = t1.AtlasCaseID 
		JOIN	tblcase_rfa_import_temp t2 ON t1.CaseId = t2.Case_Id
		LEFT	JOIN tblCourt_rfa_import_temp tcr ON tcr.Court_Id = t2.Court_Id
		LEFT	JOIN tblCourt tc ON tc.Court_Name = tcr.Court_Name AND tc.DomainId = @DomainID

		UPDATE  t
		SET		t.SERVICE_TYPE = t2.SERVICE_TYPE,
				t.DenialReason_ID = td.DenialReasons_Id
		FROM	tblTreatment t
		JOIN	#tempCases t1 ON t.Case_Id = t1.AtlasCaseID 
		JOIN	XN_TEMP_GBB_ALL_RFA_JL x ON x.Treatment_Id = t.Treatment_Id AND x.Transferd_Status = 'Partially'
		JOIN	tblTreatment_rfa_import_temp t2 ON x.RFA_Treatment_ID = t2.Treatment_Id
		LEFT	JOIN tblDenialReasons_rfa_import_temp t3 ON t3.DenialReasons_Id = t2.DenialReason_ID
		LEFT	JOIN tblDenialReasons td (NOLOCK) ON td.DenialReasons_Type = t3.DenialReasons_Type AND td.DomainId = @DomainID

		UPDATE	XN_TEMP_GBB_ALL_RFA_JL SET Transferd_Status = 'Transferred' WHERE Transferd_Status = 'Partially'

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION

		DECLARE @ErrorMessage VARCHAR(max)

		SET @ErrorMessage = ERROR_MESSAGE()
		SET @Description = 'Exception : ' + @ErrorMessage

		INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
		VALUES (@Description)

		RAISERROR (
				@ErrorMessage
				,16
				,1
				)
	END CATCH
END
