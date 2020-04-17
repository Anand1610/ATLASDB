CREATE PROCEDURE [dbo].[INSERT_TXN_LIST_EMAIL_FILES] --[INSERT_TXN_LIST_EMAIL_FILES] 7
	@DomainId NVARCHAR(50),
	@IMAGEID VARCHAR(500)
AS
BEGIN

	DECLARE @BASEFOLDER AS VARCHAR(5000)
	DECLARE @SZ_FILENAME AS VARCHAR(1000)
	DECLARE @SZ_FILEPATH AS VARCHAR(MAX)

	SELECT @BASEFOLDER=PARAMETERVALUE FROM dbo.tblApplicationSettings  WHERE PARAMETERNAME='DocumentUploadLocationPhysical' and DomainId=@DomainId
	SELECT @SZ_FILENAME = FILENAME FROM tblDocImages  WHERE IMAGEID = @IMAGEID and DomainId=@DomainId
	---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
    AND IsDeleted=0  
    ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
	SELECT @SZ_FILEPATH = @BASEFOLDER+FILEPATH + FILENAME FROM tblDocImages  WHERE IMAGEID=@IMAGEID and DomainId=@DomainId
	---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
    AND IsDeleted=0  
    ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  

	INSERT INTO TXN_LIST_EMAIL_FILES 
	(
		SZ_IMAGEID,
		SZ_FILENAME,
		SZ_FILEPATH,
		DomainId
	)
	VALUES
	(
		@IMAGEID,
		@SZ_FILENAME,
		@SZ_FILEPATH,
		@DomainId
	)
END

