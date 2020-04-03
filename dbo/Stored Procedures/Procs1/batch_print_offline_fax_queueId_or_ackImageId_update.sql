CREATE PROCEDURE [dbo].[batch_print_offline_fax_queueId_or_ackImageId_update]
	@DomainID					VARCHAR(50)=NULL,
	@pk_bp_ef_status_id			BIGINT,
	@FaxQueueID					BIGINT=NULL,
	@FaxAcknowledgementImageID	BIGINT=NULL
AS
BEGIN		
	IF(@FaxQueueID IS NOT NULL)
	BEGIN
		UPDATE
			tbl_batch_print_offline_email_fax_status
		SET 
			faxQueueID				=	@FaxQueueID
		WHERE
			(@DomainID IS NULL OR DomainID	=	@DomainID) AND
			pk_bp_ef_status_id		=	@pk_bp_ef_status_id
	END

	IF(@FaxAcknowledgementImageID IS NOT NULL)
	BEGIN
		UPDATE
			tbl_batch_print_offline_email_fax_status
		SET 
			faxAcknowledgementImageID	=	@FaxAcknowledgementImageID,
			faxAcknowledgementDate		=	GETDATE(),
			faxStatus					=	'Delivered'
		WHERE
			(@DomainID IS NULL OR DomainID	=	@DomainID) AND
			pk_bp_ef_status_id			=	@pk_bp_ef_status_id
	END
END

