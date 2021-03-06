﻿/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[SPGetClientSettlementIDSReport]  -- SPGetClientSettlementIDSReport 4516,2019,7
@ProviderId INT,
@SettlementDateYear VARCHAR(5),
@SettlementDateMonth VARCHAR(5)
AS
BEGIN
	SELECT			b.Case_ID,
					b.IndexOrAAA_Number,
					ISNULL(b.InjuredParty_LastName + ',' + b.InjuredParty_FirstName,'') AS InjuredParty_Name,
					a.Provider_Name,
					a.InsuranceCompany_Name,
					ISNULL(a.Claim_Amount,0.00) - ISNULL(a.Paid_Amount,0.00) AS Initial_Amount,
					ISNULL(a.Fee_Schedule,0.00) AS Fee_Schedule,
					ISNULL(T.Transactions_Amount,'0.00') AS Transactions_Amount,
					ISNULL(a.User_Id,'') AS UserId,
					ISNULL(a.Settlement_Amount,0.00) AS Settlement_Amount,
					ISNULL(a.Settlement_Int,0.00) AS Settlement_Int,
					ISNULL(a.Settlement_Date,'') AS Settlement_Date,
					ISNULL(a.Settlement_Notes,'') AS Settlement_Notes,
					ISNULL(a.Settlement_Total,0.00) AS Settlement_Total
	FROM			tblreportsettlement a
	INNER JOIN		tblcase b ON a.case_id = b.case_id 
	LEFT JOIN		( 
						SELECT distinct		Case_Id as CaseID,
											ISNULL(sum(Transactions_Amount),'0.00') AS Transactions_Amount
						FROM				tblTransactions
						WHERE				Transactions_Type in ('C','I')
						Group by			Case_Id
					) T ON T.CaseID = a.Case_Id
	WHERE			a.provider_id = @ProviderId
	and				a.settlement_amount > 0
	and				YEAR(a.settlement_date) =	@SettlementDateYear
	and				MONTH(a.settlement_date) =	@SettlementDateMonth
	ORDER BY		a.settlement_date
END