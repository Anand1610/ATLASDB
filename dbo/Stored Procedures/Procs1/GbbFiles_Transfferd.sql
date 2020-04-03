

-- DROP PROCEDURE [dbo].[GbbFiles_Transfferd]

CREATE PROCEDURE [dbo].[GbbFiles_Transfferd]
(
	@Path  VARCHAR(2000),
	@NodeType  VARCHAR(50),
	@BasePathId int,
	@TransferFilePath  VARCHAR(2000),
	@BillNumber VARCHAR(50),
	@Gbb_Type VARCHAR(50)
)
AS
BEGIN

	INSERT INTO tblGbbDocuments_transfferd(Path, NodeType, BasePathId, TransferFilePath, BillNumber, Gbb_Type, Trnasfferd_Date)
	 VALUES(@Path, @NodeType, @BasePathId, @TransferFilePath, @BillNumber, @Gbb_Type, GETDATE())


END

