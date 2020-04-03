-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Required_Documents_Report_Details]
	@DomainID varchar(50) = '',
	@s_a_DocumentType varchar(50),
	@s_a_Range varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ReminderTable TABLE
	(
		ID INT,
		DocumentType VARCHAR(100),
		ReminderDate VARCHAR(10),
		CASE_ID VARCHAR(50),
		ReminderDays int,
		PivotRange VARCHAR(50),
		Message Varchar(50)
	)

	INSERT INTO  @ReminderTable
	select ID, DocumentType,CONVERT(VARCHAR,ReminderDate,101) AS ReminderDate, CASE_ID, DATEDIFF(DAY, ReminderDate,GETDATE()) AS ReminderDays,'',Message
    from Required_Documents
	WHERE  DomainID = @DomainID 
		AND (@s_a_DocumentType = '' OR DocumentType = @s_a_DocumentType)
		AND ISNULL(isCompleted,0) = 0


	UPDATE @ReminderTable
	SET PivotRange = '0 - 15'
	WHERE ReminderDays <= 15

	UPDATE @ReminderTable
	SET PivotRange = '16 - 30'
	WHERE ReminderDays > 15 and ReminderDays <= 30

	UPDATE @ReminderTable
	SET PivotRange = '31 - 45'
	WHERE ReminderDays > 30 and ReminderDays <= 45

	UPDATE @ReminderTable
	SET PivotRange = '> 45 '
	WHERE ReminderDays > 45


	--SELECT * FROM @ReminderTable
	--WHERE PivotRange = @s_a_Range 


	SELECT distinct
		Doc.ID,
		doc.DocumentType,
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
		INNER JOIN  @ReminderTable rt on doc.ID = rt.ID
		LEFT OUTER JOIN dbo.tblTreatment tre on tre.Case_Id= cas.Case_Id
	WHERE
		cas.DomainId = @DomainID
		AND PivotRange = @s_a_Range 
	Group by 	
		doc.ID,
		doc.DocumentType,
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
	ORDER BY case_id, DocumentType,created_date	desc

END
