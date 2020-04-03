
CREATE PROCEDURE [dbo].[Bulk_Update_Index_Number_and_status]
(
@tblExcelCases	dbo.UDT_CaseNumber READONLY
,@status varchar(100)
,@DomainID varchar(50)
)
AS
BEGIN


SELECT * into #temp FROM @tblExcelCases

select Case_Id into #temp2 from tblcase (nolock) where DomainId=@DomainID

select t1.Case_Id,t1.Case_Number into #tempExists
from #temp t1 (nolock)
join  tblcase t2(nolock) on t1.Case_Id=t2.Case_Id
where isnull(t2.IndexOrAAA_Number,'')<>''

select t1.Case_Id,t1.Case_Number
from #temp t1 (nolock)
where t1.Case_Id not in(select t2.Case_Id from #temp2 t2 )

insert into tblNotes (Notes_Desc,	Notes_Type,	Notes_Priority,	Case_Id,	Notes_Date,	User_Id,	DomainId)
select 'Status changed from '+t1.Status+' to '+@Status,'Activity',1,t1.Case_Id,GETDATE(),'admin',@DomainID
from tblcase t1 (nolock)
join #temp t2 (nolock) on t1.Case_Id= t2.Case_Id
where t1.DomainId=@DomainID
and isnull(t1.IndexOrAAA_Number,'')=''

DECLARE @newStatusHierarchy int
SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@status)

update t1
set t1.IndexOrAAA_Number=t2.Case_Number,
t1.Status=@status
from tblcase t1
left join tblStatus on t1.Status= tblStatus.Status_Type
join #temp t2 on t1.Case_Id= t2.Case_Id and t1.DomainId=@DomainID
where t1.DomainId=@DomainID
 and isnull(t1.IndexOrAAA_Number,'')=''
 and tblStatus.Status_Hierarchy<=@newStatusHierarchy

select t1.Case_Id,t1.Case_Number
from #temp t1 (nolock)
join tblcase t2 (nolock) on t1.Case_Id=t2.Case_Id  and t2.DomainId=@DomainID
and t2.IndexOrAAA_Number=t1.Case_Number
where t2.DomainId=@DomainID 

select * from #tempExists

update tblMailConfigartion set LastReadDate=GETDATE()-1 where SearchKeyword='initiation letters'and DomainId='AF'

end