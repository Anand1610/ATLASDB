
CREATE PROCEDURE [dbo].[VERIFICATION_RESPONSE_FAX_QUEUE_FAILURE_RESEND]
	@DomainID			VARCHAR(50),	
	@i_verification_id	INT=NULL,
	@SentByUser			VARCHAR(MAX),
	@SentOn				DATETIME
AS
BEGIN
	DECLARE @pk_vr_fax_queue_id	INT = 0

	SELECT TOP 1 @pk_vr_fax_queue_id = ISNULL(pk_vr_fax_queue_id,0) FROM tbl_verification_response_fax_queue WHERE I_VERIFICATION_ID = @i_verification_id AND DomainID = @DomainID ORDER BY pk_vr_fax_queue_id DESC
	
	IF(@pk_vr_fax_queue_id <> 0)
	BEGIN
		UPDATE
			tbl_verification_response_fax_queue
		SET
			isDeleted	=	1
		WHERE
			pk_vr_fax_queue_id = @pk_vr_fax_queue_id
	END

	INSERT INTO tbl_verification_response_fax_queue
	(
		DomainID,
		i_verification_id,
		FaxNumber,
		SentByUser,
		SentOn,
		IsAddedtoQueue,
		isDeleted,
		CoverPageText
	)
	SELECT
		DomainID,
		i_verification_id,
		FaxNumber,
		@SentByUser,
		@SentOn,
		0,
		0,
		CoverPageText
	FROM
		tbl_verification_response_fax_queue
	WHERE
		pk_vr_fax_queue_id	=	@pk_vr_fax_queue_id

	UPDATE txn_verification_request
	SET
		DT_VERIFICATION_REPLIED	=	@SentOn,
		FaxStatus				=	'Scheduled',
		ResendCount				=	ISNULL(ResendCount,0)+1
	WHERE
		I_VERIFICATION_ID		=	@i_verification_id

	SELECT 'Success' AS result
END

