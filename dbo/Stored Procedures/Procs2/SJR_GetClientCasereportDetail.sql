﻿/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[SJR_GetClientCasereportDetail] (
	@InitialStatus VARCHAR(255)
	,@ProviderID INT
	,@Month INT
	,@Year INT
	,@DomainID VARCHAR(20)
	)
AS
BEGIN
	SELECT	LawFirmName, 
			Client_Billing_Address, 
			Client_Billing_City, 
			Client_Billing_State,
			Client_Billing_Zip, 
			Client_Billing_Phone, 
			Client_Billing_Fax 
	FROM	tbl_Client c 
	WHERE	c.DomainId = @DomainID

	--SELECT	Case_Id,
	--		[Index],
	--		[InjuredParty_Name],
	--		Provider_Name,
	--		InsuranceCompany_Name,
	--		[Claim#],
	--		[Status],
	--		Claim_amount,
	--		fee_Schedule,
	--		Paid_Amount,
	--		DOS,
	--		Date_Opened,
	--		Balance
	--FROM	[SJR-Case_report_Extended]
	--WHERE	Initial_Status = @InitialStatus
	--AND		provider_id = @ProviderID
	--AND		YEAR(date_opened) = @Year
	--AND		MONTH(date_opened) = @Month
	--ORDER	BY date_opened ASC

	SELECT	tblcase.Case_Id,
			tblcase.IndexOrAAA_Number AS [Index],
			tblcase.InjuredParty_LastName + N', ' + dbo.tblcase.InjuredParty_FirstName AS InjuredParty_Name,
			REPLACE(dbo.tblProvider.Provider_Name, '--', '##') AS Provider_Name,
			dbo.tblInsuranceCompany.InsuranceCompany_Name,
			dbo.tblcase.Ins_Claim_Number AS Claim#,
			dbo.tblcase.Status,
			SUM(ISNULL(CONVERT(money, dbo.tblcase.Claim_Amount), 0)) AS Claim_Amount,
			ISNULL(dbo.tblcase.Fee_Schedule,0)AS Fee_Schedule,
			SUM(ISNULL(CONVERT(money, dbo.tblcase.Paid_Amount), 0)) AS Paid_Amount,
			ISNULL(CONVERT(varchar(12), dbo.tblcase.DateOfService_Start, 110) + ' - ' + CONVERT(varchar(12), dbo.tblcase.DateOfService_End, 110), N'-') AS DOS,
			tblcase.Date_Opened,
			ISNULL(CONVERT(money,dbo.tblcase.Claim_Amount), 0) - ISNULL(CONVERT(money, dbo.tblcase.Paid_Amount), 0) AS Balance
	FROM	dbo.tblcase
	LEFT	OUTER JOIN dbo.tblProvider ON dbo.tblcase.Provider_Id = dbo.tblProvider.Provider_Id
	LEFT	OUTER JOIN dbo.tblInsuranceCompany ON dbo.tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id
	WHERE	tblcase.Initial_Status = @InitialStatus
	AND		tblcase.provider_id = @ProviderID
	AND		YEAR(tblcase.Date_Opened) = @Year
	AND		MONTH(tblcase.Date_Opened) = @Month
	GROUP	BY tblcase.Case_Id,
			tblcase.IndexOrAAA_Number,
			dbo.tblcase.InjuredParty_LastName + N', ' + dbo.tblcase.InjuredParty_FirstName,
			REPLACE(dbo.tblProvider.Provider_Name, '--', '##'),
			dbo.tblInsuranceCompany.InsuranceCompany_Name,
			dbo.tblcase.Ins_Claim_Number,
			dbo.tblcase.Status,
			dbo.tblcase.Fee_Schedule,
			CONVERT(varchar(12), dbo.tblcase.DateOfService_Start, 110) + ' - ' + CONVERT(varchar(12),dbo.tblcase.DateOfService_End, 110),
			tblcase.Date_Opened,
			ISNULL(CONVERT(money, dbo.tblcase.Claim_Amount), 0) - ISNULL(CONVERT(money, dbo.tblcase.Paid_Amount), 0)
	ORDER	BY tblcase.date_opened ASC

	SELECT	SUM(ISNULL(CONVERT(money, Claim_Amount), 0)) AS [Total_Claim_Amount],
			SUM(ISNULL(CONVERT(money, Paid_Amount), 0)) AS [Total_Paid_Amount],
			COUNT(DISTINCT Case_Id) AS [Total_Count],
			SUM(ISNULL(CONVERT(money,Claim_Amount), 0) - ISNULL(CONVERT(money, Paid_Amount), 0)) AS [Total_Balance]
	FROM	dbo.tblcase 
	WHERE	Initial_Status=@InitialStatus 
	AND		provider_id=@ProviderID
	AND		YEAR(date_opened)=@Year 
	AND		MONTH(date_opened)=@Month
	--GROUP	BY	ISNULL(CONVERT(money,Claim_Amount), 0) - ISNULL(CONVERT(money,Paid_Amount), 0)

	--SELECT	SUM(CAST(ISNULL(claim_amount,0) AS MONEY)) AS [Total_Claim_Amount],
	--		SUM(ISNULL(Paid_Amount,0)) AS [Total_Paid_Amount],
	--		COUNT(DISTINCT case_id) AS [Total_Count],
	--		SUM(ISNULL(Balance,0)) AS [Total_Balance]
	--FROM	[SJR-Case_report_Extended] 
	--WHERE	Initial_Status=@InitialStatus 
	--AND		provider_id=@ProviderID
	--AND		YEAR(date_opened)=@Year 
	--AND		MONTH(date_opened)=@Month

	
END