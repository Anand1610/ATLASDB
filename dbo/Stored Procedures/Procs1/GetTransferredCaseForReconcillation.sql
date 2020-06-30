CREATE PROCEDURE [dbo].[GetTransferredCaseForReconcillation] -- GetTransferredCaseForReconcillation @GYBApplicationName = 'Gyb', @StartDate = '2019-08-01', @EndDate = '2019-08-22'
	@GYBApplicationName VARCHAR(100),
	@StartDate DATE  = null OUTPUT,
	@EndDate DATE  = null OUTPUT
AS
BEGIN
 --   SET @StartDate = GETDATE() -150
	--SET @EndDate = GETDATE()

	;WITH parms (CurrentDate) AS 
	(
	    SELECT DATEADD(dd, 2, CURRENT_TIMESTAMP)
	)

	SELECT	@StartDate   = DATEADD(dd,  0, DATEADD(ww, DATEDIFF(ww, 0, DATEADD(dd, -1, CurrentDate)) - 1, 0)),
			@EndDate   = DATEADD(dd,  6, DATEADD(ww, DATEDIFF(ww, 0, DATEADD(dd, -1, CurrentDate)) - 1, 0))
	FROM	parms
     
	SELECT	LawFirmID = xn.AssignedLawFirmID,
			da.LawFirmName,
			AccountID = xn.CompanyId,
			AccountName = xn.CompanyName,
			BillCount = COUNT(tre.BILL_NUMBER), 
			--AtlasCaseID = cas.Case_ID,
			TransferAmount = SUM(tre.Claim_Amount)
	FROM	tblcase cas (NOLOCK) 
	JOIN	tblTreatment tre (NOLOCK) on cas.case_id = tre.case_id and cas.domainid = tre.domainid
	JOIN	XN_TEMP_GBB_ALL xn (NOLOCK) on tre.BILL_NUMBER = xn.BillNumber and tre.DomainId = xn.DomainId and tre.case_id =xn.Transferd_Status 
	JOIN	DomainAccounts da (NOLOCK) ON da.LawFirmID = xn.AssignedLawFirmID
	WHERE	xn.GBB_Type = @GYBApplicationName
	AND		CAST(xn.DateOfTransferred as DATE) BETWEEN @StartDate AND @EndDate
	GROUP	BY xn.AssignedLawFirmID,
			da.LawFirmName,
			xn.CompanyId,
			xn.CompanyName
	
	SELECT	LawFirmID = xn.AssignedLawFirmID,
			da.LawFirmName,
			AccountID = xn.CompanyId,
			AccountName = xn.CompanyName,
			xn.CaseID,
			xn.CaseNo,
			PatientName = PatientLastName + ', ' + PatientFirstName,
			BillNumber = tre.BILL_NUMBER, 
			AtlasCaseID = cas.Case_ID,
			TransferAmount = tre.Claim_Amount,
			xn.DateOfTransferred
	FROM	tblcase cas (NOLOCK) 
	JOIN	tblTreatment tre (NOLOCK) on cas.case_id = tre.case_id and cas.domainid = tre.domainid
	JOIN	XN_TEMP_GBB_ALL xn (NOLOCK) on tre.BILL_NUMBER = xn.BillNumber and tre.DomainId = xn.DomainId and tre.case_id =xn.Transferd_Status
	JOIN	DomainAccounts da (NOLOCK) ON da.LawFirmID = xn.AssignedLawFirmID
	WHERE	xn.GBB_Type = @GYBApplicationName
	AND		CAST(xn.DateOfTransferred as DATE) BETWEEN @StartDate AND @EndDate
END