CREATE PROCEDURE[dbo].[procInsertImage]
(
@DomainId nvarchar(50),
 @mid varchar(100),
 @filename varchar(200),
 @filepath varchar(40),
 @userid varchar(40),
 @doctype varchar(40)
)
as
Begin
	declare @cid varchar(100)
	DECLARE @DESC AS VARCHAR(MAX)
	DECLARE @DOCUMENTTYPE AS VARCHAR(500)

		select @cid = case_id from tblcase  where case_id = @mid OR CASE_CODE = @mid OR CONVERT(VARCHAR,CASE_AUTOID) = @MID and DomainId=@DomainId
 		Insert into tblimages  values (@DomainId,@filepath,@filename,@doctype,@cid,getDate(),@userid,'',0)

	IF @doctype = '145'
	BEGIN

		DECLARE @DATE_STATUS_CHANGED DATETIME

		SET @DATE_STATUS_CHANGED = (SELECT top 1 DATE_CHANGED FROM TXN_ASSIGN_SETTLED_CASES  WHERE CASE_ID=@cid and isChanged=1 and DomainId=@DomainId)
		IF DATEDIFF(DD,@DATE_STATUS_CHANGED,getdate())< 3
		BEGIN
			UPDATE TXN_ASSIGN_SETTLED_CASES  SET isChanged=0, Date_Changed=getdate() where case_id=@cid and DomainId=@DomainId
		END
	END

--	SET @DOCUMENTTYPE = (SELECT Document_Type FROM TBLDOCUMENTTYPE WHERE Document_ID = @doctype)
--
--	SET @DESC = @filename + ' associated under ' + @DOCUMENTTYPE + ' at ' + @filepath
--	EXEC LCJ_AddNotes @cid,'Activity',@DESC,@userid,0

End

