CREATE PROCEDURE GetBillsPendingTransferProcess --@GbbType = 'GYB'
	@GbbType VARCHAR(10) = NULL
AS
BEGIN
	-- Cases Could not be created due to missing mappings
	SELECT	CaseId,
			CaseNo,
			PatientFirstName,
			PatientLastName,
			InsuranceName,
			PatientPhone,
			PolicyNumber,
			ClaimNumber,
			BillStatusName,
			AttorneyName,
			AttorneyLastName,
			PolicyHolder,
			BillNumber,
			FltBillAmount,
			FltPaid,
			FltBalance,
			FirstVisitDate,
			LastVisitDate,
			CaseTypeName,
			[Location],
			CompanyId,
			CompanyName,
			ProviderName,
			DoctorName,
			Specialty,
			DateofAccident,
			AssignedLawFirmId,
			TransferAmount,
			DateOfTransferred,
			BillDate,
			provider_id,
			insurancecompanyid,
			DenialReason1,
			DenialReason2,
			DenialReason3,
			DomainId,
			AppSource = GBB_Type
	FROM	XN_TEMP_GBB_ALL a
	WHERE	(@GbbType IS NULL OR GBB_Type = @GbbType)
	AND Transferd_Status = ''
END

