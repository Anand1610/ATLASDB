CREATE PROCEDURE [dbo].[tickets_sp_get_ticket_thread]
	@bg_ticket_id BIGINT,
	@sz_company_id NVARCHAR(20)
AS
BEGIN
	SELECT 
		bg_ticket_id [TicketID],
		sz_ticket_number [TicketNumber],
		sz_replied_by AS [RaisedBy],
		t1.dt_raised_on [RaisedOn],
		[Subject]=(SELECT TOP 1 sz_subject FROM mst_ticket WHERE bg_ticket_id = @bg_ticket_id),
		NULL [LastActivity],
		t2.i_status_id [StatusID],
		t2.sz_status [Status],
		t1.sz_description [Description],
		NULL [CompanyID],
		NULL [Priority]
	FROM 
		txn_ticket_thread t1
	JOIN mst_ticket_status t2 ON t1.i_status_id = t2.i_status_id
	WHERE
		t1.bg_ticket_id = @bg_ticket_id
		
	UNION
	
	SELECT 
		bg_ticket_id [TicketID],
		sz_ticket_number [TicketNumber],
		sz_raised_by [RaisedBy],
		dt_raised_on [RaisedOn],
		sz_subject [Subject],
		dt_last_activity [LastActivity],
		t2.i_status_id [StatusID],
		'Open' [Status],
		t1.sz_description [Description],
		sz_company_id [CompanyID],
		t3.sz_priority [Priority]
	FROM 
		mst_ticket t1
	JOIN mst_ticket_status t2 ON t1.i_status_id = t2.i_status_id
	JOIN mst_ticket_priority t3 ON t3.i_priority_id = t1.i_priority_id
	WHERE
		t1.bg_ticket_id = @bg_ticket_id AND t1.sz_company_id = @sz_company_id
	
	ORDER BY RaisedOn DESC
END 
