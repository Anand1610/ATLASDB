CREATE PROCEDURE [dbo].[F_DDL_Settlement_Type]
AS
BEGIN
    SELECT 0 AS SettlementType_Id,'...Select...' AS Settlement_Type
UNION
	SELECT   DISTINCT SettlementType_Id,Settlement_Type
	FROM         tblSettlement_Type
	WHERE     (1 = 1) order by Settlement_Type
END

