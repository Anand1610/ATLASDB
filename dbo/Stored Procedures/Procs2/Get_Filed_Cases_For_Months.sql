
/*  Created by : atul jDescription : New SPDate: 6/8/2020Last Change By: atul j*/
create PROCEDURE [dbo].[Get_Filed_Cases_For_Months]
	@i_a_provider_id int,
	@s_a_DomainId varchar(50),
	@i_a_Months int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		Initial_Status, 
		Month(Date_aaa_arb_filed) as [Month], 
		year(Date_aaa_arb_filed) as [Year],
		count(*) as 'Count_Cases',
		sum(cast(ISNULL(claim_amount,0) as money)) as 'Sum_Claim_Amount',
		sum(cast(ISNULL(paid_amount,0) as money)) as 'Sum_Paid_Amount',
		sum(cast(ISNULL(claim_amount,0) as money)-cast(ISNULL(paid_amount,0) as money)) as 'Sum_Balance' 
	FROM [dbo].[SJR_Filed_Case_report]
	WHERE datediff(m,Date_aaa_arb_filed,getdate())<= @i_a_Months and provider_id = @i_a_provider_id and DomainId = @s_a_DomainId
	group by Initial_Status, year(Date_aaa_arb_filed),month(Date_aaa_arb_filed),provider_id order by year(Date_aaa_arb_filed) desc, month(Date_aaa_arb_filed) desc

END