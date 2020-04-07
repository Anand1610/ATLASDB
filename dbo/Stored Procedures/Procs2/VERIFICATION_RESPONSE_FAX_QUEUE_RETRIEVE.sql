
CREATE PROCEDURE [dbo].[VERIFICATION_RESPONSE_FAX_QUEUE_RETRIEVE]
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF(ISNULL((SELECT COUNT(*) FROM tbl_verification_response_fax_queue WHERE ISNULL(IsDeleted,0) = 0 AND ISNULL(IsAddedtoQueue,0) = 0 AND ISNULL(inprogress_send,0) = 1),0) < 3)  
		BEGIN
			SELECT TOP 2
			pk_vr_fax_queue_id,
			DomainID=Q.DomainID,
			i_verification_id=Q.i_verification_id,
			FaxNumber,
			SentByUser,
			SentOn,
			IsAddedtoQueue=ISNULL(IsAddedtoQueue,0),
			isDeleted=ISNULL(isDeleted,0),
			ResponseImageFileVirtualPath=SUBSTRING(ISNULL(stuff(
			(
				SELECT 
					COALESCE(Convert(varchar(10),FIBP.BasePathId)+'~\'+REPLACE(REPLACE(FI.FilePath,'//','\'),'/','\')+FI.Filename+'|',' - ') 
				FROM 
					tbl_verification_response_fax_attachments FATT (NOLOCK)
					JOIN tblDocImages FI (NOLOCK) ON FI.ImageID = FATT.FaxImageID AND FI.DomainId = R.DomainID
					JOIN tblBasePath FIBP (NOLOCK) ON FIBP.BasePathId = FI.BasePathId 
				WHERE 
					FATT.i_verification_id = R.i_verification_id AND
					FATT.IsDeleted = 0
					   ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
                    AND FI.IsDeleted=0  
                    ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude 
				ORDER BY FATT.pk_vr_fax_attachment_id ASC
				for xml path('')
			),1,0,' '),','),1,(LEN(ISNULL(stuff(
				(
					SELECT 
						COALESCE(Convert(varchar(10),FIBP.BasePathId)+'~\'+REPLACE(REPLACE(FI.FilePath,'//','\'),'/','\')+FI.Filename+'|',' - ') 
					FROM 
						tbl_verification_response_fax_attachments FATT (NOLOCK)
						JOIN tblDocImages FI (NOLOCK) ON FI.ImageID = FATT.FaxImageID AND FI.DomainId = R.DomainID
						JOIN tblBasePath FIBP (NOLOCK) ON FIBP.BasePathId = FI.BasePathId 
					WHERE 
						FATT.i_verification_id = R.i_verification_id AND
						FATT.IsDeleted = 0
						 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
                           AND FI.IsDeleted=0  
                       ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
					ORDER BY FATT.pk_vr_fax_attachment_id ASC
					for xml path('')
				),1,0,' '),',')))-1),
				RecipientsName=(SELECT TOP 1 IC.InsuranceCompany_Name FROM tblInsuranceCompany IC JOIN tblcase C ON C.InsuranceCompany_Id = IC.InsuranceCompany_Id WHERE C.Case_Id = R.SZ_CASE_ID),
				CoverPageText,
				AddToQueueCount=ISNULL(AddToQueueCount,0),
				FaxQueueID=ISNULL(FaxQueueID,0)
			FROM
				tbl_verification_response_fax_queue Q (NOLOCK)
				JOIN txn_verification_request R (NOLOCK) ON Q.i_verification_id = R.i_verification_id
			WHERE
				ISNULL(isDeleted,0)			=	0	AND
				ISNULL(IsAddedtoQueue,0)	=	0	AND
				ISNULL(inprogress_send, 0) =	0
			ORDER BY
				pk_vr_fax_queue_id ASC
		END
	ELSE
		BEGIN
			SELECT TOP 2
			pk_vr_fax_queue_id,
			DomainID=Q.DomainID,
			i_verification_id=Q.i_verification_id,
			FaxNumber,
			SentByUser,
			SentOn,
			IsAddedtoQueue=ISNULL(IsAddedtoQueue,0),
			isDeleted=ISNULL(isDeleted,0),
			ResponseImageFileVirtualPath=SUBSTRING(ISNULL(stuff(
			(
				SELECT 
					COALESCE(Convert(varchar(10),FIBP.BasePathId)+'~\'+REPLACE(REPLACE(FI.FilePath,'//','\'),'/','\')+FI.Filename+'|',' - ') 
				FROM 
					tbl_verification_response_fax_attachments FATT (NOLOCK)
					JOIN tblDocImages FI (NOLOCK) ON FI.ImageID = FATT.FaxImageID AND FI.DomainId = R.DomainID
					JOIN tblBasePath FIBP (NOLOCK) ON FIBP.BasePathId = FI.BasePathId 
				WHERE 
					FATT.i_verification_id = R.i_verification_id AND
					FATT.IsDeleted = 0
					---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
                    AND FI.IsDeleted=0  
                    ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
				ORDER BY FATT.pk_vr_fax_attachment_id ASC
				for xml path('')
			),1,0,' '),','),1,(LEN(ISNULL(stuff(
				(
					SELECT 
						COALESCE(Convert(varchar(10),FIBP.BasePathId)+'~\'+REPLACE(REPLACE(FI.FilePath,'//','\'),'/','\')+FI.Filename+'|',' - ') 
					FROM 
						tbl_verification_response_fax_attachments FATT (NOLOCK)
						JOIN tblDocImages FI (NOLOCK) ON FI.ImageID = FATT.FaxImageID AND FI.DomainId = R.DomainID
						JOIN tblBasePath FIBP (NOLOCK) ON FIBP.BasePathId = FI.BasePathId 
					WHERE 
						FATT.i_verification_id = R.i_verification_id AND
						FATT.IsDeleted = 0
						 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
                          AND FI.IsDeleted=0  
                       ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
					ORDER BY FATT.pk_vr_fax_attachment_id ASC
					for xml path('')
				),1,0,' '),',')))-1),
				RecipientsName=(SELECT TOP 1 IC.InsuranceCompany_Name FROM tblInsuranceCompany IC JOIN tblcase C ON C.InsuranceCompany_Id = IC.InsuranceCompany_Id WHERE C.Case_Id = R.SZ_CASE_ID),
				CoverPageText,
				AddToQueueCount=ISNULL(AddToQueueCount,0),
				FaxQueueID=ISNULL(FaxQueueID,0)
			FROM
				tbl_verification_response_fax_queue Q (NOLOCK)
				JOIN txn_verification_request R (NOLOCK) ON Q.i_verification_id = R.i_verification_id
			WHERE
				ISNULL(isDeleted,0)			=	-1	AND
				ISNULL(IsAddedtoQueue,0)	=	-1	AND
				ISNULL(inprogress_send, 0) =	-1
			ORDER BY
				pk_vr_fax_queue_id ASC
		END
END

