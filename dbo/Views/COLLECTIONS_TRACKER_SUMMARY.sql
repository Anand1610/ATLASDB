
CREATE VIEW [dbo].[COLLECTIONS_TRACKER_SUMMARY]
AS
SELECT     TOP (100) PERCENT COUNT(Case_Id) AS TRANSACTION_COUNT, COUNT(DISTINCT Case_Id) AS CASE_COUNT, 
                      SUM(CASE WHEN Transactions_Type = 'C' THEN Transactions_Amount END) AS PRINCIPAL, 
                      SUM(CASE WHEN Transactions_Type = 'I' THEN Transactions_Amount END) AS INTEREST, 
                      SUM(CASE WHEN Transactions_Type = 'AF' THEN Transactions_Amount END) AS ATTORNEY_FEES, 
                      SUM(CASE WHEN Transactions_Type = 'FFC' THEN Transactions_Amount END) AS FILING_FEES, DATENAME(mm, Transactions_Date) 
                      + '-' + CONVERT(varchar(4), YEAR(Transactions_Date)) AS MONTH, CONVERT(int, CONVERT(VARCHAR(4), YEAR(Transactions_Date)) 
                      + CONVERT(VARCHAR(2), MONTH(Transactions_Date))) AS DATE, SUM(Transactions_Amount) AS Total, YEAR(Transactions_Date) AS YEAR_D, 
                      MONTH(Transactions_Date) AS MONTH_D
FROM         dbo.SJR_COLLECTION_TRACKER_DETAILS
GROUP BY DATENAME(mm, Transactions_Date) + '-' + CONVERT(varchar(4), YEAR(Transactions_Date)), CONVERT(int, CONVERT(VARCHAR(4), 
                      YEAR(Transactions_Date)) + CONVERT(VARCHAR(2), MONTH(Transactions_Date))), YEAR(Transactions_Date), MONTH(Transactions_Date)
ORDER BY YEAR_D, MONTH_D
