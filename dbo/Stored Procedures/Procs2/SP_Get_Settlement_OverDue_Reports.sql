﻿/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[SP_Get_Settlement_OverDue_Reports] ---[SP_Get_Settlement_OverDue_Reports] 'AF', '2019-06-26','2019-11-26'
	(
	@DomainId VARCHAR(25)
	,@OverDueSettlementdt1 DATETIME
	,@OverDueSettlementdt2 DATETIME
	)
AS
BEGIN
	SELECT DISTINCT tblCase.Case_Id
		,IndexOrAAA_Number
		,ISNULL(tblcase.InjuredParty_FirstName, N'') + N'  ' + ISNULL(tblcase.InjuredParty_LastName, N'') AS InjuredParty_Name
		,provider_name
		,insurancecompany_name
		,claim_amount
		,paid_amount
		,settlement_amount
		,settlement_date
		,settlement_int
		,settlement_af
		,settlement_ff
		,settlement_total
		,user_id
		,settledwith
		,CASE 
			WHEN settlement_amount = '.0000'
				AND settlement_int = '.0000'
				AND settlement_AF = '.0000'
				AND settlement_FF <> '.0000'
				THEN 'FF NOT PAID'
			WHEN settlement_amount = '.0000'
				AND settlement_int = '.0000'
				AND settlement_AF <> '.0000'
				AND settlement_FF = '.0000'
				THEN 'AF NOT PAID'
			WHEN settlement_amount = '.0000'
				AND settlement_int = '.0000'
				AND settlement_AF <> '.0000'
				AND settlement_FF <> '.0000'
				THEN 'AF, FF NOT PAID'
			WHEN settlement_amount = '.0000'
				AND settlement_int <> '.0000'
				AND settlement_AF = '.0000'
				AND settlement_FF = '.0000'
				THEN 'INT NOT PAID'
			WHEN settlement_amount = '.0000'
				AND settlement_int <> '.0000'
				AND settlement_AF = '.0000'
				AND settlement_FF <> '.0000'
				THEN 'INT, FF NOT PAID'
			WHEN settlement_amount = '.0000'
				AND settlement_int <> '.0000'
				AND settlement_AF <> '.0000'
				AND settlement_FF = '.0000'
				THEN 'INT, AF NOT PAID'
			WHEN settlement_amount = '.0000'
				AND settlement_int <> '.0000'
				AND settlement_AF <> '.0000'
				AND settlement_FF <> '.0000'
				THEN 'INT, AF, FF NOT PAID'
			WHEN settlement_amount <> '.0000'
				AND settlement_int = '.0000'
				AND settlement_AF = '.0000'
				AND settlement_FF = '.0000'
				THEN 'PRINCIPLE NOT PAID'
			WHEN settlement_amount <> '.0000'
				AND settlement_int = '.0000'
				AND settlement_AF = '.0000'
				AND settlement_FF <> '.0000'
				THEN 'PRINCIPLE, FF NOT PAID'
			WHEN settlement_amount <> '.0000'
				AND settlement_int = '.0000'
				AND settlement_AF <> '.0000'
				AND settlement_FF = '.0000'
				THEN 'PRINCIPLE, AF NOT PAID'
			WHEN settlement_amount <> '.0000'
				AND settlement_int = '.0000'
				AND settlement_AF <> '.0000'
				AND settlement_FF <> '.0000'
				THEN 'PRINCIPLE, AF, FF NOT PAID'
			WHEN settlement_amount <> '.0000'
				AND settlement_int <> '.0000'
				AND settlement_AF = '.0000'
				AND settlement_FF = '.0000'
				THEN 'PRINCIPLE, INT NOT PAID'
			WHEN settlement_amount <> '.0000'
				AND settlement_int <> '.0000'
				AND settlement_AF = '.0000'
				AND settlement_FF <> '.0000'
				THEN 'PRINCIPLE, INT, FF NOT PAID'
			WHEN settlement_amount <> '.0000'
				AND settlement_int <> '.0000'
				AND settlement_AF <> '.0000'
				AND settlement_FF = '.0000'
				THEN 'PRINCIPLE, INT, AF NOT PAID'
			WHEN settlement_amount <> '.0000'
				AND settlement_int <> '.0000'
				AND settlement_AF <> '.0000'
				AND settlement_FF <> '.0000'
				THEN 'PRINCIPLE, INT, AF, FF NOT PAID'
			END AS 'FeesStatus'
	FROM tblCase
	INNER JOIN dbo.tblProvider WITH (NOLOCK) ON tblcase.Provider_Id = dbo.tblProvider.Provider_Id
	INNER JOIN dbo.tblInsuranceCompany WITH (NOLOCK) ON tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id
	LEFT JOIN dbo.tblSettlements WITH (NOLOCK) ON tblcase.Case_Id = dbo.tblSettlements.Case_Id
	WHERE CAST(FLOOR(CAST(settlement_date AS FLOAT)) AS DATETIME) BETWEEN @OverDueSettlementdt1
			AND @OverDueSettlementdt2
		AND 0 = (
			SELECT count(*)
			FROM tbltransactions b
			WHERE b.transactions_type IN (
					'C'
					,'I'
					,'E'
					)
				AND b.case_id = tblCase.case_id
			)
		AND tblCase.DomainId = @DomainId
		AND settlement_total <> '.0000'
	ORDER BY Settlement_date ASC
END
