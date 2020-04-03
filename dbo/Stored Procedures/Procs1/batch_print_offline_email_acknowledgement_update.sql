CREATE PROCEDURE [dbo].[batch_print_offline_email_acknowledgement_update] 
	 @key	UNIQUEIDENTIFIER
AS
BEGIN
	UPDATE
		tbl_batch_print_offline_email_fax_status
	SET
		isEmailAcknowledged				=	1,
		emailAcknowledgementDate		=	GETDATE()
	WHERE
		emailAcknowledgementKey			=	@key AND
		ISNULL(isEmailAcknowledged,0)	=	0
END
