
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LCJ_GETCLIENTSUMMERYPAYMENTREPORT]  
	-- Add the parameters for the stored procedure here
	@DomainId NVARCHAR(50),
	@Client_id nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 'Voluntary' AS SummaryType,
	ISNULL((Select SUM(A.Transactions_Amount ) from tbltransactions (NOLOCK) A INNER JOIN  tblcase (NOLOCK) B ON A.Case_Id = B.Case_Id WHERE B.Provider_Id = @Client_id AND  (A.Transactions_status IS NULL or A.Transactions_status = 'CONFIRMED')   and B.DomainId=@DomainId AND Transactions_Type='PreC'),0.00) AS Principal,
	ISNULL((Select SUM(A.Transactions_Amount)  from tbltransactions (NOLOCK) A INNER JOIN tblcase (NOLOCK) B ON A.Case_Id = B.Case_Id WHERE B.Provider_Id = @Client_id AND  (A.Transactions_status IS NULL or A.Transactions_status = 'CONFIRMED')  and B.DomainId=@DomainId AND Transactions_Type IN ('PreI')),0.00) AS Intrest
	UNION
	SELECT 'Voluntary (Direct)' AS SummaryType,
	ISNULL((Select SUM(A.Transactions_Amount)  from tbltransactions (NOLOCK) A INNER JOIN tblcase (NOLOCK) B ON A.Case_Id = B.Case_Id WHERE B.Provider_Id = @Client_id AND  (A.Transactions_status IS NULL or A.Transactions_status = 'CONFIRMED') and B.DomainId=@DomainId AND Transactions_Type='PreCToP'),0.00) AS Principal,
	ISNULL((Select SUM(A.Transactions_Amount)  from tbltransactions (NOLOCK) A INNER JOIN tblcase (NOLOCK) B ON A.Case_Id = B.Case_Id WHERE B.Provider_Id = @Client_id AND  (A.Transactions_status IS NULL or A.Transactions_status = 'CONFIRMED')  and B.DomainId=@DomainId AND Transactions_Type IN ('ID')),0.00) AS Intrest
	UNION
	SELECT 'Settlement' AS SummaryType,
	ISNULL((Select SUM(A.Transactions_Amount ) from tbltransactions (NOLOCK) A INNER JOIN tblcase (NOLOCK) B ON A.Case_Id = B.Case_Id INNER join tblSettlements (NOLOCK) Sett ON A.Case_Id=Sett.Case_Id INNER JOIN tblSettlement_Type (NOLOCK) Set_Ty ON Sett.Settled_Type=Set_Ty.SettlementType_Id  WHERE B.Provider_Id = @Client_id AND  (A.Transactions_status IS NULL or A.Transactions_status = 'CONFIRMED')  and B.DomainId=@DomainId AND Transactions_Type='C' AND Set_Ty.Settlement_Type IN ('Settled/Court','Settled/Phone')),0.00) AS Principal,
	ISNULL((Select SUM(A.Transactions_Amount ) from tbltransactions (NOLOCK) A INNER JOIN tblcase (NOLOCK) B ON A.Case_Id = B.Case_Id INNER join tblSettlements (NOLOCK) Sett ON A.Case_Id=Sett.Case_Id INNER JOIN tblSettlement_Type (NOLOCK) Set_Ty ON Sett.Settled_Type=Set_Ty.SettlementType_Id  WHERE B.Provider_Id = @Client_id AND  (A.Transactions_status IS NULL or A.Transactions_status = 'CONFIRMED') and B.DomainId=@DomainId AND Transactions_Type='I' AND Set_Ty.Settlement_Type IN ('Settled/Court','Settled/Phone')),0.00) AS Intrest
	UNION
	SELECT 'Awarded' AS SummaryType,
	ISNULL((Select SUM(A.Transactions_Amount ) from tbltransactions (NOLOCK) A INNER JOIN tblcase (NOLOCK) B ON A.Case_Id = B.Case_Id INNER join tblSettlements (NOLOCK) Sett ON A.Case_Id=Sett.Case_Id INNER JOIN tblSettlement_Type (NOLOCK) Set_Ty ON Sett.Settled_Type=Set_Ty.SettlementType_Id  WHERE B.Provider_Id = @Client_id AND  (A.Transactions_status IS NULL or A.Transactions_status = 'CONFIRMED')  and B.DomainId=@DomainId AND Transactions_Type='C' AND Set_Ty.Settlement_Type NOT IN ('Settled/Court','Settled/Phone')),0.00) AS Principal,
	ISNULL((Select SUM(A.Transactions_Amount ) from tbltransactions (NOLOCK) A INNER JOIN tblcase (NOLOCK) B ON A.Case_Id = B.Case_Id INNER join tblSettlements (NOLOCK) Sett ON A.Case_Id=Sett.Case_Id INNER JOIN tblSettlement_Type (NOLOCK) Set_Ty ON Sett.Settled_Type=Set_Ty.SettlementType_Id  WHERE B.Provider_Id = @Client_id AND  (A.Transactions_status IS NULL or A.Transactions_status = 'CONFIRMED')  and B.DomainId=@DomainId AND Transactions_Type='I' AND Set_Ty.Settlement_Type NOT IN ('Settled/Court','Settled/Phone')),0.00) AS Intrest
END

