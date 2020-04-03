-- =============================================
-- Author:		Name
-- ALTER date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[TRANSACTIONXTS] 
(	
	-- Add the parameters for the function here
	@START_DATE DATETIME, 
	@END_DATE DATETIME
)
RETURNS TABLE 
AS

RETURN 
(
	-- Add the SELECT statement with parameter references here
	
SELECT     tblTransactions.Case_Id, tblTransactions.Transactions_Type, tblTransactions.Transactions_Date, tblTransactions.Transactions_Amount, 
                      tblProvider.Provider_Name, tblProvider.Provider_Id
FROM         tblTransactions INNER JOIN
                      tblProvider ON tblTransactions.Transactions_Id = tblProvider.Provider_Id
WHERE     (tblTransactions.Transactions_Date BETWEEN @START_DATE AND @END_DATE)
)
