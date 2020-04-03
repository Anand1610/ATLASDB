CREATE PROCEDURE [dbo].[deletepopupnote](
@nid int
)
as
begin

delete from tblnotes where notes_id=@nid

end

