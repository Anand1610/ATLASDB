CREATE PROCEDURE [dbo].[GET_BILL_REPORT]
	(
	@ProviderId VARCHAR(1000)
	,@DateOfServiceStart DATE
	,@DateOfServiceEnd DATE
	,@DateOpenedStart DATE
	,@DateOpenedEnd DATE
	,@DomainId VARCHAR(10)
	)
AS
BEGIN
	SELECT DISTINCT Provider_Name
		,tc.Case_Id AS Case_Id
		,tt.Treatment_Id
		,(LTRIM(tc.InjuredParty_LastName) + ', ' + LTRIM(tc.InjuredParty_FirstName)) AS InjuredParty_Name
		,ISNULL(tp.Provider_GroupName, '') AS Provider_GroupName
		,ISNULL(tic.InsuranceCompany_Name, '') AS InsuranceCompany_Name
		,(
			CASE 
				WHEN Accident_Date IS NULL
					OR Accident_Date = ''
					THEN ''
				ELSE convert(VARCHAR(10), Accident_Date, 101)
				END
			) AS Accident_Date
		,Convert(VARCHAR(10), tc.DateOfService_Start, 101) AS DateOfService_Start
		,Convert(VARCHAR(10), tc.DateOfService_End, 101) AS DateOfService_End
		,tc.STATUS
		,tc.Ins_Claim_Number
		,tc.Policy_Number
		,(
			CASE 
				WHEN tt.Date_BillSent IS NULL
					OR tt.Date_BillSent = ''
					THEN ''
				ELSE convert(VARCHAR(10), tt.Date_BillSent, 101)
				END
			) AS Date_BillSent
		,convert(DECIMAL(38, 2), (convert(MONEY, tt.Claim_Amount))) AS Claim_Amount
		,convert(DECIMAL(38, 2), (convert(MONEY, ISNULL(tt.Paid_Amount, 0)))) AS Paid_Amount
		,convert(DECIMAL(38, 2), (convert(MONEY, tt.Claim_Amount - ISNULL(tt.Paid_Amount, 0) - ISNULL(tt.WriteOff, 0)))) AS Claim_Balance
		,convert(DECIMAL(38, 2), (convert(MONEY, ISNULL(tt.Fee_Schedule, 0)))) AS FS_Amount
		,convert(DECIMAL(38, 2), (convert(MONEY, ISNULL(tt.Fee_Schedule, 0) - ISNULL(tt.Paid_Amount, 0) - ISNULL(tt.WriteOff, 0)))) AS FS_Balance
		,ISNULL(Bill_Number, '') AS Bill_Number
		,convert(VARCHAR, tc.Date_Opened, 101) AS Date_Opened
		,tc.IndexOrAAA_Number
		,tc.Initial_Status
		,(
			SELECT TOP 1 ISNULL(a.Case_Id, '')
			FROM tblCase a(NOLOCK)
			WHERE a.Provider_Id = tc.Provider_Id
				AND a.InjuredParty_LastName = tc.InjuredParty_LastName
				AND a.InjuredParty_FirstName = tc.InjuredParty_FirstName
				AND a.Accident_Date = tc.Accident_Date
				AND a.Case_Id <> tc.case_id
			) AS Similar_To_Case_ID
		,PF.Name [PortfolioName]
		,ISNULL(tc.case_code, '') AS Reference_CaseId
		,tc.DenialReasons_Type AS DenialReasons
		,DateDiff(dd, ISNULL(tc.Date_Status_Changed, tc.Date_Opened), GETDATE()) AS Status_Age
		,DateDiff(dd, tc.Date_Opened, GETDATE()) AS Case_Age
		,ISNULL(txn.ChequeNo, '') AS [Check_Number]
		,ISNULL(Service_Type, '') AS Service_Type
	FROM tblCase tc(NOLOCK)
	INNER JOIN tbltreatment tt(NOLOCK) ON tt.Case_Id = tc.Case_Id
	INNER JOIN tblProvider tp(NOLOCK) ON tp.Provider_Id = tc.Provider_Id
	LEFT JOIN tbl_portfolio PF(NOLOCK) ON tc.PortfolioId = PF.id
	LEFT JOIN tblinsurancecompany tic(NOLOCK) ON tc.insurancecompany_id = tic.insurancecompany_id
	LEFT JOIN tblTransactions txn(NOLOCK) ON txn.Case_Id = tc.Case_Id
	WHERE tc.Provider_Id IN (
			SELECT ITEMS
			FROM dbo.STRING_SPLIT(@ProviderId, ',')
			)
		AND (
			@DateOfServiceStart = ''
			OR CONVERT(DATE, tc.DateOfService_Start) >= @DateOfServiceStart
			)
		AND (
			@DateOfServiceEnd = ''
			OR CONVERT(DATE, tc.DateOfService_Start) <= @DateOfServiceEnd
			)
		AND (
			@DateOpenedStart = ''
			OR CONVERT(DATE, tc.Date_Opened) >= @DateOpenedStart
			)
		AND (
			@DateOpenedEnd = ''
			OR CONVERT(DATE, tc.Date_Opened) <= @DateOpenedEnd
			)
		AND tc.DomainId = @DomainId
	ORDER BY tc.Case_Id DESC
END