CREATE PROCEDURE [dbo].[procInsertDesks] (
@DomainId nvarchar(50),
@CID varchar(40),
@insurancecompany_id varchar(50),
@provider_id varchar(50),
@status varchar(50)
)
as
begin
declare 
	@iid varchar(50),
	@iname varchar(150),
	@did int,
	@pid varchar(50),
	@pname varchar(100),
	@st varchar(50)

declare mycur cursor
local
for
	select a.insurancecompany_id,b.desk_name from tblinsurancecompany a inner join tbldesk b on a.insurancecompany_name=b.desk_name where a.insurancecompany_id=@insurancecompany_id and a.DomainId=@DomainId
open mycur
fetch next from mycur into @iid,@iname
while @@fetch_status = 0
begin
   select @did = desk_id from tbldesk where desk_name = @iname and DomainId=@DomainId
   print @did
   print @CID
  print '-------------------------------ins----------------------------------------------'
   exec procInsCaseDesk @case_id=@CID,@did=@did
fetch next from mycur into @iid,@iname
end
close mycur
deallocate mycur


declare mycur cursor
local
for
	select a.provider_id,b.desk_name from tblprovider a inner join tbldesk b on a.provider_name=b.desk_name where a.provider_id=@provider_id and a.DomainId=@DomainId
open mycur
fetch next from mycur into @pid,@pname
while @@fetch_status = 0
begin
   select @did = desk_id from tbldesk where desk_name = @pname and DomainId=@DomainId
   exec procInsCaseDesk @DomainId=@DomainId, @case_id=@CID,@did=@did
   print @did
   print @CID
  print '-------------------------------provider----------------------------------------------'
fetch next from mycur into @pid,@pname
end
close mycur
deallocate mycur


declare mycur cursor
local
for
	select a.status_type from tblstatus a inner join tbldesk b on a.status_type=b.desk_name where a.status_abr=@st
open mycur
fetch next from mycur into @st
while @@fetch_status = 0
begin
   select @did = desk_id from tbldesk where desk_name = @st
   exec procInsCaseDesk @DomainId=@DomainId,@Case_Id=@CID,@did=@did
   print @did
   print @CID
  print '------------------------------status---------------------------------------------'
fetch next from mycur into @st
end
close mycur
deallocate mycur

end

