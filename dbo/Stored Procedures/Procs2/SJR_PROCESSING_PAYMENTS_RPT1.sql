-- =============================================
-- Author:		Name
-- ALTER date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SJR_PROCESSING_PAYMENTS_RPT1] 
	
	
	@start_date DATE, 
	@end_date DATE,@provider_name varchar(50) = NULL


AS
SET NOCOUNT ON

BEGIN
	
IF @provider_name IS NULL

BEGIN

SELECT     CONVERT(DATE,Transactions_Date) as TRANSACTIONS_DATE,COUNT(TRANSACTIONS_ID)AS TRANSACTIONS,
COUNT(DISTINCT PROVIDER_ID)AS ACCOUNTS, 
SUM(Case  when  transactions_type ='C' THEN Transactions_Amount END) as Principal,
SUM(Case  when  transactions_type ='I' THEN Transactions_Amount  END) as Interest ,
SUM(Case  when  transactions_type ='AF' THEN Transactions_Amount END) as AF,
SUM(Case  when  transactions_type ='FFC' THEN Transactions_Amount END) as FF

FROM         tblTransactions 
WHERE transactions_type IN ('C','I','AF','FFC')
GROUP BY CONVERT(DATE,Transactions_Date)
HAVING CONVERT(DATE,Transactions_Date) BETWEEN @start_date AND @end_date


goto finish
END


IF @provider_name IS NOT NULL

BEGIN

SELECT     CONVERT(DATE,T.Transactions_Date) as TRANSACTIONS_DATE,COUNT(T.TRANSACTIONS_ID)AS TRANSACTIONS,
COUNT(DISTINCT T.PROVIDER_ID)AS ACCOUNTS, 
SUM(Case  when  T.transactions_type ='C' THEN T.Transactions_Amount END) as Principal,
SUM(Case  when  T.transactions_type ='I' THEN T.Transactions_Amount  END) as Interest ,
SUM(Case  when  T.transactions_type ='AF' THEN T.Transactions_Amount END) as AF,
SUM(Case  when  T.transactions_type ='FFC' THEN T.Transactions_Amount END) as FF

FROM         tblTransactions T INNER JOIN TBLPROVIDER P ON P.Provider_Id=T.Provider_Id
WHERE T.transactions_type IN ('C','I','AF','FFC')AND P.Provider_Name LIKE '%' + @provider_name  + '%'
GROUP BY CONVERT(DATE,Transactions_Date)
HAVING CONVERT(DATE,T.Transactions_Date) BETWEEN @start_date AND @end_date



END




FINISH:
END

