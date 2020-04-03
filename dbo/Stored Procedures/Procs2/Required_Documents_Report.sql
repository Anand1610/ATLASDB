-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- DROP PROCEDURE RequiredDocument_Report
CREATE PROCEDURE [dbo].[Required_Documents_Report]   -- Required_Documents_Report 'localhost',0
	@DomainID VARCHAR(50)
AS
BEGIN
	--SELECT * FROM Required_Documents
	SET NOCOUNT ON;
	DECLARE @s_l_DocumentType VARCHAR(4000)
		SELECT distinct
		Doc.ID,
		DocumentType,
		CONVERT(VARCHAR(10),created_date,101) AS created_date,
		cas.Case_Id,
		cas.Case_AutoId,
		cas.Case_Code AS Case_Code,
		cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName as InjuredParty_Name,  
		Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') as Provider_Name,  
		ins.InsuranceCompany_Name,  
		convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount) - convert(float,cas.Paid_Amount)))) as Claim_Amount,
		convert(decimal(38,2),(convert(money,convert(float,cas.Fee_Schedule) - convert(float,cas.Paid_Amount)))) as FS_Balance,
		cas.Status,  
		cas.Initial_Status,
		cas.Accident_Date,		
		cas.Ins_Claim_Number, 
		pro.Provider_GroupName,
		CONVERT(varchar(10), min(tre.DateOfService_Start), 101) AS DateOfService_Start, 
		CONVERT(varchar(12), min(tre.DateOfService_End), 1) AS DateOfService_End
	FROM dbo.tblCase cas
		INNER JOIN dbo.tblprovider pro on cas.provider_id=pro.provider_id 
		INNER JOIN dbo.tblinsurancecompany ins on cas.insurancecompany_id=ins.insurancecompany_id
		INNER JOIN  dbo.Required_Documents doc on cas.case_id = doc.Case_ID
		LEFT OUTER JOIN dbo.tblTreatment tre on tre.Case_Id= cas.Case_Id
	WHERE
		cas.DomainId = @DomainID
		AND ReminderDate is null
		AND ISNULL(cas.IsDeleted,0) = 0
	Group by 	
		doc.ID,
		DocumentType,
		created_date,
		cas.Case_Id,
		cas.Case_AutoId,
		cas.Case_Code,
		cas.InjuredParty_FirstName,
		cas.InjuredParty_LastName,
		pro.Provider_Name,
		ins.InsuranceCompany_Name,
		cas.Claim_Amount,
		cas.Fee_Schedule,
		cas.Status,
		cas.Accident_Date,		
		cas.Initial_Status,
		pro.Provider_GroupName,
		cas.Paid_Amount,
		cas.Ins_Claim_Number,
		Cas.Date_Opened
	ORDER BY cas.case_id, DocumentType,created_date	desc
END