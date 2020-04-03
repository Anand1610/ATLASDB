
CREATE PROCEDURE [dbo].[tickets_sp_get_trouble_tickets_for_status]
	@sz_status_code CHAR(3)
AS
BEGIN
	SELECT 
		bg_ticket_id [TicketID],
		sz_ticket_number [TicketNumber],
		sz_raised_by [RaisedBy],
		dt_raised_on [RaisedOn],
		sz_subject [Subject],
		dt_last_activity [LastActivity],
		t2.i_status_id [StatusID],
		t2.sz_status [Status],
		t1.sz_description [Description],
		sz_company_id [CompanyID]
	FROM 
		mst_ticket t1
		JOIN mst_ticket_status t2 ON t1.i_status_id = t2.i_status_id
	WHERE
		t2.sz_status_code = @sz_status_code
	ORDER BY 
		dt_raised_on DESC
END
