CREATE PROCEDURE [dbo].[SP_SCHEDULER_STATUS_UPDATE]
@DomainId VARCHAR(50)
AS
BEGIN

DECLARE @CASE_ID AS VARCHAR(100)
DECLARE @DATE_STATUS_CHANGED AS DATETIME
DECLARE CASE_CURSOR CURSOR FOR
SELECT CASE_ID,DATE_CHANGED FROM MST_STATUS_LOG 
WHERE STATUS_BIT = 1

OPEN CASE_CURSOR
FETCH NEXT FROM CASE_CURSOR
INTO @CASE_ID,@DATE_STATUS_CHANGED

WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE @oldStatusHierarchy int
DECLARE @newStatusHierarchy int
DECLARE @old_status VARCHAR(100)
	IF DATEDIFF(DD,@DATE_STATUS_CHANGED,getdate())>=21
	BEGIN
		print(@CASE_ID)
		SET @old_status=(SELECT Status FROM tblcase WHERE Case_Id=@case_id)
		SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@old_status)
		SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='OPEN 2')
		
   if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
		BEGIN
			UPDATE TBLCASE SET STATUS='OPEN 2' WHERE CASE_ID=@CASE_ID
		END

		UPDATE MST_STATUS_LOG SET STATUS_BIT = 0,DATE_CHANGED=getdate() WHERE CASE_ID=@CASE_ID and DomainId=@DomainId
	Insert into tblNotes (Notes_Desc,	Notes_Type,	Notes_Priority,	Case_Id,	Notes_Date,	User_Id,	DomainId)
	values ('Requested documentation not received within 21 days','Activity',0,@CASE_ID,getdate(),'system',@DomainId)
	END

	FETCH NEXT FROM CASE_CURSOR INTO @CASE_ID,@DATE_STATUS_CHANGED
END
CLOSE CASE_CURSOR
DEALLOCATE CASE_CURSOR

END

