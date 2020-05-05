/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[Get_Client_New_Cases_For_Months]
	@i_a_provider_id int,
	@s_a_DomainId varchar(50),
	@i_a_Months int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		Initial_Status, 
		Month(Date_Opened) as [Month], 
		year(date_opened) as [Year],
		count(*) as 'Count_Cases',
		sum(cast(ISNULL(claim_amount,0) as money)) as 'Sum_Claim_Amount',
		sum(cast(ISNULL(paid_amount,0) as money)) as 'Sum_Paid_Amount',
		sum(cast(ISNULL(claim_amount,0) as money)-cast(ISNULL(paid_amount,0) as money)) as 'Sum_Balance' 
	FROM [dbo].[SJR-Case_report]
	WHERE datediff(m,date_opened,getdate())<= @i_a_Months and provider_id = @i_a_provider_id and DomainId = @s_a_DomainId
	group by Initial_Status, year(date_opened),month(date_opened),provider_id order by year(date_opened) desc, month(date_opened) desc

END