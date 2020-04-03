CREATE PROCEDURE [dbo].[procUpdatePrintFlag]
as 
begin
Select distinct * from LCJ_VW_CASESEARCHDETAILS WHERE case_id in (select case_id from tbltobeprinted_MOTIONS where printed=0) order by indexorAAA_number asc
update tbltobeprinted_MOTIONS set printed=1 where case_id in (select case_id from tbltobeprinted_MOTIONS where printed=0) 
end

