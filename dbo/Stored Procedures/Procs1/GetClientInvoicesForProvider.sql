CREATE PROCEDURE [dbo].[GetClientInvoicesForProvider] --GetClientInvoicesForProvider '4042','AF'
@provider_id INT,
@DomainId VARCHAR(10),
@DateDiff int=0
AS
BEGIN
	SELECT 
		t1.account_id,
		t2.provider_name,
		t1.gross_amount, 
		t1.firm_fees,
		t1.cost_balance,
		t1.applied_cost,
		t1.final_remit,
		t1.account_date, 
		t1.last_printed,
		ISNULL(t1.VENDOR_FEE,0.00) AS VENDOR_FEE,
		ISNULL(t1.Intrest_Due,0.00) AS Interest_Due 
		,ISNULL(t1.Rebuttal_Fee, 0.00) AS Rebuttal_Fee
		FROM tblclientaccount t1 (NOLOCK), 
		tblprovider t2 (NOLOCK) 
	WHERE   t1.provider_id=t2.provider_id 
			and t1.provider_id=@provider_id
			and (@DateDiff =0 OR DATEDIFF(m,Account_Date,GETDATE()) <= @DateDiff)
			and t1.DomainId= @DomainId
	ORDER BY t1.account_date
End
	