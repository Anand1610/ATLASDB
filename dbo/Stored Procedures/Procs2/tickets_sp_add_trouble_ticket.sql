
CREATE PROCEDURE [dbo].[tickets_sp_add_trouble_ticket]
	@sz_raised_by NVARCHAR(MAX),
	@sz_company_id NVARCHAR(20),
	@sz_subject NVARCHAR(MAX),
	@sz_emailcc NVARCHAR(MAX),
	@sz_defaultemail NVARCHAR(255),
	@sz_description NVARCHAR(MAX),
	@sz_type NVARCHAR(255),
	@sz_subtype NVARCHAR(255) = NULL,
	@sz_callback_phone NVARCHAR(255),
	@sz_ticket_number NVARCHAR(40) OUTPUT,	
	@i_priority_id INT
AS
BEGIN
	DECLARE @i_status_id INT
	DECLARE @bg_ticket_id BIGINT
	DECLARE @i_sub_status_id INT
	
	SET @i_status_id = (SELECT i_status_id FROM mst_ticket_status WHERE sz_status_code = 'OPN')
	SET @i_sub_status_id = (SELECT i_sub_status_id FROM mst_ticket_sub_Status WHERE c_code = 'NAS')
	
	IF(@sz_callback_phone = '')
		SET @sz_callback_phone = NULL
	
	INSERT INTO	mst_ticket
	(
		sz_company_id,
		sz_raised_by,
		dt_raised_on,
		sz_subject,
		sz_description,
		sz_type,
		sz_sub_type,
		dt_last_activity,
		i_status_id,
		i_sub_status_id,
		sz_callback_phone,
		sz_default_mail,
		sz_mail_cc,
		i_priority_id
	)
	VALUES 
	(
		@sz_company_id,
		@sz_raised_by,
		getdate(),
		@sz_subject,
		@sz_description,
		@sz_type,
		@sz_subtype,
		getdate(),
		@i_status_id,
		@i_sub_status_id,
		@sz_callback_phone,
		@sz_defaultemail,
		@sz_emailcc,
		@i_priority_id
	)
	
	SET @bg_ticket_id = (SELECT SCOPE_IDENTITY())
	
	INSERT INTO txn_ticket_sub_status_history(i_sub_status_id,bg_ticket_id,dt_created,dt_updated)
	VALUES(@i_sub_status_id,@bg_ticket_id,getdate(),getdate())
	
	IF(ISNULL(@sz_subtype,'') = '')
	BEGIN
		SET @sz_ticket_number = @sz_type + '-' + RTRIM(LTRIM(STR(@bg_ticket_id)))
	END
	ELSE
	BEGIN
		SET @sz_ticket_number = @sz_type + '-' + @sz_subtype + '-' + RTRIM(LTRIM(STR(@bg_ticket_id)))	
	END
	
	UPDATE mst_ticket
	SET sz_ticket_number = @sz_ticket_number
	WHERE bg_ticket_id = @bg_ticket_id
END
