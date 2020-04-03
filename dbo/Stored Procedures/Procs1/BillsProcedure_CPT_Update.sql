CREATE PROCEDURE [dbo].[BillsProcedure_CPT_Update] 
	-- Add the parameters for the stored procedure here
	@tblCPT [dbo].[CPTBillsUpdate] READONLY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE b 
	SET 
	b.CollectedAmount = a.TCollectedAmount
	, b.Deductible = a.TDeductible
	, b.Intrest= a.TIntrest
	, b.AttorneyFee = a.TAttorneyFee
	FROM @tblCPT a
	INNER JOIN BILLS_WITH_PROCEDURE_CODES b ON b.CPT_ATUO_ID=a.TCPT_ATUO_ID
	WHERE 
	a.TDomainID=b.DomainID



END
