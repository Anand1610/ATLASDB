CREATE PROCEDURE [dbo].[F_Get_Settlement_Payment_Info]  --F_Get_Settlement_Payment_Info 'fh07-42372'
	(
	  @Case_Id VARCHAR(200)
	)
AS
BEGIN
	SET NOCOUNT ON;
	--settlement--
	  SELECT Distinct 
		C.Case_Id AS Case_ID,
	  DATENAME(MONTH, Settlement_Date) + ' ' +  Convert(varchar(10),YEAR(Settlement_Date)) AS 	Settlement_Date,
		InsuranceCompany_Name as [Insurance_Name],
		(Claim_Amount) AS Claim_Amount,
		(Paid_Amount) AS Paid_Amount,
		ISNULL(C.Fee_Schedule,'0.00') - ISNULL(C.Paid_Amount,'0.00') AS Claim_Balance,
		((Settlement_Amount)+(Settlement_Int)) AS Settlement_Amount,
		(Settlement_Type) AS  Settlement_Type,
		(Settlement_AF) AS Settlement_AF,
		(Settlement_Ff) AS Settlement_Ff,
		(Provider_Billing) as Client_Fee
		FROM tblcase C
    INNER JOIN tblProvider P ON P.Provider_Id = C.Provider_Id
    INNER JOIN tblInsuranceCompany I on I.InsuranceCompany_Id = C.InsuranceCompany_Id
    INNER JOIN Tblsettlements S ON  S.Case_Id =C.Case_Id
    LEFT OUTER JOIN tblSettlement_Type ST ON ST.SettlementType_Id = Settled_Type
    WHERE C.CASE_ID=@Case_Id
    
    --payment--
    SELECT Distinct DATENAME(DAY, Transactions_Date) + ' '+DATENAME(MONTH, Transactions_Date) + ' ' +  Convert(varchar(10),YEAR(Transactions_Date)) AS 	Transactions_Date,C.Case_Id,
		CONVERT(VARCHAR(7), Transactions_Date, 120) AS [Settlement_Date],
		(Invoice_Id) AS Invoice_Id,
		(Transactions_Amount) AS Transactions_Amount,
		Transactions_Type
	  FROM  tblTransactions 
	  INNER JOIN  tblcase C on C.Case_Id = tblTransactions.Case_Id
	  INNER JOIN tblProvider P ON P.Provider_Id = C.Provider_Id
  	WHERE C.Case_Id=@Case_Id
	  GROUP BY Transactions_Date ,Transactions_Id,Invoice_Id,Transactions_Amount,Transactions_Type,C.Case_Id
	  ORDER BY Transactions_Date desc

END

