
CREATE PROCEDURE [dbo].[VERIFICATION_RESPONSE_FAX_QUEUE_UPDATE]
(
	@pk_vr_fax_queue_id		BIGINT,
	@AddedtoQueueDate		DATETIME,
	@AddToQueueCount		INT
)
AS
BEGIN	
	UPDATE
		tbl_verification_response_fax_queue
	SET 
		IsAddedtoQueue		=	1,
		AddedtoQueueDate	=	@AddedtoQueueDate,
		AddToQueueCount		=	@AddToQueueCount
	WHERE			
		pk_vr_fax_queue_id	=	@pk_vr_fax_queue_id
	
	SELECT 'Success' AS result
END

