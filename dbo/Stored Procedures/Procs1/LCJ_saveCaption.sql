CREATE PROCEDURE [dbo].[LCJ_saveCaption](
@cid varchar(50),
@caption nvarchar(3000)
)
as
begin
declare
@gid int
select @gid = group_id from tblcase where case_id=@cid
if @gid <> 0
update tblcase set caption = @caption where group_id=@gid 
else
update tblcase set caption = @caption where case_id=@cid
end

