-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[F_Report_Collection_OverDue]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	CREATE TABLE #tempCollection
	(
		Case_Id VARCHAR(100),
		InsuranceCompany_Name VARCHAR(1000),	
		Status	VARCHAR(200),
		Provider_name	 VARCHAR(1000),
		Patient	VARCHAR(500),
		Settlement_Total money,
		Settlement_Amount money,
		Settlement_Int	money,
		Settlement_Af	money,
		Settlement_Ff money,
		Transactions_Amount money,
		Outstanding_Amount	money,
		Settlement_Date DATETIME,
		OVERDUE_DAY	INT,
		Transactions_C money,
		Transactions_I money,
		Transactions_FF money,
		Transactions_AF money,
		Transactions_C_Date DATETIME,
		Transactions_I_Date DATETIME,
		Transactions_FF_Date DATETIME,
		Transactions_AF_Date DATETIME,
		
	)
	
	INSERT INTO #tempCollection
	(
		Case_Id,
		InsuranceCompany_Name,	
		Status,
		Provider_name,
		Patient,
		Settlement_Total,
		Settlement_Amount,
		Settlement_Int,
		Settlement_Af,
		Settlement_Ff,
		Transactions_Amount,
		Outstanding_Amount,
		Settlement_Date,
		OVERDUE_DAY
	)
    select Distinct C.Case_Id, 
	InsuranceCompany_Name,
	Status,
	Provider_name,
	InjuredParty_LastName +' '+ InjuredParty_FirstName AS patient,
	Max(Settlement_Total) as Settlement_Total,
	Max(Settlement_Amount) as Settlement_Amount,
	Max(Settlement_Int) as Settlement_Int,
	Max(Settlement_Af) as Settlement_Af,
	Max(Settlement_Ff) as Settlement_Ff,
	ISNULL(SUM(Transactions_Amount),0) as Transactions_Amount,
	ISNULL(Max(Settlement_Total),0)- ISNULL(Sum(Transactions_Amount),0) as Outstanding_Amount,
	Min(Settlement_Date) as Settlement_Date,
	DATEDIFF(DD,min(Settlement_Date),GETDATE()) AS OVERDUE_DAY
	FROM tblCase C
	INNER JOIN  tblSettlements S on S.Case_Id =C.Case_Id
	INNER JOIN TblProvider P on P.Provider_Id = C.Provider_Id
	INNER JOIN tblInsuranceCompany I on I.InsuranceCompany_Id = C.InsuranceCompany_Id
	LEFT OUTER JOIN tbltransactions T on T.Case_id = S.Case_Id and T.Transactions_Type <> 'FFB' 
	WHERE status like  '%COLLECTION%'
	GROUP BY C.Case_Id,InsuranceCompany_Name,Status,Provider_name,InjuredParty_LastName,InjuredParty_FirstName
	Having ISNULL(Max(Settlement_Total),0)- ISNULL(Sum(Transactions_Amount),0) > 0 
	and DATEDIFF(DD,min(Settlement_Date),GETDATE()) > 45
	order by min(Settlement_Date) desc
	
	
	
	UPDATE  #tempCollection
	SET Transactions_C = T_Amount, Transactions_C_Date= T_Date
	FROM #tempCollection
	INNER JOIN 
	(SELECT Distinct TR.Case_Id AS T_Case_ID,SUM(TR.Transactions_Amount) AS T_Amount,MAX(Transactions_Date) AS T_Date from  #tempCollection temp
	INNER JOIN tblTransactions TR ON temp.Case_Id= TR.Case_Id
	WHERE Transactions_Type = 'C'
	GROUP by TR.Case_Id) A On Case_Id=T_Case_ID
	
	
	UPDATE  #tempCollection
	SET Transactions_I = T_Amount, Transactions_I_Date= T_Date
	FROM #tempCollection
	INNER JOIN 
	(SELECT Distinct TR.Case_Id AS T_Case_ID,SUM(TR.Transactions_Amount) AS T_Amount,MAX(Transactions_Date) AS T_Date from  #tempCollection temp
	INNER JOIN tblTransactions TR ON temp.Case_Id= TR.Case_Id
	WHERE Transactions_Type = 'I'
	GROUP by TR.Case_Id) A On Case_Id=T_Case_ID
	
	
	UPDATE  #tempCollection
	SET Transactions_AF = T_Amount, Transactions_AF_Date= T_Date
	FROM #tempCollection
	INNER JOIN 
	(SELECT Distinct TR.Case_Id AS T_Case_ID,SUM(TR.Transactions_Amount) AS T_Amount,MAX(Transactions_Date) AS T_Date from  #tempCollection temp
	INNER JOIN tblTransactions TR ON temp.Case_Id= TR.Case_Id
	WHERE Transactions_Type = 'AF'
	GROUP by TR.Case_Id) A On Case_Id=T_Case_ID
	
	
	UPDATE  #tempCollection
	SET Transactions_FF = T_Amount, Transactions_FF_Date= T_Date
	FROM #tempCollection
	INNER JOIN 
	(SELECT Distinct TR.Case_Id AS T_Case_ID,SUM(TR.Transactions_Amount) AS T_Amount,MAX(Transactions_Date) AS T_Date from  #tempCollection temp
	INNER JOIN tblTransactions TR ON temp.Case_Id= TR.Case_Id
	WHERE Transactions_Type = 'FFC'
	GROUP by TR.Case_Id) A On Case_Id=T_Case_ID
	
	
	SELECT Case_Id ,
		InsuranceCompany_Name,	
		Status,
		Provider_name	,
		Patient	,
		ISNULL(Settlement_Total,0) AS Settlement_Total,
		ISNULL(Settlement_Amount,0) AS Settlement_Amount,
		ISNULL(Settlement_Int,0)	AS Settlement_Int,
		ISNULL(Settlement_Af,0)	AS Settlement_Af,
		ISNULL(Settlement_Ff,0) AS Settlement_Ff,
		ISNULL(Transactions_Amount,0) AS Transactions_Amount,
		ISNULL(Outstanding_Amount,0)	AS Outstanding_Amount,
		CONVERT(VARCHAR(10),Settlement_Date,101)  as Settlement_Date,
		OVERDUE_DAY	,
		ISNULL(Transactions_C,0) AS Transactions_C,
		ISNULL(Transactions_I,0) AS Transactions_I,
		ISNULL(Transactions_FF,0) AS Transactions_FF,
		ISNULL(Transactions_AF,0) AS Transactions_AF,
		CONVERT(VARCHAR(10),Transactions_C_Date,101) as Transactions_C_Date ,
		CONVERT(VARCHAR(10),Transactions_I_Date,101) as  Transactions_I_Date,
		CONVERT(VARCHAR(10),Transactions_FF_Date,101) as Transactions_FF_Date,
		CONVERT(VARCHAR(10),Transactions_AF_Date ,101) as Transactions_AF_Date
		
		 FROM #tempCollection
END

