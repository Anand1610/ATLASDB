CREATE PROCEDURE [dbo].[procUserDesk] as
begin
select  Upper(a.Desk_Name),a.desk_id from tbldesk a inner join IssueTracker_Users b on a.Desk_Name = b.UserName order by a.Desk_Name asc
end

