/*  
Created by : Deepak V
Description : New SP
Date: 4/27/2020
Last Change By: Deepak V
*/
CREATE PROCEDURE [dbo].[Get_Total_Withdrawn_Cases_For_Months]
	@i_a_provider_id int,
	@s_a_DomainId varchar(50),
	@i_a_Months int
AS
BEGIN
	SET NOCOUNT ON;

		SELECT 
			count(*) as 'Total_Case',
			ISNULL(SUM(ISNULL([dbo].[SJR-SETTLEMENTS_FULL].Claim_Amount,0)),0) as 'Total_Claim_Amount',
			ISNULL(SUM(ISNULL([dbo].[SJR-SETTLEMENTS_FULL].Claim_Amount,0) - ISNULL([dbo].[SJR-SETTLEMENTS_FULL].Paid_Amount,0)),0) as 'Total_Balance',
			ISNULL(SUM(ISNULL([dbo].[SJR-SETTLEMENTS_FULL].Settlement_Amount,0)),0) as 'Total_Settlement_Amount', 
		    iif(ISNULL(SUM(ISNULL([dbo].[SJR-SETTLEMENTS_FULL].Claim_Amount,0) - ISNULL([dbo].[SJR-SETTLEMENTS_FULL].Paid_Amount,0)),0) !=0, Convert(varchar(20), (ISNULL(SUM(ISNULL([dbo].[SJR-SETTLEMENTS_FULL].Settlement_Amount,0)),0)/ISNULL(SUM(ISNULL([dbo].[SJR-SETTLEMENTS_FULL].Claim_Amount,0) - ISNULL([dbo].[SJR-SETTLEMENTS_FULL].Paid_Amount,0)),0))*100),'N/A') AS 'Avrg_Percent'
		FROM [dbo].[SJR-SETTLEMENTS_FULL](NOLOCK) INNER JOIN tblcase(NOLOCK) ON [dbo].[SJR-SETTLEMENTS_FULL].Case_Id = tblcase.Case_Id
		WHERE tblcase.provider_id=@i_a_provider_id and tblcase.DomainId = @s_a_DomainId 
		and datediff(m,[dbo].[SJR-SETTLEMENTS_FULL].Settl_Date,getdate())<= @i_a_Months
		and ([dbo].[SJR-SETTLEMENTS_FULL].Settlement_Amount = 0)
END