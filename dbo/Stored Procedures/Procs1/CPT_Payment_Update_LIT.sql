CREATE PROCEDURE [dbo].[CPT_Payment_Update_LIT] 
	-- Add the parameters for the stored procedure here
	@tblCPT [dbo].[CPTPayDetails_Update_LIT] READONLY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE b 
	SET 
	b.Prev_LIT_Collected_Amount = TPrev_LIT_Collected_Amount,
	b.Current_LIT_Paid = TCurrent_LIT_Paid,
	b.Prev_LIT_Intrest = TPrev_LIT_Intrest,
	b.Current_LIT_Interest = TLITIntrest,
	b.Prev_LIT_Fees = TPrev_LIT_Fees,
	b.Current_LIT_Fees = TLITFees,
	b.Prev_LIT_CourtFee = TPrev_LIT_CourtFee,
	b.Current_LIT_CourtFee = TCourtFees,
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
