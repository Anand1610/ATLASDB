CREATE PROCEDURE [dbo].[batch_print_offline_email_fax_status_retrieve]	
	@DomainID			VARCHAR(50),
	@fk_batch_print_id	INT
AS BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT
		pk_bp_ef_status_id,
		case_Id,
		ImageFileName=RI.Filename,
		ImageFileVirtualPath=RIBP.VirtualBasePath+'/'+RI.FilePath+RI.Filename,		
		Status=CASE WHEN ISNULL(emailStatus,'') = '' THEN faxStatus ELSE emailStatus END,
		StatusDate=CASE WHEN ISNULL(emailStatus,'') = '' THEN CONVERT(VARCHAR,faxStatusDate,101) ELSE CONVERT(VARCHAR,emailStatusDate,101) END,
		isEmailAcknowledged=CASE WHEN ISNULL(emailStatus,'') = '' THEN '' ELSE (CASE WHEN isnull(isEmailAcknowledged,0) = 0 THEN 'No' ELSE 'Yes' END) END,
		emailAcknowledgementDate=CASE WHEN ISNULL(emailStatus,'') = '' THEN '' ELSE (CASE WHEN isnull(isEmailAcknowledged,0) = 0 THEN '' ELSE CONVERT(VARCHAR,emailAcknowledgementDate,101) END) END,
		FaxAcknowledgementImageFileName=FAI.Filename,
		FaxAcknowledgementImageFileVirtualPath=FABP.VirtualBasePath+FAI.FilePath+FAI.Filename,
		faxAcknowledgementDate=CONVERT(VARCHAR,faxAcknowledgementDate,101),
		ResendCount
	FROM
		tbl_batch_print_offline_email_fax_status BPEF (NOLOCK)
		LEFT JOIN tblDocImages RI (NOLOCK) ON RI.ImageID = BPEF.documentImageID AND RI.DomainId = @DomainID
		LEFT JOIN tblBasePath RIBP (NOLOCK) ON RIBP.BasePathId = RI.BasePathId
		LEFT JOIN tblDocImages FAI (NOLOCK) ON FAI.ImageID = BPEF.FaxAcknowledgementImageID AND FAI.DomainId = @DomainID
		LEFT JOIN tblBasePath FABP (NOLOCK) ON FABP.BasePathId = FAI.BasePathId
	WHERE
		ISNULL(BPEF.isDeleted,0)	=	0	AND
		BPEF.DomainID				=	@DomainID	AND
		fk_batch_print_id			=	@fk_batch_print_id

		---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		AND RI.IsDeleted=0 and FAI.IsDeleted=0
        ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude

	ORDER BY
		pk_bp_ef_status_id ASC
END
---------------------------------------------------------------------------------------------------------------------
