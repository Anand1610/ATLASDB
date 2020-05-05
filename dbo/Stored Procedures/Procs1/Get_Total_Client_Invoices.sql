/*  
Created by : Deepak V
Description : New SP
Date: 4/27/2020
Last Change By: Deepak V
*/
CREATE PROCEDURE [dbo].[Get_Total_Client_Invoices]
	@i_a_provider_id int,
	@s_a_DomainId varchar(50),
	@i_a_Months int
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
		 isnull(sum(ISNULL(t1.gross_amount,0)),0) as 'Gross'
		,isnull(sum(ISNULL(t1.firm_fees,0)),0) as 'Fees' 
		,isnull(sum(ISNULL(t1.cost_balance,0)),0) as 'Cost_Balance'
		,isnull(sum(ISNULL(t1.applied_cost,0)),0) as 'applied_cost' 
		,isnull(sum(ISNULL(t1.final_remit,0)),0) as 'final_remit'  
	FROM tblclientaccount t1(NOLOCK), tblprovider t2(NOLOCK)
	WHERE t1.provider_id = t2.provider_id and t1.provider_id = @i_a_provider_id and t1.DomainId = @s_a_DomainId
	and Datediff(m,Account_Date,getdate()) <= @i_a_Months
	
END