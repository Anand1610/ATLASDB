CREATE PROCEDURE [dbo].[LCJ_getGroupCases](
@Case_Id varchar(50)
)
as
begin
select case_id,group_id from tblcase where group_id in (select group_id from tblcase where case_id=@case_id and group_id > 0) 
end

