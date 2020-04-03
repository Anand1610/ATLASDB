CREATE PROCEDURE [dbo].[GetLawfirDetails]
@DomainId varchar(50),
@ProviderID varchar(50),
@Datediff INT
as
BEGIN
	SELECT 
			LawFirmName, 
			Client_Billing_Address, 
			Client_Billing_City, 
			Client_Billing_State,
			Client_Billing_Zip, 
			Client_Billing_Phone, 
			Client_Billing_Fax 
	FROM tbl_Client c 
	WHERE c.DomainId =@DomainId

	exec LCJ_GETCLIENTDETAILS @DomainId=@DomainId,@CLIENTID= @ProviderID

	SELECT	t1.account_id,
			t1.gross_amount, 
			t1.firm_fees,
			t1.cost_balance,
			t1.applied_cost,
			t1.account_date, 
			t1.last_printed,
			ISNULL(t1.Intrest_Due,0.00) AS Intrest_Due, 
			ISNULL(t1.Rebuttal_Fee, 0.00) AS Rebuttal_Fee
			,t1.firm_fees + ISNULL(t1.Intrest_Due, 0.00) + ISNULL(t1.Rebuttal_Fee, 0.00) AS TotalBalance
	from	tblclientaccount t1 
	where	t1.provider_id=@ProviderID
			and Datediff(m,Account_Date,getdate()) <= @Datediff 
			and t1.DomainId= @DomainId 
    order by	t1.account_date

	SELECT	isnull(sum(t1.gross_amount),0) as 'Gross', 
			isnull(sum(t1.firm_fees),0) as 'BillingFees',
			ISNULL(SUM(t1.Intrest_Due),0) as 'FirmFees',
			isnull(sum(isnull(t1.cost_balance,0)),0) as 'Cost_Balance',
			isnull(sum(t1.applied_cost),0) as 'applied_cost' ,
			isnull(sum(t1.final_remit),0) as 'final_remit'  
			,isnull(sum(t1.Rebuttal_Fee), 0) AS 'Rebuttal_Fee'
	FROM	tblclientaccount t1 
	where	t1.provider_id=@ProviderID
			and t1.DomainId= @DomainId
			and Datediff(m,Account_Date,getdate()) <= @Datediff

   SELECT	clientpaymentid,
			payment_amount,
			payment_date,
			Payment_Desc 
   FROM		tblclientpayment 
   WHERE	provider_id=@ProviderID
			and DomainId= @DomainId

	SELECT	
			isnull(sum(payment_amount),0) [Total_payment_amount]			
   FROM		tblclientpayment 
   WHERE	provider_id=@ProviderID
			and DomainId= @DomainId
  

END
