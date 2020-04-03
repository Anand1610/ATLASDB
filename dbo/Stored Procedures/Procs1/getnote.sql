CREATE PROCEDURE [dbo].[getnote](
@cid varchar(50)
)
as
begin
select * from tblnotes where case_id=@cid
end

