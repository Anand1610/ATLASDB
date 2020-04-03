CREATE PROCEDURE [dbo].[procgetDesks](
@UserName varchar(40)
)
as
begin
if @username <> ''
select a.UserName,a.Desk_id, b.Desk_Name from tbluserDesk a inner join tbldesk b on a.desk_id=b.desk_id where a.UserName=@UserName
else
select a.UserName,a.Desk_id, b.Desk_Name from tbluserDesk a inner join tbldesk b on a.desk_id=b.desk_id where a.UserName='slaxman'

end

