CREATE PROCEDURE [dbo].[SP_GET_VERIFICATION_REQUEST] 
	@DomainID varchar(50),
	@SZ_CASE_ID NVARCHAR(20)
as
begin
	select 
		i_verification_id,
		isnull(convert(nvarchar(10),dt_verification_received,101),'') [date_received],
		isnull(convert(nvarchar(10),dt_verification_replied,101),'') [date_replied], 
		ISNuLL(sz_notes,'') as sz_notes,
		sz_user_id,
		RequestImageID,
		RequestImageFileName=RI.Filename,
		RequestImageFileVirtualPath=RIBP.VirtualBasePath+'/'+RI.FilePath+RI.Filename,
		VerificationResponse,
		FaxImageID=NULL,
		FaxImageFileName=CASE WHEN ISNULL(VR.FaxStatus,'') = '' THEN '' ELSE 'View Document('+CAST(ISNULL((SELECT COUNT(*) FROM tbl_verification_response_fax_attachments FATT WHERE IsDeleted = 0 AND FATT.i_verification_id = VR.i_verification_id),'0') AS VARCHAR(MAX))+')' END,			
		FaxAcknowledgementImageID,
		FaxAcknowledgementImageFileName=FAI.Filename,
		FaxAcknowledgementImageFileVirtualPath=FABP.VirtualBasePath+'/'+FAI.FilePath+FAI.Filename,
		'via Fax' AS ViaFax,
		FaxStatus,
		ManualResponseImageID,
		ManualResponseImageFileName=MRI.Filename,
		ManualResponseImageFileVirtualPath=MRBP.VirtualBasePath+'/'+MRI.FilePath+MRI.Filename,
		ResendCount,
		ISNULL(VR.vr_type_Id, 0) as vr_type_Id,
		VT.verification_type
	from
		TXN_VERIFICATION_REQUEST VR (NOLOCK)
		LEFT JOIN tblDocImages RI (NOLOCK) ON RI.ImageID = VR.RequestImageID AND RI.DomainId = @DomainID
		LEFT JOIN tblBasePath RIBP (NOLOCK) ON RIBP.BasePathId = RI.BasePathId
		LEFT JOIN tblDocImages FAI (NOLOCK) ON FAI.ImageID = VR.FaxAcknowledgementImageID AND FAI.DomainId = @DomainID
		LEFT JOIN tblBasePath FABP (NOLOCK) ON FABP.BasePathId = FAI.BasePathId
		LEFT JOIN tblDocImages MRI (NOLOCK) ON MRI.ImageID = VR.ManualResponseImageID AND MRI.DomainId = @DomainID
		LEFT JOIN tblBasePath MRBP (NOLOCK) ON MRBP.BasePathId = MRI.BasePathId
		LEFT JOIN tbl_verification_type VT (NOLOCK) ON VT.vr_type_Id = VR.vr_type_Id
	where 
		VR.sz_case_id	=	@SZ_CASE_ID AND 
		VR.DomainID		=	@DomainID
	order by
		i_verification_id DESC
end
