CREATE PROCEDURE [dbo].[tickets_sp_add_ticket_thread]
	@bg_ticket_id BIGINT,
	@sz_description NVARCHAR(MAX),
	@sz_status_code CHAR(3)
AS
BEGIN
	DECLARE @i_status_id INT
	SET @i_status_id = (SELECT i_status_id FROM mst_ticket_status WHERE sz_status_code = @sz_status_code)
	
	DECLARE @sz_ticket_number NVARCHAR(255)
	DECLARE @sz_replied_by NVARCHAR(255)
	SELECT @sz_ticket_number=sz_ticket_number , @sz_replied_by = sz_raised_by
		FROM mst_ticket WHERE bg_ticket_id = @bg_ticket_id
	
	INSERT INTO	txn_ticket_thread(bg_ticket_id,i_status_id,sz_description,sz_ticket_number,dt_raised_on,sz_replied_by)
		VALUES (@bg_ticket_id,@i_status_id,@sz_description,@sz_ticket_number,DEFAULT,@sz_replied_by)

	UPDATE mst_ticket
	SET dt_last_activity = GETDATE(), i_status_id = @i_status_id
	WHERE bg_ticket_id = @bg_ticket_id
END
