-- =============================================
-- Author:		Serge Rosenthal
-- ALTER date: 12/18/2007
-- Description:	Bulk Updates on Status
-- =============================================
CREATE PROCEDURE [dbo].[SJR_BulkUpdateStatus] 
	
	@Status VARCHAR(50),@Memo VARCHAR(250),@auto_bill bit,@Note_Type varchar(20)
AS
BEGIN
DECLARE @CASE_ID varchar(50),
@Old_status VARCHAR(50),
@Notes Varchar(3000),@HIERCH INT ,@provider_id int,@desc varchar(3000),
@status_bill money,
@status_bill_type VARCHAR(20),
@status_bill_notes varchar(500)


DECLARE CURSORT CURSOR
FOR SELECT     table1.case_id,tblcase.Status
FROM         table1 INNER JOIN
                      tblcase ON table1.case_id = tblcase.Case_Id

	
SET NOCOUNT ON;

SELECT     @HIERCH=Status_Hierarchy,@status_bill = auto_bill_amount ,@status_bill_type = auto_bill_type,
       @status_bill_notes=auto_bill_notes
FROM         tblStatus
WHERE     (Status_Type = @STATUS)


OPEN CURSORT
FETCH NEXT FROM CURSORT INTO @CASE_ID,@Old_Status

WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE @oldStatusHierarchy int
DECLARE @newStatusHierarchy int
DECLARE @DomainID VARCHAR(10)


		SET @DomainID=(SELECT DomainId FROM tblcase WHERE Case_Id=@case_id)
		SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@old_status)
		SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@status)
if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
BEGIN
update tblcase
set status =@STATUS,Last_Status = @old_Status,Date_Status_Changed =GETDATE()
FROM TBLCASE WHERE CASE_ID=@CASE_ID
set @Notes = 'Status changed from' + ' ' + @old_status+ ' ' + ' to'+ ' ' + @status + '. SHC Override.>> XM-004. Notes :' + @memo

EXEC [dbo].[LCJ_Addnotes] @Case_id=@Case_id,@Notes_type=@Note_Type ,@Ndesc=@Notes,@user_id='srosenthal',@ApplyToGroup='0'
--EXEC [dbo].[LCJ_Addnotes] @Case_id=@Case_id,@Notes_type='Activity',@Ndesc=@Memo,@user_id='srosenthal',@ApplyToGroup='0'

Update table1
set status = 'updated'
from table1 where case_id=@case_id
end
else
begin
DECLARE @DEC VARCHAR(500)='Can not change the status from '+@OLD_STATUS+' to '+'ARB WON-FLAG FOR JUDGMENT'
exec LCJ_AddNotes @case_id=@case_id,@notes_type='Activity' ,@NDesc=@DEC ,@user_id='system',@applytogroup=0
end
IF @HIERCH=1000
BEGIN
UPDATE TBLCASE
SET DATE_CLOSED=GETDATE()
WHERE CASE_ID=@CASE_ID
END

IF @status_bill > 0 and @auto_bill=1
BEGIN

SELECT @provider_id=tblcase.provider_id  
FROM   tblProvider INNER JOIN tblcase ON tblProvider.Provider_Id = tblcase.Provider_Id
WHERE tblcase.case_id =@case_id


INSERT INTO TBLTRANSACTIONS(CASE_ID,TRANSACTIONS_TYPE,TRANSACTIONS_DATE,TRANSACTIONS_AMOUNT,TRANSACTIONS_DESCRIPTION,PROVIDER_ID,TRANSACTIONS_FEE,USER_ID)
VALUES (@case_id,@status_bill_type,GETDATE(),@status_bill,@status_bill_notes,@PROVIDER_ID,@status_bill,'srosenthal')

set @notes = 'Payment/Transaction posted :'+ CONVERT(VARCHAR(20),@status_bill) +' '+'('+ @status_bill_type +') Desc-> ' + @status_bill_notes + '. New Status-> '+ @status + ' .' 
exec LCJ_AddNotes @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @NOTES,@user_Id='srosenthal',@ApplyToGroup = 0

END

FETCH NEXT FROM CURSORT INTO @CASE_ID,@Old_Status
END

CLOSE CURSORT
DEALLOCATE CURSORT

DELETE FROM TABLE1 WHERE STATUS ='UPDATED'
END

