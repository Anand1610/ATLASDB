/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[Get_Client_Settlement_Information] -- Get_Client_Settlement_Information '4991','AF',12
	@i_a_provider_id VARCHAR(50)
	,@s_a_DomainId VARCHAR(50)
	,@dt INT = 0
AS
BEGIN
	SET NOCOUNT ON;

	EXEC [dbo].[LCJ_SettlementReport] @DomainId = @s_a_DomainId,@dt = @dt, @pro_id = @i_a_provider_id

	SELECT year(settlement_date) AS [Year]
		,month(settlement_date) AS [Month]
		,CAST(year(settlement_date) AS VARCHAR(20)) + '/' + CAST(month(settlement_date) AS VARCHAR(20)) AS [Month_Year]
		,count(*) AS 'Count_Cases'
		,sum(isnull(claim_amount, 0)) AS 'Sum_Claim_Amount'
		,sum(isnull(Fee_Schedule, 0) - isnull(paid_amount, 0)) AS 'Fee_Schedule'
		,sum(isnull(claim_amount, 0) - isnull(paid_amount, 0)) AS 'Sum_Balance'
		,isnull(sum(isnull(settlement_amount, 0)), 0) AS 'Sum_Settlement_Amount'
		,isnull(sum(isnull(settlement_Int, 0)), 0) AS 'Sum_Settlement_Int'
		,iif(sum(isnull(claim_amount, 0) - isnull(paid_amount, 0)) != 0, Convert(VARCHAR(20), ((sum(isnull(settlement_amount, 0)) + sum(isnull(settlement_Int, 0))) / sum(isnull(claim_amount, 0) - isnull(paid_amount, 0))) * 100), 'N/A') AS Claim_Percent
		,iif(sum(isnull(Fee_Schedule, 0) - isnull(paid_amount, 0)) != 0, Convert(VARCHAR(20), ((sum(isnull(settlement_amount, 0)) + sum(isnull(settlement_Int, 0))) / sum(isnull(Fee_Schedule, 0) - isnull(paid_amount, 0))) * 100), 'N/A') AS Fees_Percent
	FROM tblreportsettlement(NOLOCK)
	WHERE provider_id = @i_a_provider_id
		AND (datediff(m, settlement_date, getdate()) <= @dt)
		AND DomainId = @s_a_DomainId
		AND settlement_amount > 0
	GROUP BY year(settlement_date)
		,Month(settlement_date)
		,provider_id
	ORDER BY year(settlement_date) DESC
		,month(settlement_Date) DESC
END
