CREATE PROCEDURE [dbo].[GetBatchInfo] --GetBatchInfo '06132012_3'
(
	@DomainId nvarchar(50),
   @BatchNumber nvarchar(50)
)
as
declare @provID as nvarchar(500)
declare @provName as nvarchar(2000)
declare @UserName as nvarchar(2000)
declare @UserID as nvarchar(500)
declare @DispprovID as nvarchar(500)
declare @DispprovName as nvarchar(2000)
declare @DispUserName as nvarchar(2000)
declare @DispUserID as nvarchar(500)
declare @val as int
begin
set @DispprovName=''
set @DispUserName=''
set @DispprovID=''
set @DispUserID=''
set @val=0
DECLARE cur CURSOR FOR select 'ETC' as providerId,'ETC' as Provider_Name from RelationProv_BatchNo where RelationProv_BatchNo.BatchNumber=@BatchNumber and RelationProv_BatchNo.ProviderId ='ETC'
union
select providerId,Provider_Name+Isnull('    [ '+tblProvider.Provider_GroupName + ' ]','') from tblProvider  as tblprovider inner join RelationProv_BatchNo on RelationProv_BatchNo.providerid=tblprovider.Provider_Id where RelationProv_BatchNo.BatchNumber=@BatchNumber and RelationProv_BatchNo.ProviderId <>'ETC' and tblprovider.DomainId=@DomainId
 order by Provider_Name
 OPEN cur
    Fetch from cur into @provID,@provName
     WHILE @@FETCH_STATUS = 0
Begin
if(@provName<>'ETC')
begin
       set @DispprovID=@DispprovID+@provID+' ; '   
       set @DispprovName=@DispprovName+@provName+' ; '   
End
else
       set @val=1
       FETCH NEXT FROM cur INTO @provID,@provName  
End  
close cur
Deallocate cur


DECLARE cur1 CURSOR FOR select RelationUser_BatchNo.UserId,IssueTracker_Users.UserId from RelationUser_BatchNo inner join IssueTracker_Users on RelationUser_BatchNo.UserId=IssueTracker_Users.username where BatchNumber=@BatchNumber order by RelationUser_BatchNo.UserId
 OPEN cur1
    Fetch from cur1 into @UserName,@userid
     WHILE @@FETCH_STATUS = 0
Begin
       set @DispUserID=@DispUserID+convert(nvarchar,@userid)+' ; ' 
       set @DispUserName=@DispUserName+@UserName+' ; ' 
       print @DispUserID
       print @DispUserName
       FETCH NEXT FROM cur1 INTO @UserName,@userid   
End 
close cur1
Deallocate cur1
 


--if(@provName<>'' and @UserName<>'')
--begin
select  
BatchNumber,
convert(varchar(10),DateReceived,101)as DateReceived,
--convert(varchar(10),ProcessDate,101)as ProcessDate,
SpecialNote,
SpecialInstruction,
No_Of_Cases,
case when @val=0 then @DispprovName else @DispprovName + 'ETC ; ' end as Providers,
@DispUserName as Users,
case when @val=0 then @DispprovID else @DispprovID + 'ETC ; ' end as provID,
@DispUserID as UserID,
Created_By,
Predestinated_Path
from  
tblProvListBoxDetails 
where BatchNumber=@BatchNumber 
AND DomainId = @DomainId
--end
end

