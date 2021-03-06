﻿/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[SpGetClientSettlementDiscons]  -- SpGetClientSettlementDiscons 'AF',2019,6,4048
@DomainID VARCHAR(10),
@Year INT,
@Month INT,
@ProviderID INT
AS
BEGIN
	select		Case_Id AS CaseID,
				ISNULL(IndexOrAAA_Number,'') AS IndexOrAAA_Number,
				ISNULL(InjuredParty_Name,'') AS InjuredParty_Name,
				ISNULL(Provider_Name,'') AS Provider_Name,
				ISNULL(InsuranceCompany_Name,'') AS InsuranceCompany_Name,
				ISNULL(Claim_Amount,0.00) AS Claim_Amount,
				ISNULL(Paid_Amount,0.00) AS Paid_Amount,
				ISNULL(User_Id,'') AS User_Id,
				ISNULL(Settlement_Amount,0.00) AS Settlement_Amount,
				ISNULL(Settlement_Int,0.00) AS Settlement_Int,
				ISNULL(Settlement_FF,0.00) AS Settlement_FF,
				ISNULL(Settlement_AF,0.00) AS Settlement_AF,
				ISNULL(Settlement_Total,0.00) AS Settlement_Total,
				ISNULL(Settlement_Date,'') AS Settlement_Date,
				ISNULL(Settlement_Notes,'') AS Settlement_Notes
	from		[dbo].[SJR-SETTLEMENTS]
	where		provider_id = @ProviderID
	and			settlement_amount <= 0
	and			year(settlement_date) = @Year
	and			month(settlement_date) = @Month
	and			DomainId = @DomainID
	order by	settlement_date asc
END