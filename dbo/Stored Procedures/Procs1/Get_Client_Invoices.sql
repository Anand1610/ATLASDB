/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[Get_Client_Invoices]
	@i_a_provider_id int,
	@s_a_DomainId varchar(50),
	@i_a_Months int
AS
BEGIN
	SET NOCOUNT ON;

    SELECT 
		 t1.account_id
		,t2.provider_name
		,isnull(t1.gross_amount,0.00) as gross_amount
		,isnull(t1.firm_fees,0.00) as firm_fees
		,isnull(t1.cost_balance,0.00) as cost_balance
		,isnull(t1.applied_cost,0.00) as applied_cost
		,isnull(t1.final_remit,0.00) as final_remit
		,t1.account_date
		, t1.last_printed 
	FROM tblclientaccount t1, tblprovider t2 
	WHERE  t1.provider_id=t2.provider_id and t1.provider_id=@i_a_provider_id and Datediff(m,Account_Date,getdate()) <= @i_a_Months
	and t1.DomainId= @s_a_DomainId order by t1.account_date
		
END