CREATE PROCEDURE [dbo].[UpdatedCasesSyncedToGYB]
	@TransferredCaseData [dbo].[TransferredCaseDataType] READONLY
AS
BEGIN
	BEGIN TRANSACTION

	BEGIN TRY

	UPDATE	b 
	SET		b.IsDataSyncedtoGYB = 1,
			b.DateSyncedtoGYB = GETDATE()
	FROM	[dbo].[XN_TEMP_GBB_ALL] b
	JOIN	@TransferredCaseData c ON c.GYBBillNumber = b.BillNumber
	WHERE	c.GYBLawFirmID = b.AssignedLawFirmId
	AND		c.GYBAccountID = b.CompanyId

	COMMIT

	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
		ROLLBACK
		RAISERROR(@ErrorMessage, 16, 1)
	END CATCH
END
