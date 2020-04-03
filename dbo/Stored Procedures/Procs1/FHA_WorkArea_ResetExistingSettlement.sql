CREATE PROCEDURE [dbo].[FHA_WorkArea_ResetExistingSettlement]
(
@settlementId NVARCHAR(200)
)
AS
BEGIN
	DELETE FROM tblSettlements where Settlement_Id = @settlementId
	DELETE FROM tbl_treatment_settled WHERE Settlementid = @settlementId
END

