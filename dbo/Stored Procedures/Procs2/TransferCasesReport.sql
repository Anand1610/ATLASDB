CREATE PROCEDURE [dbo].[TransferCasesReport] -- [TransferCasesReport] 'CO000000000000000438', 'Gyb' ,'BT'  
(  
	 @LawFirmID VARCHAR(100) = null,  
	 @Gbb_Type VARCHAR(10) = null,  
	 @DomianId nvarchar(50) = ''  
)  
AS  
BEGIN  
	DECLARE @Today DATETIME = GETDATE(),
			@PreviousTimeStamp DATETIME

	SELECT	@PreviousTimeStamp = ISNULL(MAX(LastProcessTimeStamp), CAST(CONVERT(NVARCHAR(10), @Today -1, 101) AS DATETIME))  
	FROM	[dbo].[CaseTransferNotificationTimeStamp] 
	WHERE	DataElement = 'CaseTransferNotification'

	select C.CASE_ID  
	, CaseTypeName  
	, P.Provider_Name AS Provider  
	, InsuranceCompany_Name  
	, Ins_Claim_Number   
	, InjuredParty_FirstName AS PATIENT_FIRST_NAME  
	, InjuredParty_LastName AS PATIENT_LAST_NAME  
	, STATUS  
	, INITIAL_STATUS  
	, Date_Opened  
	, Bill_Number  
	, T.DateOfService_Start  
	, T.DateOfService_End  
	, T.Date_BillSent  
	, DateOfTransferred  
	, GB_CASE_ID  
	, T.Claim_Amount,T.Paid_Amount, T.Claim_Amount - T.Paid_Amount AS Balance  
	, (select top 1 notes_desc from tblNotes where Case_Id=c.Case_Id and Notes_Type='Provider') as notes_desc  
	, c.GBB_Type AS AppSource
	, c.GB_LawFirm_ID
	from TBLCASE C  
	LEFT OUTER JOIN tbltreatment T on T.Case_Id= C.Case_Id  
	LEFT OUTER JOIN TblProvider P  on C.provider_id= P.Provider_ID   
	LEFT OUTER JOIN tblInsuranceCompany I  on I.InsuranceCompany_ID= c.InsuranceCompany_ID   
	INNER JOIN XN_TEMP_GBB_ALL ON BillNumber= BILL_NUMBER   
	where GB_CASE_ID is not null 
	AND	Date_Created > @PreviousTimeStamp AND Date_Created <= @Today
	AND	(
			(
				@LawFirmID IS NULL 
				AND EXISTS 
				(
					SELECT 1 FROM DomainAccounts d
					WHERE	LawFirmId = GB_LawFirm_ID
				)
			)
			OR 
			(c.GB_LawFirm_ID = @LawFirmID)
		)
	AND (@Gbb_Type IS NULL OR C.gbb_type = @Gbb_Type)  
	AND (@DomianId='' OR C.DomainId = @DomianId)  
	AND c.CASE_ID NOT LIKE 'AF%' AND c.CASE_ID NOT LIKE 'JL%'  
	AND (C.DomainId <> '' )  
	AND C.opened_by = 'System'  
	ORDER BY InsuranceCompany_Name  

	-------Case Wise Report-----------------------------------------  
  
	SELECT DISTINCT 
	C.CASE_ID  
	, Provider_Name AS Provider  
	, InsuranceCompany_Name  
	, Ins_Claim_Number  
	, InjuredParty_FirstName  
	, InjuredParty_LastName  
	, STATUS   
	, INITIAL_STATUS  
	, Date_Opened,accident_date,CONVERT(DATETIME,C.DateOfService_Start) AS DOS_START  
	, CONVERT(DATETIME,C.DateOfService_End) AS DOS_END  
	, dbo.fncGetBillNumber(C.case_id) as bill_number  
	, dbo.fncGetDenialReasons(C.case_id) as DenialReasons  
	, GB_CASE_ID  
	, C.Claim_Amount  
	, C.Paid_Amount  
	, (convert(decimal(38,2),c.Claim_Amount)-convert(decimal(38,2),c.Paid_Amount))[Claim Balance]  
	, c.Fee_Schedule-c.Paid_Amount[Fee Schedule Balance]  
	, (select top 1 notes_desc from tblNotes where Case_Id=c.Case_Id and Notes_Type='Provider') as notes_desc
	, c.GBB_Type AS AppSource
	, c.GB_LawFirm_ID
	from TBLCASE C  
	LEFT OUTER JOIN TblProvider P  on C.provider_id= P.Provider_ID   
	LEFT OUTER JOIN tblInsuranceCompany I  on I.InsuranceCompany_ID= c.InsuranceCompany_ID   
	where GB_CASE_ID is not null and  c.Case_Id in (SELECT case_ID from tblTreatment where Date_Created > @PreviousTimeStamp AND Date_Created <= @Today) 
	AND	(
			(
				@LawFirmID IS NULL 
				AND EXISTS 
				(
					SELECT 1 FROM DomainAccounts d
					WHERE	d.LawFirmId = c.GB_LawFirm_ID
				)
			)
			OR 
			(c.GB_LawFirm_ID = @LawFirmID)
		)

	AND c.CASE_ID NOT LIKE 'AF%' AND  c.CASE_ID NOT LIKE 'JL%'  
	AND (@Gbb_Type IS NULL OR C.gbb_type = @Gbb_Type)  
	AND (@DomianId = '' OR C.DomainId = @DomianId)  
	AND C.opened_by = 'System'  
	ORDER BY Provider_Name,InsuranceCompany_Name  

	INSERT	[dbo].[CaseTransferNotificationTimeStamp] ([DataElement], [LastProcessTimeStamp])
	VALUES	('CaseTransferNotification', @Today)

END 

