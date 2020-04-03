CREATE PROCEDURE [dbo].[tickets_sp_search_trouble_tickets]
	@sz_ticket_number nvarchar(255)
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
		t3.sz_company_id [CompanyID]
	FROM 
		mst_ticket t1
		JOIN mst_ticket_status t2 ON t1.i_status_id = t2.i_status_id
		JOIN mst_billing_company t3 on t3.sz_company_id = t1.sz_company_id
	WHERE
		t1.sz_ticket_number = @sz_ticket_number
	ORDER BY dt_raised_on DESC
END
