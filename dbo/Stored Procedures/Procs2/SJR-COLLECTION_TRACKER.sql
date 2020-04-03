-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SJR-COLLECTION_TRACKER]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	
	SET NOCOUNT ON;
DECLARE @NOTES_DATE DATETIME



    -- Insert statements for procedure here
	SELECT     tblcase.Case_Id, tblTransactions.Transactions_Type, tblTransactions.Transactions_Amount, tblTransactions.Transactions_Date, tblNotes.User_Id, 
                      tblTransactions.Transactions_Id, DATEDIFF(d, [SJR-SETTLEMENTS_FULL].Settl_date, tblTransactions.Transactions_Date) AS AGE
FROM         tblInsuranceCompany INNER JOIN
                      tblcase ON tblInsuranceCompany.InsuranceCompany_Id = tblcase.InsuranceCompany_Id INNER JOIN
                      tblProvider ON tblcase.Provider_Id = tblProvider.Provider_Id INNER JOIN
                      tblTransactions ON tblcase.Case_Id = tblTransactions.Case_Id INNER JOIN
                      tblNotes ON tblcase.Case_Id = tblNotes.Case_Id AND tblTransactions.Transactions_Date > tblNotes.Notes_Date INNER JOIN
                      [SJR-SETTLEMENTS_FULL] ON tblcase.Case_Id = [SJR-SETTLEMENTS_FULL].Case_Id
WHERE     (tblNotes.Notes_Desc LIKE '%COLLECTION CALL%')
GROUP BY tblcase.Case_Id, tblTransactions.Transactions_Type, tblTransactions.Transactions_Amount, tblTransactions.Transactions_Date, tblNotes.User_Id, 
                      tblTransactions.Transactions_Id, DATEDIFF(d, [SJR-SETTLEMENTS_FULL].Settl_date, tblTransactions.Transactions_Date)
HAVING      (tblNotes.User_Id = N'evrosenthal')
ORDER BY tblTransactions.Transactions_Date
END

