CREATE PROCEDURE [dbo].[CPT_Details_For_Payment] 
	-- Add the parameters for the stored procedure here
	@s_a_Pay_id INT,
	@s_a_Case_id   NVARCHAR(20),  
	@s_a_DomainID  NVARCHAR(50) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	tbl_CPT_Payment_Details.CPT_ATUO_ID as TCPT_ATUO_ID,
	cod.Code as TCPT_Code,
	cod.DOS ,
	cod.Description as TDescription,

	ISNULL( cod.collectedAmount,0.0) as TPrev_Collected_Amount,
	Current_Paid AS TCurrent_Paid,
	iif(Current_Paid is null, 0.00, Current_Paid) AS TEdit_Amount,

	ISNULL( cod.Intrest,0.0) as TPrev_Intrest,
	iif(Current_Interest is null, 0.00, Current_Interest) AS TInterest_Paid,
	iif(Current_Interest is null, 0.00, Current_Interest) AS TEdit_Intrest,

	ISNULL( cod.Deductible,0.00) TPrev_Deductible,
	iif(Current_Deductible is null, 0.00, Current_Deductible) AS TDeductible,
	iif(Current_Deductible is null, 0.00, Current_Deductible) AS TEdit_Deductible,
	
	ISNULL( cod.AttorneyFee,0.00) TPrev_AttorneyFee,
	iif(Current_AttorneyFee is null, 0.00, Current_AttorneyFee) AS TAttorneyFee,
	iif(Current_AttorneyFee is null, 0.00, Current_AttorneyFee)  AS TEdit_AttorneyFee,


	ISNULL(cod.LITCollectedAmount,0.0) as TPrev_LIT_Collected_Amount,
	Current_LIT_Paid AS TCurrent_LIT_Paid,
	iif(Current_LIT_Paid is null, 0.00, Current_LIT_Paid) AS TEdit_LIT_Paid,

	ISNULL( cod.LITIntrest,0.0) as TPrev_LIT_Intrest,
	Current_LIT_Interest AS TInterest_LIT_Paid,
	iif(Current_LIT_Interest is null, 0.00, Current_LIT_Interest) AS TEdit_LIT_Intrest,

	ISNULL( cod.LITFees,0.0) as TPrev_LIT_Fees,
	Current_LIT_Fees AS TLITFees,
	iif(Current_LIT_Fees is null, 0.00, Current_LIT_Fees) AS TEdit_LITFees,

	ISNULL(cod.CourtFees,0.0) as TPrev_LIT_CourtFee,
	Current_LIT_CourtFee AS TCourtFees,
	iif(Current_LIT_CourtFee is null, 0.00, Current_LIT_CourtFee) AS TEdit_CourtFees


	FROM tbl_CPT_Payment_Details
	INNER JOIN BILLS_WITH_PROCEDURE_CODES cod ON tbl_CPT_Payment_Details.CPT_ATUO_ID=cod.CPT_ATUO_ID
	WHERE
	tbl_CPT_Payment_Details.Case_ID=@s_a_Case_id
	AND tbl_CPT_Payment_Details.Domainid=@s_a_DomainID
	AND Transaction_Id=@s_a_Pay_id
END
