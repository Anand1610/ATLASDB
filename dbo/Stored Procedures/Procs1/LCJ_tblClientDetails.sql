CREATE PROCEDURE [dbo].[LCJ_tblClientDetails]
	
	(
		@Client_Id NVARCHAR(100)
		
	)

AS

BEGIN

	SELECT    *
	FROM        tblClient
	WHERE    Client_Id = @Client_Id

END

