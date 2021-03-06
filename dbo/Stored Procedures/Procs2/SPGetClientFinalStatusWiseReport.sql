﻿/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[SPGetClientFinalStatusWiseReport]  -- SPGetClientFinalStatusWiseReport 'all',4516
(  
 @Status VARCHAR(200),  
 @ProviderId INT  
)  
AS  
BEGIN  
   
 IF(LOWER(@Status) = 'all')  
  BEGIN  
	SELECT		tblcase.Case_Id,
				ISNULL((CONVERT(money, ISNULL(tblcase.Claim_Amount, 0)) - CONVERT(float, ISNULL(tblcase.Paid_Amount, 0))),'00.00') AS Balance_amount,
				ISNULL(dbo.tblSettlements.Settlement_Amount,'00.00') as Settlement_Amount,
				ISNULL(tblcase.InjuredParty_FirstName, N'') + N'  ' + ISNULL(tblcase.InjuredParty_LastName, N'')  AS InjuredParty_Name,
				ISNULL(dbo.tblProvider.Provider_Name,'') AS Provider_Name,
				ISNULL(dbo.tblInsuranceCompany.InsuranceCompany_Name,'') AS InsuranceCompany_Name,
				Date_Opened,
				Status AS [Status],
				Initial_Status,
				ISNULL(dbo.tblStatus.Final_Status,'') AS [Final_Status],
				IndexOrAAA_Number
	from		tblCase
	INNER JOIN dbo.tblProvider WITH (NOLOCK) ON tblcase.Provider_Id = dbo.tblProvider.Provider_Id
	INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id
	LEFT OUTER JOIN  dbo.tblStatus WITH (NOLOCK) ON tblcase.Status = dbo.tblStatus.Status_Abr  and tblcase.DomainId=tblStatus.DomainId
	LEFT OUTER JOIN  dbo.tblSettlements WITH (NOLOCK) ON tblcase.Case_Id = dbo.tblSettlements.Case_Id 
	where		tblcase.provider_id = @ProviderId
	and			status <> 'IN ARB OR LIT'
	order by	final_status, insurancecompany_name asc
  END  
  
  ELSE  
   BEGIN  
	SELECT		tblcase.Case_Id,
				ISNULL((CONVERT(money, ISNULL(tblcase.Claim_Amount, 0)) - CONVERT(float, ISNULL(tblcase.Paid_Amount, 0))),'00.00') AS Balance_amount,
				ISNULL(dbo.tblSettlements.Settlement_Amount,'00.00') as Settlement_Amount,
				ISNULL(tblcase.InjuredParty_FirstName, N'') + N'  ' + ISNULL(tblcase.InjuredParty_LastName, N'')  AS InjuredParty_Name,
				ISNULL(dbo.tblProvider.Provider_Name,'') AS Provider_Name,
				ISNULL(dbo.tblInsuranceCompany.InsuranceCompany_Name,'') AS InsuranceCompany_Name,
				Date_Opened,
				Status AS [Status],
				Initial_Status,
				ISNULL(dbo.tblStatus.Final_Status,'') AS [Final_Status],
				IndexOrAAA_Number
	from		tblCase
	INNER JOIN dbo.tblProvider WITH (NOLOCK) ON tblcase.Provider_Id = dbo.tblProvider.Provider_Id
	INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id
	LEFT OUTER JOIN  dbo.tblStatus WITH (NOLOCK) ON tblcase.Status = dbo.tblStatus.Status_Abr  and tblcase.DomainId=tblStatus.DomainId
	LEFT OUTER JOIN  dbo.tblSettlements WITH (NOLOCK) ON tblcase.Case_Id = dbo.tblSettlements.Case_Id 
	where		tblcase.provider_id = @ProviderId
	and			final_status = @Status
	and			status <> 'IN ARB OR LIT'
	order by	insurancecompany_name
	asc
   END  
  
END