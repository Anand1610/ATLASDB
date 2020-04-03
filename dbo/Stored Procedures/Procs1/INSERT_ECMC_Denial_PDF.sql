CREATE PROCEDURE [dbo].[INSERT_ECMC_Denial_PDF]
	@Case_Id VARCHAR(50),
	@FileName VARCHAR(MAX),
	@Page_No INT
AS
BEGIN
	INSERT INTO ECMC_Denial_PDF
	(Case_Id,FileName,Page_No)
	VALUES
	(@Case_Id,@FileName,@Page_No)
END

