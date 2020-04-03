


-- DROP PROCEDURE [dbo].[GbbFiles]

CREATE PROCEDURE [dbo].[GbbFiles]
(
	@BillDocs [BillDocumentDetailsDetails]  READONLY,
	@BillNumber VARCHAR(50),
	@Gbb_Type VARCHAR(50)
)
AS
BEGIN

			INSERT INTO tblGbbDocuments(FileName,	Path,	NodeType,	BasePathId,	BaseFilePath, BasePathType, BillNumber, Gbb_Type)
			SELECT *,@BillNumber,@Gbb_Type FROM @BillDocs WHERE path NOT IN (SELECT path from tblGbbDocuments WHERE BillNumber = @BillNumber AND Gbb_Type= @Gbb_Type)

			UPDATE tbltreatment 
			SET DocumentStatus = 'Imported'
			WHERE BILL_NUMBER =  @BillNumber 

END


