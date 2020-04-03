
CREATE PROCEDURE [dbo].[tickets_sp_search_tickets] 
@sz_ticket_number	VARCHAR(MAX),
@sz_subject			VARCHAR(MAX),
@sz_company_id		VARCHAR(50),
@sz_status_code		CHAR(3),
@sz_sub_status		VARCHAR(MAX),
@sz_priority		VARCHAR(MAX),
@dt_from_date		VARCHAR(MAX),
@dt_to_date			VARCHAR(MAX)
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
		--LEFT JOIN mst_ticket_sub_status t4 ON t1.i_sub_status_id = t4.i_sub_status_id
	WHERE
		1 = 1 '

	IF (@sz_ticket_number <> '')
	BEGIN
		SET @Where = @Where + ' and t1.sz_ticket_number=''' + @sz_ticket_number + ''''
	END

	IF (@sz_subject <> '')
	BEGIN
		SET @Where = @Where + ' and t1.sz_subject=''' + @sz_subject + ''''
	END

	IF (@sz_company_id <> '')
	BEGIN
		SET @Where = @Where + ' and t1.sz_company_id=''' + @sz_company_id + ''''
	END

	IF (@sz_status_code IS NOT NULL AND @sz_status_code <> '' AND @sz_status_code <> 'ALL')
	BEGIN
		SET @Where = @Where + ' and t2.sz_status_code=''' + @sz_status_code + ''''
	END

	--IF (@sz_sub_status <> '')
	--BEGIN
	--	SET @Where = @Where + ' and t4.i_sub_status_id=' + @sz_sub_status + ''
	--END

	IF (@sz_priority <> '')
	BEGIN
		SET @Where = @Where + ' and t3.i_priority_id=' + @sz_priority + ''
	END

	IF (@dt_from_date <> '')
	BEGIN
		SET @Where = @Where + ' and CAST(CONVERT(VARCHAR,t1.dt_raised_on,101) AS DATETIME) >= ''' + @dt_from_date + ''''
	END

	IF (@dt_to_date <> '')
	BEGIN
		SET @Where = @Where + ' and CAST(CONVERT(VARCHAR,t1.dt_raised_on,101) AS DATETIME) <= ''' + @dt_to_date + ''''
	END
	
	SET @Query = @Query + @Where + ' ORDER BY dt_raised_on DESC'
	print @Query
	EXEC (@Query)
END
