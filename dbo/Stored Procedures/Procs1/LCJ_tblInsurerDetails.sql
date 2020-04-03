CREATE PROCEDURE [dbo].[LCJ_tblInsurerDetails]
	
	(
		@Insurer_Id NVARCHAR(100)
		
	)

AS

BEGIN

	SELECT    *
	FROM        tblInsurer
	WHERE    Insurer_Id = @Insurer_Id

END

