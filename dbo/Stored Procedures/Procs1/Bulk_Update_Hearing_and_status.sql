
--drop PROCEDURE Bulk_Update_Hearing_and_status
CREATE PROCEDURE [dbo].[Bulk_Update_Hearing_and_status]
(
@tblExcelCases	dbo.ut_bulck_hearing READONLY
,@status varchar(100)
,@DomainID varchar(50)
)
AS
BEGIN


SELECT * into #temp FROM @tblExcelCases

select Case_Id into #temp2 from tblcase (nolock) where DomainId=@DomainID
select case_id ,max(Event_Date)[Event_Date] into #tempevent from tblEvent where DomainId=@DomainID group by  case_id

print ('invalid')
select t1.CaseID,t1.HearingDate
from #temp t1 (nolock)
where t1.CaseID not in(select t2.Case_Id from #temp2 t2 )

print ('inserte into notes which dont have any hearing ')
insert into tblNotes (Notes_Desc,	Notes_Type,	Notes_Priority,	Case_Id,	Notes_Date,	User_Id,	DomainId)
select 'Status changed from '+t1.Status+' to '+@Status,'Activity',1,t1.Case_Id,GETDATE(),'admin',@DomainID
from tblcase t1 (nolock)
join #temp t2 (nolock) on t1.Case_Id= t2.CaseID
where t1.DomainId=@DomainID 
and t1.Case_Id not in(select Case_Id from  #tempevent where isnull(Case_Id,'')<>'' )

DECLARE @newStatusHierarchy int=0
SET @newStatusHierarchy =(Select  isnull(Status_Hierarchy,0) from  tblStatus where  DomainID =@DomainID and Status_Type=@status)


print ('update status which dont have any hearing ')	
update t1
set 
t1.Status=@status
from tblcase t1
join #temp t2 on t1.Case_Id= t2.CaseID
left join tblStatus on t1.Status= tblStatus.Status_Type
where t1.DomainId=@DomainID    
and t1.Case_Id not in(select Case_Id from #tempevent where isnull(Case_Id,'')<>'' )
and isnull(tblStatus.Status_Hierarchy,0)<=@newStatusHierarchy

DECLARE @EventType int,@EventStatus int

select @EventStatus= EventStatusId from tblEventStatus where DomainId=@DomainID and EventStatusName= 'AAA Hearing Set'

select @EventType=EventTypeId from tblEventType  where DomainId=@DomainID and EventTypeName= 'AAA Arbitration'


print ('insert  event  which dont have any hearing ')
INSERT INTO tblEvent(Case_id,EventTypeId,EventStatusId,Event_Date,Event_Time,Event_Notes,Assigned_To,User_id,DomainId)
SELECT CASEID,@EventType,@EventStatus,HearingDate,HearingTime,Notes,'admin','admin',@DomainID
from tblcase t1
join #temp t2 on t1.Case_Id= t2.CaseID and t1.DomainId=@DomainID
where t1.DomainId=@DomainID and   t1.Case_Id not in(select Case_Id from #tempevent where isnull(Case_Id,'')<>'' )


	

print 'notes for 2nd time'	
insert into tblNotes (Notes_Desc,	Notes_Type,	Notes_Priority,	Case_Id,	Notes_Date,	User_Id,	DomainId)
select 'Status changed from '+t1.Status+' to '+@Status,'Activity',1,t1.Case_Id,GETDATE(),'admin',@DomainID
from tblcase t1 (nolock)
join #temp t2 (nolock) on t1.Case_Id= t2.CaseID
join #tempevent t3 on t3.Case_id=t2.CaseID and convert(date,t3.Event_Date)<>convert(date,t2.HearingDate)
where t1.DomainId=@DomainID


print 'update status for 2nd time'	
update t1
set 
t1.Status=@status
from tblcase t1
join #temp t2 on t1.Case_Id= t2.CaseID
join #tempevent t3 on t3.Case_id=t2.CaseID and convert(date,t3.Event_Date)<>convert(date,t2.HearingDate)
left join tblStatus on t1.Status= tblStatus.Status_Type
where t1.DomainId=@DomainID    
and isnull(tblStatus.Status_Hierarchy,0)<=@newStatusHierarchy

print 'insert  event for 2nd time'	

INSERT INTO tblEvent(Case_id,EventTypeId,EventStatusId,Event_Date,Event_Time,Event_Notes,Assigned_To,User_id,DomainId)
SELECT CASEID,@EventType,@EventStatus,HearingDate,HearingTime,Notes,'admin','admin',@DomainID
from tblcase t1
join #temp t2 on t1.Case_Id= t2.CaseID and t1.DomainId=@DomainID
join #tempevent t3 on t3.Case_id=t2.CaseID and convert(date,t3.Event_Date)<>convert(date,t2.HearingDate)
where t1.DomainId=@DomainID 




print 'updated cases'	

SELECT CASEID,HearingDate,HearingTime,Notes,'admin'[Assignto],'admin'[User],@DomainID
from tblcase t1
join #temp t2 on t1.Case_Id= t2.CaseID and t1.DomainId=@DomainID
where t1.DomainId=@DomainID and t1.Status='AAA - HEARING DATE RECEIVED - GB'

update tblMailConfigartion set LastReadDate=GETDATE()-2 where SearchKeyword='Hearing Dates'and DomainId='AF'


end