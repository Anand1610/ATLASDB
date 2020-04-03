CREATE PROCEDURE [dbo].[LCJ_RemoveCaseFromGroup](
@Case_Id varchar(50)
)
as
begin
exec LCJ_procRemoveGroupCase @Case_id  = @Case_Id
update tblCase set Group_Id=0 where Case_Id=@Case_Id
end

