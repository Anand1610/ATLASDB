
CREATE PROCEDURE [dbo].[ChangeBillStatusToImported]
(
@BillNumbers [BillDetails]  READONLY
)
AS
BEGIN

UPDATE tbltreatment 
SET DocumentStatus = 'Imported'
FROM tbltreatment t
INNER JOIN @BillNumbers b ON b.CaseId = t.Case_Id 
AND	b.BillNumber = t.BILL_NUMBER AND b.DomainId = t.DomainId


END

