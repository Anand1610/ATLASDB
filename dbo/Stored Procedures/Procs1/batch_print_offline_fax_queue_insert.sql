CREATE PROCEDURE [dbo].[batch_print_offline_fax_queue_insert]
	@DomainID				VARCHAR(50),	
	@iBPEmailFaxStatusId	BIGINT=NULL,
	@FaxNumber				VARCHAR(50),
	@SentByUser				VARCHAR(MAX),
	@SentOn					DATETIME,
	@case_Id				NVARCHAR(100),
	@RecipientName			VARCHAR(MAX)
AS
BEGIN
	DECLARE @CoverPageText		VARCHAR(MAX)	=	''
	DECLARE @InsCompanyName		VARCHAR(MAX)	=	''
	DECLARE @ClientFaxorEmail	VARCHAR(MAX)	=	''	
	DECLARE @PatientName		VARCHAR(MAX)	=	''
	DECLARE @AccidentDate		VARCHAR(MAX)	=	''
	DECLARE @ClaimNo			VARCHAR(MAX)	=	''
	DECLARE @DOS				VARCHAR(MAX)	=	''
	DECLARE @AmountInDispute	VARCHAR(MAX)	=	''

	SELECT TOP 1
		@InsCompanyName		=	UPPER(REPLACE(ISNULL(INS.INSURANCECOMPANY_NAME,''),'''','')),
		@ClientFaxorEmail	=	ISNULL(INS.INSURANCECOMPANY_LOCAL_FAX,''),
		@PatientName		=	UPPER(REPLACE(ISNULL(CAS.INJUREDPARTY_FIRSTNAME, N''),'''','')) + N'  ' + UPPER(REPLACE(ISNULL(CAS.INJUREDPARTY_LASTNAME, N''),'''','')),
		@AccidentDate		=	ISNULL(CONVERT(VARCHAR(2000), CAS.Accident_Date, 101),''),
		@ClaimNo			=	REPLACE(CAST(ISNULL(CAS.INS_CLAIM_NUMBER,'') AS VARCHAR(MAX)),'''',''),
		@DOS				=	CONVERT(NVARCHAR(12),CONVERT(DATETIME, CAS.DATEOFSERVICE_START), 101)+' To '+ CONVERT(NVARCHAR(12),CONVERT(DATETIME, CAS.DATEOFSERVICE_END), 101),
		@AmountInDispute	=	'$'+CONVERT(VARCHAR(MAX),CAST(ISNULL(CAS.CLAIM_AMOUNT,0.00) AS MONEY),1)   
	FROM
		dbo.tblcase CAS
		INNER JOIN dbo.tblinsurancecompany  INS ON CAS.insurancecompany_id = INS.insurancecompany_id
	WHERE   
		CAS.Case_Id			=	@case_Id AND 
		CAS.DomainId		=	@DomainID

	SET @CoverPageText = 'Insurance Company: '+@InsCompanyName+', Client Fax Number/E-Mail: '+@ClientFaxorEmail+', Patient Name: '+@PatientName+', Date of Accident: '+@AccidentDate+', Claim Number: '+@ClaimNo+', Dates of Service: '+@DOS+', Amount in Dispute: '+@AmountInDispute+', File Number: '+@case_Id

	IF EXISTS(SELECT 1 FROM tbl_batch_print_fax_queue WHERE fk_bp_ef_status_id = @iBPEmailFaxStatusId AND Domain_Id = @DomainID AND ISNULL(IsAddedtoQueue,0) = 0 AND ISNULL(isDeleted,0) = 0)
	BEGIN
		UPDATE
			tbl_batch_print_fax_queue
		SET
			isDeleted	=	1
		WHERE
			pk_bp_fax_queue_id IN (SELECT pk_bp_fax_queue_id FROM tbl_batch_print_fax_queue WHERE fk_bp_ef_status_id = @iBPEmailFaxStatusId AND Domain_Id = @DomainID AND ISNULL(IsAddedtoQueue,0) = 0 AND ISNULL(isDeleted,0) = 0)
	END

	INSERT INTO tbl_batch_print_fax_queue
	(
		Domain_Id,
		fk_bp_ef_status_id,
		FaxNumber,
		SentByUser,
		SentOn,
		IsAddedtoQueue,
		isDeleted,
		CoverPageText,
		RecipientName
	)
	VALUES
	(
		@DomainID,
		@iBPEmailFaxStatusId,
		@FaxNumber,
		@SentByUser,
		@SentOn,
		0,
		0,
		@CoverPageText,
		@RecipientName
	)

	SELECT 'Success' AS result
END

