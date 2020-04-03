CREATE PROCEDURE [dbo].[CPT_Payment_Insert] 
	-- Add the parameters for the stored procedure here
	@tblCPT [dbo].[CPTPayDetails] READONLY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO tbl_CPT_Payment_Details(
	CPT_ATUO_ID,
	--CPT_Code,
	--Description,
	Case_ID,
	Prev_Collected_Amount,
	Current_Paid,
	Created_By,
	Created_Date,
	DomainId,
	Transaction_Id,
   
	Prev_Deductible,
	Current_Deductible,

	Prev_Intrest,
	Current_Interest,

	[Prev_AttorneyFee],
	[Current_AttorneyFee]	
	)
	select 
	TCPT_ATUO_ID,
	--TCPT_Code,
	--TDescription,
	TCase_ID,
	TPrev_Collected_Amount,
	TCurrent_Paid,
	TCreated_By,
	GETDATE(),
	TDomainID,
	TPayment_Id,
	
	TPrev_Deductible,
	TDeductible,

	TPrev_Intrest,
	TInterest_Paid,

	[TPrev_AttorneyFee],
	[TAttorneyFee]
	from @tblCPT
END
