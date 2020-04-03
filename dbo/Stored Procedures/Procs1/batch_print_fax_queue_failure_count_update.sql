CREATE PROCEDURE [dbo].[batch_print_fax_queue_failure_count_update]
(
	@DomainID				VARCHAR(50)=NULL,
	@fk_bp_ef_status_id		BIGINT,
	@pk_bp_fax_queue_id		BIGINT,
	@i_addtoqueuecount		INT
)
AS
BEGIN

	IF(@i_addtoqueuecount <= 3)
	BEGIN
			UPDATE
				tbl_batch_print_fax_queue
			SET
				AddToQueueCount		=	@i_addtoqueuecount
			WHERE
				pk_bp_fax_queue_id	=	@pk_bp_fax_queue_id
	END
	ELSE
	BEGIN

			UPDATE
				tbl_batch_print_offline_email_fax_status
			SET
				faxStatus			=	'Failed'
			WHERE
				(@DomainID IS NULL OR DomainID	=	@DomainID) AND
				pk_bp_ef_status_id	=	@fk_bp_ef_status_id

			UPDATE
				tbl_batch_print_fax_queue
			SET
				AddToQueueCount		=	@i_addtoqueuecount,
				isDeleted			=	1
			WHERE			
				pk_bp_fax_queue_id	=	@pk_bp_fax_queue_id	
					
	END
	
	SELECT 'Success' AS result
END

