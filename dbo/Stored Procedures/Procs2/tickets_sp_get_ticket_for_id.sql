
CREATE PROCEDURE [dbo].[tickets_sp_get_ticket_for_id]
	@bg_ticket_id BIGINT,
	@sz_company_id NVARCHAR(20)
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
		t2.sz_status_code [StatusCode],
		t1.sz_description [Description],
		t1.sz_callback_phone [CallbackPhone],
		t1.sz_default_mail [DefaultMail],
		t1.sz_mail_cc [MailCC],
		t1.sz_type [IssueType],
		t1.sz_company_id [CompanyID],
		'' AS [Account],
		'' AS [DomainName]
	FROM 
		mst_ticket t1
	JOIN mst_ticket_status t2 ON t1.i_status_id = t2.i_status_id	
	JOIN IssueTracker_Users t4 on t1.sz_raised_by = t4.DisplayName
	WHERE
		t1.bg_ticket_id = @bg_ticket_id AND t1.sz_company_id = @sz_company_id
	
	ORDER BY RaisedOn DESC
END
