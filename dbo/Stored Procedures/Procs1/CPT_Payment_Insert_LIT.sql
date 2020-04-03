CREATE PROCEDURE [dbo].[CPT_Payment_Insert_LIT] 
	-- Add the parameters for the stored procedure here
	@tblCPT [dbo].[CPTPayDetailsLIT] READONLY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO tbl_CPT_Payment_Details(
	CPT_ATUO_ID	,
	Prev_LIT_Collected_Amount	,
	Current_LIT_Paid	,
	Prev_LIT_Intrest	,
	Current_LIT_Interest	,
	Prev_LIT_Fees	,
	Current_LIT_Fees	,
	Prev_LIT_CourtFee	,
	Current_LIT_CourtFee	,
	Case_ID	,
	Created_By	,
	Created_Date	,
	DomainId	,
	Transaction_Id	
	)
	select 
		TCPT_ATUO_ID
	,	TPrev_LIT_Collected_Amount
	,	TCurrent_LIT_Paid
	,	TPrev_LIT_Intrest
	,	TLITIntrest
	,	TPrev_LIT_Fees
	,	TLITFees
	,	TPrev_LIT_CourtFee
	,	TCourtFees
	,	TCase_ID
	,	TCreated_By
	,	getdate()
	,	TDomainID
	,	TPayment_Id

	from @tblCPT
END
