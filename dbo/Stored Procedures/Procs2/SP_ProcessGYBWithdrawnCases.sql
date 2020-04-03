CREATE PROCEDURE SP_ProcessGYBWithdrawnCases
	@SourceApplication VARCHAR(100),
	@WithdrawnCases [dbo].[WithdrawnCaseDataType] READONLY,
	@Flag VARCHAR(50)
AS
BEGIN
	DECLARE @Counter BIGINT = 1,
			@TotalCount BIGINT = 0,
			@CaseCounter INT = 1,
			@TotalCaseCount INT = 0,
			@AtlasCaseWithdrawlID BIGINT,
			@BillNumber NVARCHAR(20),
			@CompanyID NVARCHAR(20),
			@LawFirmID NVARCHAR(20),
			@DateWithdrawnInGYB DATETIME,
			@AtlasCaseID VARCHAR(40),
			@DomainID VARCHAR(100),
			@Message VARCHAR(MAX)

	IF(@Flag = 'Process')
	BEGIN
		INSERT	dbo.GYBWithdrawnCase
		(
			GYBCaseWithdrawlID,
			BillNumber,
			CompanyID,
			LawFirmID,
			DateWithdrawnInGYB,
			DateCreated,
			IsProcessedInLawSpades,
			IsSyncedToGYB,
			SourceApplication
		)
		SELECT	g.ID,
				g.BillNumber,
				g.CompanyID,
				g.LawFirmID,
				g.DateWithdrawn,
				GETDATE(),
				0,
				0,
				@SourceApplication
		FROM	@WithdrawnCases g
		WHERE	NOT EXISTS
				(
					SELECT	1
					FROM	dbo.GYBWithdrawnCase a
					WHERE	a.GYBCaseWithdrawlID = g.ID
					AND		a.BillNumber = g.BillNumber
					AND		a.CompanyID = g.CompanyID
					AND		a.LawFirmID = g.LawFirmID
				)

	
		DECLARE @Table TABLE
		(
			ID INT IDENTITY(1, 1),
			AtlasCaseWithdrawlID BIGINT NOT NULL,
			BillNumber NVARCHAR(20) NOT NULL,
			CompanyID NVARCHAR(20) NOT NULL,
			LawFirmID NVARCHAR(20) NOT NULL,
			DateWithdrawn DATETIME NULL
		)

		INSERT	@Table
		(
			AtlasCaseWithdrawlID,
			BillNumber,
			CompanyID,
			LawFirmID,
			DateWithdrawn
		)
		SELECT	ID,
				BillNumber,
				CompanyID,
				LawFirmID,
				DateWithdrawnInGYB
		FROM	dbo.GYBWithdrawnCase
		WHERE	ISNULL(IsProcessedInLawSpades , 0) = 0

		SET @TotalCount = @@ROWCOUNT

		WHILE (@Counter <= @TotalCount)
		BEGIN
			SELECT	@AtlasCaseWithdrawlID = AtlasCaseWithdrawlID,
					@BillNumber = BillNumber,
					@CompanyID = CompanyID,
					@LawFirmID = LawFirmID,
					@DateWithdrawnInGYB = DateWithdrawn
			FROM	@Table
			WHERE	ID = @Counter

			DECLARE @Cases TABLE
			(
				ID INT IDENTITY(1,1),
				CaseID VARCHAR(40),
				DomainID VARCHAR(40)
			)

			INSERT	@Cases
			(
				CaseID,
				DomainID
			)
			SELECT	t.Case_ID,
					t.DomainId
			FROM	tblcase c
			JOIN	tblTreatment t ON t.Case_Id = t.Case_Id
			WHERE	c.GB_COMPANY_ID = @CompanyID
			AND		c.GB_LawFirm_ID = @LawFirmID
			AND		t.BILL_NUMBER = @BillNumber

			SET @TotalCaseCount = @@ROWCOUNT

			WHILE(@CaseCounter <= @TotalCaseCount)
			BEGIN
				SELECT	@AtlasCaseID = CaseID,
						@DomainId = DomainId
				FROM	@Cases
				WHERE	ID = @CaseCounter
			
				SET @Message =  'BillNumber: ' + @BillNumber + ' has been withdrawn by medical provider on: ' + CONVERT(VARCHAR(10), @DateWithdrawnInGYB, 101)

				exec LCJ_AddNotes 
					@case_id = @AtlasCaseID, 
					@notes_type = 'Activity',
					@Ndesc = @Message,
					@User_id = 'system',
					@Applytogroup = 0,
					@DomainId = @DOMAINID  

				SET @CaseCounter = @CaseCounter + 1
			END

			UPDATE	dbo.GYBWithdrawnCase
			SET		IsProcessedInLawSpades = 1,
					DateProcessedInLawSpades = GETDATE()
			WHERE	ID = @AtlasCaseWithdrawlID

			SET @Counter = @Counter + 1
		END

		SELECT	WithdrawlID = GYBCaseWithdrawlID,
				BillNumber,
				CompanyID,
				LawFirmID,
				DateWithdrawn = DateWithdrawnInGYB
		FROM	dbo.GYBWithdrawnCase
		WHERE	IsProcessedInLawSpades = 1
		AND		ISNULL(IsSyncedToGYB, 0) = 0
	END
	ELSE IF(@Flag = 'UPDATEStatus')
	BEGIN
		UPDATE	dbo.GYBWithdrawnCase
		SET		IsSyncedToGYB = 1,
				DateSyncedToGYB = GETDATE()
		FROM	dbo.GYBWithdrawnCase a
		JOIN	@WithdrawnCases b ON a.GYBCaseWithdrawlID = b.ID
											AND a.CompanyID = b.CompanyID
											AND a.LawFirmID = b.LawFirmID
	END
END
