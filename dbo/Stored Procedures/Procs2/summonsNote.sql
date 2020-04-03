CREATE PROCEDURE [dbo].[summonsNote]--'FH07-42372'
@cid varchar(50)

as
begin

--insert into tblnotes
--select 'Summons Printed','A',0,@cid,getdate(),'system' from tblnotes a 
--where case_id not in (select case_id from tblnotes b where notes_Desc='Summons Printed' and b.case_id=a.case_id)
--IF EXISTS(SELECT TOP 1 1 FROM TBLCASE WHERE CASE_ID=@cid AND date_summons_printed is null)
--BEGIN
--	exec SP_ASSIGN_REDCAT_DENIAL_REASONS @CASE_ID=@cid
--END
DECLARE @oldStatusHierarchy int
DECLARE @newStatusHierarchy int
DECLARE @old_status VARCHAR(100)
DECLARE @DomainID VARCHAR(100)

	    SELECT @old_status=Status,@DomainID=DomainId FROM tblcase WHERE Case_Id=@cid
		SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@old_status)
		SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='SUMMONS-PRINTED')
		if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
		BEGIN
				update tblcase 
				set status='SUMMONS-PRINTED' 
				where  case_id=@cid
		END

update tblcase 
set date_summons_printed = getdate()
where date_summons_printed is null and case_id=@cid



--return 1 
end

