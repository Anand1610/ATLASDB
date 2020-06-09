
/*  Created by : atul jDescription : New SPDate: 6/8/2020Last Change By: atul j*/
create PROCEDURE [dbo].[Get_Total_Client_filed_Cases_For_Months]
	@i_a_provider_id int,
	@s_a_DomainId varchar(50),
	@i_a_Months int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		count(*) as 'Total_Cases',
		isnull(sum(cast(ISNULL(claim_amount,0) as money)),0) as 'TotalClaim_Amount',
		isnull(sum(cast(ISNULL(paid_amount, 0) as money)),0) as 'TotalPaid_Amount',
		isnull(sum(cast(ISNULL(claim_amount, 0) as money)-cast(ISNULL(paid_amount, 0) as money)),0) as 'Total_Balance' 
	FROM [dbo].[SJR_Filed_Case_report]
	WHERE datediff(m,Date_aaa_arb_filed,getdate()) <= @i_a_Months and provider_id = @i_a_provider_id and DomainId = @s_a_DomainId

END