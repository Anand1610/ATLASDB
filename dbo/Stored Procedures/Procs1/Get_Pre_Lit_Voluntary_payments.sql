/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[Get_Pre_Lit_Voluntary_payments] @i_a_ProviderId INT
	,@i_a_Months INT
	,@s_a_DomainId VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT year(transactions_date) AS [year]
		,month(transactions_date) AS [month]
		,count(DISTINCT case_id) AS Count_Cases
		,sum(claim_amount) AS claim_amount
		,sum(fee_schedule) AS fee_schedule
		,sum(voluntary_paid_amount) AS paid_amount
		,(sum(claim_amount) - sum(voluntary_paid_amount)) AS outstanding_balance
	FROM [SJR-PreLitigation]
	WHERE provider_id = @i_a_ProviderId
		AND datediff(m, transactions_date, getdate()) <= @i_a_Months
		AND DomainId = @s_a_DomainId
	GROUP BY year(transactions_date)
		,month(transactions_date)

	--SELECT year(transactions_date) AS [year]
	--	,month(transactions_date) AS [month]
	--	,CAST(year(transactions_date) AS VARCHAR(5)) + '/' + CAST(month(transactions_date) AS VARCHAR(5)) AS [Month_Year]
	--	,count(DISTINCT case_id) AS Count_Cases
	--	,sum(claim_amount) AS claim_amount
	--	,sum(voluntary_paid_amount) AS paid_amount
	--	,(sum(claim_amount) - sum(voluntary_paid_amount)) AS outstanding_balance
	--FROM [SJR-PreLitigation](NOLOCK)
	--WHERE provider_id = @i_a_ProviderId
	--	AND datediff(m, transactions_date, getdate()) <= @i_a_Months
	--	AND DomainId = @s_a_DomainId
	--GROUP BY year(transactions_date)
	--	,month(transactions_date)
	--	,CAST(year(transactions_date) AS VARCHAR(5)) + '/' + CAST(month(transactions_date) AS VARCHAR(5))
END