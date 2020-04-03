CREATE PROCEDURE [dbo].[CPT_Payment_Update] 
	-- Add the parameters for the stored procedure here
	@tblCPT [dbo].[CPTPayDetails_Update] READONLY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE b 
	SET 
	b.Prev_Collected_Amount = TPrev_Collected_Amount,
	b.Current_Paid = TCurrent_Paid,
	b.Prev_Deductible = TPrev_Deductible,
	b.Current_Deductible = TDeductible,
	b.Prev_Intrest = TPrev_Intrest,
	b.Current_Interest = TInterest_Paid,
	b.Prev_AttorneyFee = TPrev_AttorneyFee,
	b.Current_AttorneyFee = TAttorneyFee,
	b.Modified_By=a.TCreated_By,
	b.Modified_Date=GETDATE()
	FROM @tblCPT a
	INNER JOIN tbl_CPT_Payment_Details b ON b.Transaction_Id=a.TPayment_Id
	--INNER JOIN tbl_CPT_Payment_Details b ON b.CPT_ATUO_ID=a.TCPT_ATUO_ID
	WHERE 
	a.TDomainID=b.DomainID
	AND a.TCase_ID=b.Case_ID
	AND a.TCPT_ATUO_ID=b.CPT_ATUO_ID

END
