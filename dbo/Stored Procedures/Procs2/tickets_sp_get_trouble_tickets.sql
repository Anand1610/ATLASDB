CREATE PROCEDURE [dbo].[tickets_sp_get_trouble_tickets] --tickets_sp_get_trouble_tickets @sz_raised_by='admin',@sz_company_id='localhost',@sz_status_code='ALL'
	@sz_raised_by NVARCHAR(MAX)
	,@sz_company_id NVARCHAR(20)
	,@sz_status_code CHAR(3) = NULL
AS
BEGIN
	/**
		Made query dynamic by adding filter using @sz_status_code. Not sure who has made this change. Uploading it on server as a fix for - WP-1041(GB)
	**/
	DECLARE @Query NVARCHAR(max)
	DECLARE @Where NVARCHAR(max)

	SET @Where = ' '
	SET @Query = '	SELECT 
		bg_ticket_id [TicketID],
		sz_ticket_number [TicketNumber],
		sz_raised_by [RaisedBy],
		dt_raised_on [RaisedOn],
		sz_subject [Subject],
		dt_last_activity [LastActivity],
		t2.i_status_id [StatusID],
		t2.sz_status [Status],
		sz_company_id [CompanyID],
		t3.i_priority_id[PriorityID],
		t3.sz_priority [Priority],
		CASE WHEN ISNULL((SELECT COUNT(bg_ticket_id) FROM txn_ticket_documents t4 WHERE t1.bg_ticket_id = t4.bg_ticket_id),0) = 0 THEN ''No'' ELSE ''Yes'' END [has_attachment]
	FROM
		mst_ticket t1
		JOIN mst_ticket_status t2 ON t1.i_status_id = t2.i_status_id
		JOIN mst_ticket_priority t3 ON t1.i_priority_id=t3.i_priority_id		
	WHERE
		t1.sz_raised_by =''' + @sz_raised_by + '''AND  t1.sz_company_id = ''' + @sz_company_id + ''' '

	IF (@sz_status_code IS NOT NULL AND @sz_status_code <> '' AND @sz_status_code <> 'ALL')
	BEGIN
		SET @Where = @Where + ' and t2.sz_status_code=''' + @sz_status_code + ''''
	END

	SET @Query = @Query + @Where + ' ORDER BY dt_raised_on DESC'
	print @Query
	EXEC (@Query)
END
