﻿
CREATE PROCEDURE [dbo].[VERIFICATION_RESPONSE_FAX_QUEUE_FAILURE_COUNT_UPDATE]
(
	@DomainID				VARCHAR(50)=NULL,
	@i_verification_id		INT,
	@pk_vr_fax_queue_id		BIGINT,
	@i_addtoqueuecount		INT
)
AS
BEGIN

	IF(@i_addtoqueuecount <= 3)
	BEGIN
			UPDATE
				tbl_verification_response_fax_queue
			SET
				AddToQueueCount		=	@i_addtoqueuecount
			WHERE
				pk_vr_fax_queue_id	=	@pk_vr_fax_queue_id
	END
	ELSE
	BEGIN

			UPDATE
				txn_verification_request
			SET
				FaxStatus			=	'Failed'
			WHERE
				(@DomainID IS NULL OR DomainID	=	@DomainID) AND
				I_VERIFICATION_ID	=	@i_verification_id

			UPDATE
				tbl_verification_response_fax_queue
			SET
				AddToQueueCount		=	@i_addtoqueuecount,
				isDeleted			=	1
			WHERE			
				pk_vr_fax_queue_id	=	@pk_vr_fax_queue_id	
					
	END
	
	SELECT 'Success' AS result
END

