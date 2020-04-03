CREATE PROCEDURE [dbo].[batch_print_fax_queue_update]
(
	@pk_bp_fax_queue_id		BIGINT,
	@AddedtoQueueDate		DATETIME,
	@AddToQueueCount		INT
)
AS
BEGIN	
	UPDATE
		tbl_batch_print_fax_queue
	SET 
		IsAddedtoQueue		=	1,
		AddedtoQueueDate	=	@AddedtoQueueDate,
		AddToQueueCount		=	@AddToQueueCount
	WHERE			
		pk_bp_fax_queue_id	=	@pk_bp_fax_queue_id
	
	SELECT 'Success' AS result
END

