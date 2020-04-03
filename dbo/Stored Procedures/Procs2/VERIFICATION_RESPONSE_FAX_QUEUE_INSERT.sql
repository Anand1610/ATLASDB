
CREATE PROCEDURE [dbo].[VERIFICATION_RESPONSE_FAX_QUEUE_INSERT]
	@DomainID			VARCHAR(50),	
	@i_verification_id	INT=NULL,
	@FaxNumber			VARCHAR(50),
	@SentByUser			VARCHAR(MAX),
	@SentOn				DATETIME
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
	DECLARE @CaseID				VARCHAR(MAX)	=	''

	SELECT TOP 1
		@CaseID				=	SZ_CASE_ID 
	FROM 
		txn_verification_request
	WHERE 
		I_VERIFICATION_ID	=	@i_verification_id AND 
		DomainID			=	@DomainID

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
		CAS.Case_Id			=	@CaseID AND 
		CAS.DomainId		=	@DomainID

	SET @CoverPageText = 'Insurance Company: '+@InsCompanyName+', Client Fax Number/E-Mail: '+@ClientFaxorEmail+', Patient Name: '+@PatientName+', Date of Accident: '+@AccidentDate+', Claim Number: '+@ClaimNo+', Dates of Service: '+@DOS+', Amount in Dispute: '+@AmountInDispute+', File Number: '+@CaseID

	IF EXISTS(SELECT 1 FROM tbl_verification_response_fax_queue WHERE I_VERIFICATION_ID = @i_verification_id AND DomainID = @DomainID AND ISNULL(IsAddedtoQueue,0) = 0 AND ISNULL(isDeleted,0) = 0)
	BEGIN
		UPDATE
			tbl_verification_response_fax_queue
		SET
			isDeleted	=	1
		WHERE
			pk_vr_fax_queue_id IN (SELECT pk_vr_fax_queue_id FROM tbl_verification_response_fax_queue WHERE I_VERIFICATION_ID = @i_verification_id AND DomainID = @DomainID AND ISNULL(IsAddedtoQueue,0) = 0 AND ISNULL(isDeleted,0) = 0)
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
	VALUES
	(
		@DomainID,
		@i_verification_id,
		@FaxNumber,
		@SentByUser,
		@SentOn,
		0,
		0,
		@CoverPageText
	)

	UPDATE txn_verification_request
	SET
		DT_VERIFICATION_REPLIED	=	@SentOn
	WHERE
		I_VERIFICATION_ID		=	@i_verification_id

	SELECT 'Success' AS result
END

