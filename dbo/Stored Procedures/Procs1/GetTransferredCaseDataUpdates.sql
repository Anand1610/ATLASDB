CREATE PROCEDURE [dbo].[GetTransferredCaseDataUpdates]
	@GYBApplicationName NVARCHAR(100) = 'GoGYB',
	@PageNumber INT = 0,
	@PageSize INT = 2000,
	@SortColumn nvarchar(50) = 'ID',
	@TotalRows INT = 0  OUTPUT 
AS
BEGIN
    DECLARE @offset INT
    DECLARE @newsize INT
    DECLARE @sql NVARCHAR(MAX)

    IF(@PageNumber=0)
	BEGIN
		SET @offset = @PageNumber
		SET @newsize = @PageSize
	END
	ELSE 
	BEGIN
		SET @offset = @PageNumber * @PageSize
		SET @newsize = @PageSize-1
	END

    SET NOCOUNT ON
    SET @sql = '
     WITH OrderedSet AS
    (
		SELECT	ID, 
				GYBBillNumber = BillNumber, 
				BillAmount = FltBillAmount,
				TransferAmount,
				GYBAccountID = CompanyID,
				GYBLawFirmID = AssignedLawFirmID,
				GYBProviderID = Provider_ID,
				GYBInsuranceCompanyID = InsuranceCompanyID,
				TransferdDate = ISNULL(Transferd_Date, ''1900-01-01''), 
				AtlasCaseID, 
				AtlasCaseIndexNumber, 
				AtlasPrincipalAmountCollected = ISNULL(AtlasPrincipalAmountCollected, 0),
				AtlasInterestAmountCollected = ISNULL(AtlasPrincipalAmountCollected, 0),
				TransferdStatus = Transferd_Status,
				AtlasCaseStatus,
				AtlasLastTransactionDate = ISNULL(Transferd_Date, ''1900-01-01''), ROW_NUMBER() OVER (ORDER BY ' + @SortColumn + ') AS ''Index''
		FROM	XN_TEMP_GBB_ALL (NOLOCK) 
		WHERE	GBB_Type = ''' + @GYBApplicationName + '''
		--AND		AssignedLawFirmId = ''CO000000000000000445''
		AND		ISNULL(IsDataSyncedtoGYB, 0) = 0 
    )
	SELECT * FROM OrderedSet WHERE [Index] BETWEEN ' + CONVERT(NVARCHAR(12), @offset) + ' AND ' + CONVERT(NVARCHAR(12), (@offset + @newsize)) 

	EXECUTE (@sql)
	PRINT @sql
	SET @TotalRows = @@ROWCOUNT

	SELECT	@TotalRows = COUNT(1)
	FROM	XN_TEMP_GBB_ALL (NOLOCK) 
	WHERE	GBB_Type = @GYBApplicationName
	AND		ISNULL(IsDataSyncedtoGYB, 0) = 0 
	--AND		AssignedLawFirmId = 'CO000000000000000445'
END