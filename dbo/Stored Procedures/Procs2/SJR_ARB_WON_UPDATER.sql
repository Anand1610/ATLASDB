CREATE PROCEDURE [dbo].[SJR_ARB_WON_UPDATER]
AS
BEGIN


declare @case_id varchar(50)

declare oxcur cursor
for
select case_id from tblcase
WHERE DateFile_Trial_DeNovo = GETDATE() AND Status='ARB WON-NOTICE OF ENTRY'

open oxcur 

fetch next from oxcur into @case_id
while @@FETCH_STATUS=0
begin

DECLARE @oldStatusHierarchy int
DECLARE @newStatusHierarchy int
DECLARE @DomainID VARCHAR(10)
DECLARE @OLD_STATUS VARCHAR(100)

		SET @DomainID=(SELECT DomainId FROM tblcase WHERE Case_Id=@case_id)
		SET @OLD_STATUS=(SELECT Status FROM tblcase WHERE Case_Id=@case_id )
		SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@OLD_STATUS)
		SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='ARB WON-FLAG FOR JUDGMENT')


if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
BEGIN
update tblcase
SET STATUS='ARB WON-FLAG FOR JUDGMENT',Last_Status='ARB WON-NOTICE OF ENTRY'
where Case_Id =@case_id

exec LCJ_AddNotes @case_id=@case_id,@notes_type='Activity' ,@NDesc='Status changed to ARB WON-FLAG FOR JUDGMENT by system.>>>' ,@user_id='system',@applytogroup=0

end
ELSE
BEGIN

DECLARE @DEC VARCHAR(500)='Can not change the status from '+@OLD_STATUS+' to '+'ARB WON-FLAG FOR JUDGMENT'
exec LCJ_AddNotes @case_id=@case_id,@notes_type='Activity' ,@NDesc=@DEC ,@user_id='system',@applytogroup=0
END




fetch next from oxcur into @case_id

end

close oxcur
deallocate oxcur

END

