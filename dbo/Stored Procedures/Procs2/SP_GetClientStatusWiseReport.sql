﻿/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[SP_GetClientStatusWiseReport]  -- SP_GetClientStatusWiseReport 'AAA - SETTLED - PAID - CLOSED - GB',3992
(
	@Status VARCHAR(200),
	@ProviderId INT
)
AS
BEGIN
	
	IF(LOWER(@Status) = 'all')
		BEGIN
			select	DISTINCT
					ISNULL(CONVERT (VARCHAR(10),(select MAX(Event_Date) from tblEvent E inner join tblEventType T on E.EventTypeId = T.EventTypeId inner join tblEventStatus S on E.EventStatusId = S.EventStatusId WHERE Case_id =dbo.tblcase.Case_Id and (EventStatusName like '%HEARING%' OR EventStatusName like '%Trial%')),101),'') AS Event_Date,
					(select top 1 ISNULL(Notes_Desc,'') from tblNotes where Notes_Type in ('Delay','DELAY ARB') and DomainId=dbo.tblcase.DomainId and Case_Id=dbo.tblcase.Case_Id order by Notes_Date desc)[delay_notes],
					tblcase.Case_Id,
					ISNULL(tblcase.Claim_Amount,0) AS Claim_Amount,
					ISNULL(tblcase.Paid_Amount, 0) AS Paid_Amount,
					ISNULL(CONVERT(float, dbo.tblcase.Claim_Amount) - CONVERT(float, dbo.tblcase.Paid_Amount), 0) AS Balance_Amount,
					ISNULL(dbo.tblcase.InjuredParty_FirstName, N'') + N'  ' + ISNULL(dbo.tblcase.InjuredParty_LastName, N'') AS InjuredParty_Name,
					ISNULL(dbo.tblProvider.Provider_Name,'') AS Provider_Name,
					ISNULL(dbo.tblInsuranceCompany.InsuranceCompany_Name,'') AS InsuranceCompany_Name,
					Date_Opened,
					CONVERT(VARCHAR(10),dbo.tblcase.DateOfService_Start,101) + ' - ' + CONVERT(VARCHAR(10),dbo.tblcase.DateOfService_End,101) AS DOS_Range,
					Status AS [Status],
					Initial_Status,
					ISNULL(dbo.tblStatus.Final_Status,'') AS Final_Status,
					IndexOrAAA_Number
	from			tblCase
	INNER JOIN dbo.tblProvider WITH (NOLOCK) ON tblcase.Provider_Id = dbo.tblProvider.Provider_Id
	INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id
	LEFT OUTER JOIN  dbo.tblStatus WITH (NOLOCK) ON tblcase.Status = dbo.tblStatus.Status_Abr  and tblcase.DomainId=tblStatus.DomainId
			where			tblcase.provider_id = @ProviderId
			and				status <> 'IN ARB OR LIT'
			order by		status,
							insurancecompany_name
			asc
		END

		ELSE
			BEGIN
				select	DISTINCT
					ISNULL(CONVERT (VARCHAR(10),(select MAX(Event_Date) from tblEvent E inner join tblEventType T on E.EventTypeId = T.EventTypeId inner join tblEventStatus S on E.EventStatusId = S.EventStatusId WHERE Case_id =dbo.tblcase.Case_Id and (EventStatusName like '%HEARING%' OR EventStatusName like '%Trial%')),101),'') AS Event_Date,
					(select top 1 ISNULL(Notes_Desc,'') from tblNotes where Notes_Type in ('Delay','DELAY ARB') and DomainId=dbo.tblcase.DomainId and Case_Id=dbo.tblcase.Case_Id order by Notes_Date desc)[delay_notes],
					tblcase.Case_Id,
					ISNULL(tblcase.Claim_Amount,0) AS Claim_Amount,
					ISNULL(tblcase.Paid_Amount, 0) AS Paid_Amount,
					ISNULL(CONVERT(float, dbo.tblcase.Claim_Amount) - CONVERT(float, dbo.tblcase.Paid_Amount), 0) AS Balance_Amount,
					ISNULL(dbo.tblcase.InjuredParty_FirstName, N'') + N'  ' + ISNULL(dbo.tblcase.InjuredParty_LastName, N'') AS InjuredParty_Name,
					ISNULL(dbo.tblProvider.Provider_Name,'') AS Provider_Name,
					ISNULL(dbo.tblInsuranceCompany.InsuranceCompany_Name,'') AS InsuranceCompany_Name,
					Date_Opened,
					CONVERT(VARCHAR(10),dbo.tblcase.DateOfService_Start,101) + ' - ' + CONVERT(VARCHAR(10),dbo.tblcase.DateOfService_End,101) AS DOS_Range,
					Status AS [Status],
					ISNULL(Initial_Status,'') AS [Initial_Status],
					ISNULL(dbo.tblStatus.Final_Status,'') AS Final_Status,
					ISNULL(IndexOrAAA_Number,'') AS [IndexOrAAA_Number]
	from			tblCase
	INNER JOIN dbo.tblProvider WITH (NOLOCK) ON tblcase.Provider_Id = dbo.tblProvider.Provider_Id
	INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id
	LEFT OUTER JOIN  dbo.tblStatus WITH (NOLOCK) ON tblcase.Status = dbo.tblStatus.Status_Abr  and tblcase.DomainId=tblStatus.DomainId
				where			tblcase.provider_id = @ProviderId
				and				status = @Status
				and				status <> 'IN ARB OR LIT'
				order by		insurancecompany_name
				asc
			END

END