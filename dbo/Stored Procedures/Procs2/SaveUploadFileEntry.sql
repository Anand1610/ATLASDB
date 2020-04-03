CREATE PROCEDURE [dbo].[SaveUploadFileEntry]
(
	@SZ_PROVIDER_ID AS NVARCHAR(20),
	@SZ_DOCUMENT_ID AS NVARCHAR(10),
	@SZ_IMAGE_NAME AS NVARCHAR(100),
	@SZ_IMAGE_PATH AS NVARCHAR(250),
	@SZ_USER_NAME AS NVARCHAR(20)

)
AS
BEGIN

	DECLARE @SZ_CASE_ID AS NVARCHAR(20)
	DECLARE @RecordDescriptor AS NVARCHAR(10)
	SET @RecordDescriptor = ''

	DECLARE curInsertImage CURSOR 
	LOCAL forward_only dynamic scroll_locks 

	FOR SELECT CASE_ID FROM TBLCASE
			           WHERE PROVIDER_ID = @SZ_PROVIDER_ID

	OPEN curInsertImage
	
	FETCH NEXT FROM curInsertImage INTO @SZ_CASE_ID

	WHILE @@FETCH_STATUS = 0
		  BEGIN
			insert into tblImages(ImagePath,Filename,DocumentID,Case_Id,ScanDate,UserId,RecordDescriptor)
			values(@SZ_IMAGE_PATH,@SZ_IMAGE_NAME,@SZ_DOCUMENT_ID,@SZ_CASE_ID,getdate(),@SZ_USER_NAME,@RecordDescriptor)
			FETCH NEXT FROM curInsertImage INTO @SZ_CASE_ID
		  END

	CLOSE curInsertImage
	DEALLOCATE curInsertImage

END

