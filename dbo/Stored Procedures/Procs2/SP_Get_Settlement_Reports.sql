﻿/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[SP_Get_Settlement_Reports] ---[SP_Get_Settlement_Reports] 'AF', '0','0','2019-01-03','2019-11-26'
	(
	@DomainId VARCHAR(25)
	,@InsuranceCompany_Id VARCHAR(20)
	,@Provider_Id VARCHAR(20)
	,@ZeroSettlementdt1 DATE
	,@ZeroSettlementdt2 DATE
	)
AS
BEGIN
	SELECT DISTINCT tblcase.Case_Id
		,IndexOrAAA_Number
		,ISNULL(tblcase.InjuredParty_FirstName, N'') + N'  ' + ISNULL(tblcase.InjuredParty_LastName, N'') AS InjuredParty_Name
		,ISNULL(dbo.tblProvider.Provider_Name, '') AS Provider_Name
		,STATUS AS [Status]
		,ISNULL(dbo.tblInsuranceCompany.InsuranceCompany_Name, '') AS InsuranceCompany_Name
		,ISNULL(tblcase.Claim_Amount, 0) AS Claim_Amount
		,ISNULL((CONVERT(MONEY, ISNULL(tblcase.Claim_Amount, 0)) - CONVERT(FLOAT, ISNULL(tblcase.Paid_Amount, 0))), '00.00') AS Balance_amount
		,ISNULL(dbo.tblSettlements.Settlement_Amount, '00.00') AS Settlement_Amount
		,CAST(dbo.tblSettlements.Settlement_Date AS DATE) AS Settlement_date
	FROM tblCase
	INNER JOIN dbo.tblProvider WITH (NOLOCK) ON tblcase.Provider_Id = dbo.tblProvider.Provider_Id
	INNER JOIN dbo.tblInsuranceCompany WITH (NOLOCK) ON tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id
	LEFT JOIN dbo.tblStatus WITH (NOLOCK) ON tblcase.STATUS = dbo.tblStatus.Status_Abr
		AND tblcase.DomainId = tblStatus.DomainId
	LEFT JOIN dbo.tblSettlements WITH (NOLOCK) ON tblcase.Case_Id = dbo.tblSettlements.Case_Id
	WHERE (
			@InsuranceCompany_Id = ''
			OR tblcase.insurancecompany_id = @InsuranceCompany_Id
			)
		AND (
			@Provider_Id = ''
			OR tblcase.provider_id = @Provider_Id
			)
		AND (
			@ZeroSettlementdt1 = ''
			OR CAST(settlement_date AS DATE) >= @ZeroSettlementdt1
			)
		AND (
			@ZeroSettlementdt2 = ''
			OR CAST(settlement_date AS DATE) <= @ZeroSettlementdt2
			)
		AND settlement_amount = 0
		AND tblcase.DomainId = @DomainId
	ORDER BY provider_name
END
