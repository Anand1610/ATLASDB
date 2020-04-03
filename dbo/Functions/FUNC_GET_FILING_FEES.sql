-- =============================================
-- Author:		SJR
-- ALTER date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_FILING_FEES] 
(
	
	@CASE_ID VARCHAR(50)
)
RETURNS MONEY
AS
BEGIN
	
	DECLARE @Result MONEY

	
	SELECT @Result = 
	isnull(SUM(TRANSACTIONS_AMOUNT),0) FROM tblTransactions
	WHERE Transactions_Type like 'FFB%' AND Case_Id = @CASE_ID


	RETURN @Result

END
