
CREATE VIEW [dbo].[BALANCE_AGING]
AS
SELECT     dbo.tblcase.Case_Id, dbo.tblcase.Case_Code, dbo.tblProvider.Provider_Name, dbo.tblInsuranceCompany.InsuranceCompany_Name, 
                      ISNULL(SUM(dbo.tblTransactions.Transactions_Amount), 0) AS PAYMT_TOTAL, dbo.tblSettlements.Settlement_Total, 
                      dbo.tblSettlements.Settlement_Total - ISNULL(SUM(dbo.tblTransactions.Transactions_Amount), 0) AS BALANCE, CONVERT(char, 
                      dbo.tblSettlements.Settlement_Date, 3) AS Settlemet_Date, DATEDIFF(DAY, dbo.tblSettlements.Settlement_Date, GETDATE()) AS AGING, DATEDIFF(DAY, 
                      dbo.tblSettlements.Settlement_Date, GETDATE()) / 90 AS AGING_TRIM, dbo.tblcase.Status, dbo.tblProvider.Provider_Code
FROM         dbo.tblTransactions INNER JOIN
                      dbo.tblcase ON dbo.tblTransactions.Case_Id = dbo.tblcase.Case_Id INNER JOIN
                      dbo.tblInsuranceCompany ON dbo.tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id INNER JOIN
                      dbo.tblProvider ON dbo.tblcase.Provider_Id = dbo.tblProvider.Provider_Id INNER JOIN
                      dbo.tblSettlements ON dbo.tblcase.Case_Id = dbo.tblSettlements.Case_Id
WHERE     (dbo.tblcase.Case_Code IS NULL) AND (dbo.tblcase.Status = N'SETTLED') AND (dbo.tblTransactions.Transactions_Type = N'ffc' OR
                      dbo.tblTransactions.Transactions_Type = N'af' OR
                      dbo.tblTransactions.Transactions_Type = N'I' OR
                      dbo.tblTransactions.Transactions_Type = N'c')
GROUP BY dbo.tblcase.Case_Id, dbo.tblcase.Case_Code, dbo.tblProvider.Provider_Name, dbo.tblInsuranceCompany.InsuranceCompany_Name, 
                      dbo.tblSettlements.Settlement_Total, dbo.tblSettlements.Settlement_Date, DATEDIFF(DAY, dbo.tblSettlements.Settlement_Date, GETDATE()) / 90, 
                      dbo.tblcase.Status, dbo.tblProvider.Provider_Code
HAVING      (SUM(dbo.tblTransactions.Transactions_Amount) <= dbo.tblSettlements.Settlement_Total) AND (DATEDIFF(DAY, dbo.tblSettlements.Settlement_Date, 
                      GETDATE()) > 30) AND (dbo.tblSettlements.Settlement_Total - ISNULL(SUM(dbo.tblTransactions.Transactions_Amount), 0) > 31)
