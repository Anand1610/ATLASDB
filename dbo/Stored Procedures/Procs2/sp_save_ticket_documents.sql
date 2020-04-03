
CREATE PROCEDURE [dbo].[sp_save_ticket_documents]
@sz_ticket_number nvarchar(40),
@sz_file_name nvarchar(40),
@sz_file_path nvarchar(max)
as
begin
	declare @bg_ticket_id bigint
	set @bg_ticket_id=(select bg_ticket_id from mst_ticket where sz_ticket_number=@sz_ticket_number)
	insert into txn_ticket_documents(bg_ticket_id,sz_ticket_number,sz_file_name,sz_file_path)
	values(@bg_ticket_id,@sz_ticket_number,@sz_file_name,@sz_file_path)
end

