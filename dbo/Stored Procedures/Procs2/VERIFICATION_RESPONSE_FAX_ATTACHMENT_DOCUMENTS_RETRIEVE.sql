-- VERIFICATION_RESPONSE_FAX_ATTACHMENT_DOCUMENTS_RETRIEVE 3329

CREATE PROCEDURE [dbo].[VERIFICATION_RESPONSE_FAX_ATTACHMENT_DOCUMENTS_RETRIEVE] 
	@VerificationId		INT
as
begin
	SELECT
		SNO=ROW_NUMBER() OVER(ORDER BY FATT.pk_vr_fax_attachment_id ASC),
		FATT.pk_vr_fax_attachment_id,
		FATT.i_verification_id,
		FaxImageFileName=FI.Filename,
		FaxImageFileVirtualPath=FIBP.VirtualBasePath+'/'+FI.FilePath+FI.Filename,
		DT_VERIFICATION_RECEIVED=CONVERT(VARCHAR,VR.DT_VERIFICATION_RECEIVED,101),
		DT_VERIFICATION_REPLIED=CONVERT(VARCHAR,VR.DT_VERIFICATION_REPLIED,101),
		VR.SZ_CASE_ID
	FROM
		tbl_verification_response_fax_attachments FATT (NOLOCK)
		JOIN TXN_VERIFICATION_REQUEST VR (NOLOCK) ON VR.I_VERIFICATION_ID = FATT.I_VERIFICATION_ID
		JOIN tblDocImages FI (NOLOCK) ON FI.ImageID = FATT.FaxImageID
		JOIN tblBasePath FIBP (NOLOCK) ON FIBP.BasePathId = FI.BasePathId 
	WHERE
		FATT.i_verification_id	=	@VerificationId AND
		FATT.IsDeleted			=	0
		 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
        AND FI.IsDeleted=0  
        ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude 
	ORDER BY
		pk_vr_fax_attachment_id ASC
end
