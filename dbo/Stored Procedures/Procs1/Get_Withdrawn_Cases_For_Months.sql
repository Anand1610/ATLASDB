CREATE PROCEDURE [dbo].[Get_Withdrawn_Cases_For_Months] @i_a_provider_id INT
	,@s_a_DomainId VARCHAR(50)
	,@i_a_Months INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT YEAR([dbo].[SJR-SETTLEMENTS_FULL].Settl_Date) AS Year
		,MONTH([dbo].[SJR-SETTLEMENTS_FULL].Settl_Date) AS Month
		,COUNT([dbo].[SJR-SETTLEMENTS_FULL].Case_Id) AS 'Count_Cases'
		,isnull(SUM(ISNULL([dbo].[SJR-SETTLEMENTS_FULL].Claim_Amount, 0)), 0) AS 'Sum_Claim_Amount'
		,isnull(SUM(ISNULL([dbo].[SJR-SETTLEMENTS_FULL].Claim_Amount, 0) - ISNULL([dbo].[SJR-SETTLEMENTS_FULL].Paid_Amount, 0)), 0) AS 'Sum_Balance'
		,SUM(ISNULL([dbo].[SJR-SETTLEMENTS_FULL].Settlement_Amount, 0)) AS Sum_Settlement_Amount
		,iif(SUM(ISNULL([dbo].[SJR-SETTLEMENTS_FULL].Claim_Amount, 0) - ISNULL([dbo].[SJR-SETTLEMENTS_FULL].Paid_Amount, 0)) != 0, Convert(VARCHAR(20), (SUM(ISNULL([dbo].[SJR-SETTLEMENTS_FULL].Settlement_Amount, 0)) / SUM(ISNULL([dbo].[SJR-SETTLEMENTS_FULL].Claim_Amount, 0) - ISNULL([dbo].[SJR-SETTLEMENTS_FULL].Paid_Amount, 0))) * 100), 'N/A') AS 'Sum_Percent'
	FROM [dbo].[SJR-SETTLEMENTS_FULL](NOLOCK)
	INNER JOIN tblcase(NOLOCK) ON [dbo].[SJR-SETTLEMENTS_FULL].Case_Id = tblcase.Case_Id
	WHERE tblcase.provider_id = @i_a_provider_id
		AND tblcase.DomainId = @s_a_DomainId
		AND datediff(m, [dbo].[SJR-SETTLEMENTS_FULL].Settl_Date, getdate()) <= @i_a_Months
		AND ([dbo].[SJR-SETTLEMENTS_FULL].Settlement_Amount = 0)
	GROUP BY YEAR([dbo].[SJR-SETTLEMENTS_FULL].Settl_Date)
		,MONTH([dbo].[SJR-SETTLEMENTS_FULL].Settl_Date)
		,tblcase.Provider_Id
	ORDER BY Year DESC
		,Month DESC
END