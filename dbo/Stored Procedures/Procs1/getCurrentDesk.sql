CREATE PROCEDURE [dbo].[getCurrentDesk](
@Case_Id varchar(40)
)
as
select b.[Desk_Name] from tblCaseDesk a inner join tbldesk b on a.desk_id=b.desk_id inner join IssueTracker_Users c on b.Desk_Name=c.UserName where a.Case_Id =@Case_Id

