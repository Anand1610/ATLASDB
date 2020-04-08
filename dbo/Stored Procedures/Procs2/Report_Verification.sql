CREATE PROCEDURE [dbo].[Report_Verification] -- [Report_Verification] 'localhost'
	@domainId							nvarchar(50),
	@s_a_dt_verification_received_from	VARCHAR(20)='',
	@s_a_dt_verification_received_to	VARCHAR(20)='',
	@s_a_InjuredName					VARCHAR(100)	=	'',
	@i_a_ProviderId						varchar(100)='0',
	@s_a_ProviderGroup					varchar(100)='',
	@i_a_Insurance_Id					varchar(100)='0',
	@s_a_InsuranceGroup					varchar(100)='',
	@s_a_InitialStatus					varchar(100)='',
	@s_a_response_status				varchar(100)='All',
	@s_a_dt_response_date_from			VARCHAR(20)='',
	@s_a_dt_response_date_to			VARCHAR(20)='',
	@s_a_bill_no						varchar(100)='',
	@s_a_vr_type						varchar(100)='0'
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	IF(@s_a_dt_verification_received_from = '')
		SET @s_a_dt_verification_received_from = '01/01/1900'

	IF(@s_a_dt_verification_received_to = '')
		SET @s_a_dt_verification_received_to = '01/01/3000'

	SELECT DISTINCT
			VR.I_VERIFICATION_ID,
			cas.Case_Id,
			cas.Case_AutoId,
			cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName as InjuredParty_Name,  
			--Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') as Provider_Name,  
			--ins.InsuranceCompany_Name,  
			Provider_Name=(SELECT TOP 1 Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') FROM tblprovider pro WHERE cas.provider_id=pro.provider_id AND pro.DomainId = cas.DomainId),
			InsuranceCompany_Name=(SELECT TOP 1 LTRIM(RTRIM(LEFT(ins.InsuranceCompany_Name,15))) FROM tblinsurancecompany ins WHERE cas.insurancecompany_id=ins.insurancecompany_id AND ins.DomainId = cas.DomainId),
			VR.DT_VERIFICATION_RECEIVED,
			VR.DT_VERIFICATION_REPLIED,
			VR.SZ_NOTES,
			convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount)))) as Claim_Amount,
			convert(decimal(38,2),(convert(money,convert(float,cas.Paid_Amount)))) as Paid_Amount,
			convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount) - convert(float,cas.Paid_Amount)))) as Claim_Balance,
			convert(decimal(38,2),(convert(money,convert(float,cas.Fee_Schedule)))) as Fee_Schedule,
			convert(decimal(38,2),(convert(money,convert(float,cas.Fee_Schedule) - convert(float,cas.Paid_Amount)))) as FS_Balance,
			cas.Status,  
			cas.Initial_Status,
			cas.Old_Status,
			CONVERT(VARCHAR(10),Accident_Date,101) AS Accident_Date,
			CONVERT(VARCHAR(10),cas.DateOfService_Start,101) AS DateOfService_Start,
			CONVERT(VARCHAR(10),cas.DateOfService_End,101) AS DateOfService_End,
			cas.DenialReasons_Type as DenialReasons,
			(SELECT TOP 1 Doctor_Name FROM tblTreatment tre LEFT OUTER JOIN tblOperatingDoctor  RDR ON RDR.Doctor_id =  tre.TreatingDoctor_ID WHERE case_id = cas.Case_ID and tre.DomainId  = cas.DomainId) AS treating_doctor,
			----dbo.fncGetServiceType(cas.Case_ID) AS ServiceType,
			Provider_GroupName=(SELECT TOP 1 pro.Provider_GroupName FROM tblprovider pro WHERE cas.provider_id=pro.provider_id AND pro.DomainId = cas.DomainId),
			InsuranceCompany_GroupName=(SELECT TOP 1 ins.InsuranceCompany_GroupName FROM tblinsurancecompany ins WHERE cas.insurancecompany_id=ins.insurancecompany_id AND ins.DomainId = cas.DomainId),
			RequestImageID,
			RequestImageFileName=RI.Filename,
			RequestImageFileVirtualPath=RIBP.VirtualBasePath+RI.FilePath+RI.Filename,
			VerificationResponse,
			FaxImageID=NULL,
			FaxImageFileName=CASE WHEN ISNULL(VR.FaxStatus,'') = '' THEN '' ELSE 'View Document('+CAST(ISNULL((SELECT COUNT(*) FROM tbl_verification_response_fax_attachments FATT WHERE IsDeleted = 0 AND FATT.i_verification_id = VR.i_verification_id),'0') AS VARCHAR(MAX))+')' END,
			FaxAcknowledgementImageID,
			FaxAcknowledgementImageFileName=FAI.Filename,
			FaxAcknowledgementImageFileVirtualPath=FABP.VirtualBasePath+FAI.FilePath+FAI.Filename,
			FaxStatus,
			ManualResponseImageID,
			ManualResponseImageFileName=MRI.Filename,
			ManualResponseImageFileVirtualPath=MRBP.VirtualBasePath+MRI.FilePath+MRI.Filename,
			ResendCount,
			BillNumber=(SELECT TOP 1 T.BILL_NUMBER FROM tblTreatment T WHERE ISNULL(T.BILL_NUMBER,'') <> '' AND T.Case_Id = VR.SZ_CASE_ID AND T.DomainId = VR.DomainId),
			FaxNumber=(SELECT TOP 1 FaxNumber FROM tbl_verification_response_fax_queue FQ WHERE FQ.I_VERIFICATION_ID = VR.I_VERIFICATION_ID ORDER BY pk_vr_fax_queue_id DESC),
			VT.verification_type,
			--ISNULL(cas.Verification_Request_PostedBy,'') as VerificationPostedBy,
			VR.SZ_USER_ID as VerificationPostedBy,
			--ISNULL(CONVERT(varchar(10), cas.Verification_Request_PostedDate, 101),null) as VerificationPostedDate
			ISNULL(CONVERT(varchar(10), VR.DT_UPLOAD, 101),null) as VerificationPostedDate
		FROM
			TXN_VERIFICATION_REQUEST VR
			JOIN tblCase(NOLOCK) cas on VR.SZ_CASE_ID = cas.Case_Id
			--JOIN tblprovider pro on cas.provider_id=pro.provider_id 
			--JOIN tblinsurancecompany ins on cas.insurancecompany_id=ins.insurancecompany_id
			LEFT JOIN tblDocImages RI ON RI.ImageID = VR.RequestImageID
			 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
             AND RI.IsDeleted=0  
           ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude 
			LEFT JOIN tblBasePath RIBP ON RIBP.BasePathId = RI.BasePathId			
			LEFT JOIN tblDocImages FAI ON FAI.ImageID = VR.FaxAcknowledgementImageID
			 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
              AND FAI.IsDeleted=0   
           ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude 
			LEFT JOIN tblBasePath FABP ON FABP.BasePathId = FAI.BasePathId
			LEFT JOIN tblDocImages MRI ON MRI.ImageID = VR.ManualResponseImageID
			 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
              AND MRI.IsDeleted=0  
           ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude 
			LEFT JOIN tblBasePath MRBP ON MRBP.BasePathId = MRI.BasePathId
			LEFT JOIN tbl_verification_type VT (NOLOCK) ON VT.vr_type_Id = VR.vr_type_Id
		WHERE
			VR.DomainId = @domainId AND ISNULL(cas.IsDeleted, 0) = 0
			AND (@s_a_dt_verification_received_from = '' OR (VR.DT_VERIFICATION_RECEIVED >= CONVERT(datetime,@s_a_dt_verification_received_from))
			AND (@s_a_dt_verification_received_to = '' OR (VR.DT_VERIFICATION_RECEIVED <= CONVERT(datetime,@s_a_dt_verification_received_to))))
			AND (@s_a_InjuredName ='' OR ISNULL(cas.InjuredParty_FirstName,'')+ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR  ISNULL(cas.InjuredParty_LastName,'') + ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%')
			AND (@i_a_ProviderId = '0' OR cas.provider_id = @i_a_ProviderId)
			AND (@i_a_Insurance_Id = '0' OR cas.InsuranceCompany_Id = @i_a_Insurance_Id)
			AND (@s_a_ProviderGroup ='' OR cas.provider_id IN (SELECT DISTINCT provider_id FROM tblprovider pro WHERE pro.Provider_GroupName  = @s_a_ProviderGroup AND pro.DomainId = @domainId))
			AND (@s_a_InsuranceGroup='' OR cas.InsuranceCompany_Id IN (SELECT DISTINCT InsuranceCompany_Id FROM tblinsurancecompany ins WHERE ins.InsuranceCompany_GroupName = @s_a_InsuranceGroup AND ins.DomainId = @domainId))	
			AND (@s_a_InitialStatus= '' OR Initial_Status = @s_a_InitialStatus)
			AND (@s_a_response_status = 'All' OR 1=1)
			AND (@s_a_response_status IN ('All','Failed','Scheduled','Delivered','Manual') OR DT_VERIFICATION_REPLIED is null)
			AND (@s_a_response_status IN ('All','Pending','Manual') OR LOWER(FaxStatus) = LOWER(@s_a_response_status))
			AND (@s_a_response_status IN ('All','Failed','Scheduled','Delivered','Pending') OR ManualResponseImageID IS NOT NULL)
			AND (@s_a_dt_response_date_from = '' OR (CAST(CONVERT(VARCHAR,VR.DT_VERIFICATION_REPLIED,101) AS DATETIME) >= CONVERT(datetime,@s_a_dt_response_date_from))
			AND (@s_a_dt_response_date_to = '' OR (CAST(CONVERT(VARCHAR,VR.DT_VERIFICATION_REPLIED,101) AS DATETIME) <= CONVERT(datetime,@s_a_dt_response_date_to))))
			AND (@s_a_bill_no = '' OR VR.SZ_CASE_ID IN (SELECT DISTINCT Case_Id FROM tbltreatment WHERE BILL_NUMBER  LIKE '%' + @s_a_bill_no + '%'))
			AND (@s_a_vr_type='0' OR VR.vr_type_Id = @s_a_vr_type)
			 
	ORDER BY
			VR.I_VERIFICATION_ID DESC
			OPTION	(RECOMPILE)
END
