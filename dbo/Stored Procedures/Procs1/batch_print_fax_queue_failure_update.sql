CREATE PROCEDURE [dbo].[batch_print_fax_queue_failure_update]
(
	@DomainID				VARCHAR(50)=NULL,
	@fk_bp_ef_status_id		BIGINT,
	@pk_bp_fax_queue_id		BIGINT
)
AS
BEGIN
	UPDATE
		tbl_batch_print_offline_email_fax_status
	SET
		faxStatus				=	'Failed'
	WHERE
		(@DomainID IS NULL OR DomainID	=	@DomainID) AND
		pk_bp_ef_status_id		=	@fk_bp_ef_status_id

	UPDATE
		tbl_batch_print_fax_queue
	SET 
		isDeleted			=	1,
		AddToQueueCount		=	ISNULL(AddToQueueCount,0)+1
	WHERE			
		pk_bp_fax_queue_id	=	@pk_bp_fax_queue_id
	
	SELECT 'Success' AS result
END

