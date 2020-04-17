CREATE PROCEDURE [dbo].[Get_VerificationSent_Data] 
-- [Get_VerificationSent_Data] 'Data','01/01/2019','01/01/2019'
-- [Get_VerificationSent_Data] 'Azure','01/01/2019','01/01/2019'
-- [Get_VerificationSent_Data] 'File','01/01/2019','01/01/2019'
	-- Add the parameters for the stored procedure here
	@Param VARCHAR(100),
	@FROMDate DateTime= '',
	@ToDate DateTime =''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets FROM
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF(@Param = 'Data')
	BEGIN
		SELECT
		  i_verification_id AS Verification_Id,
		  ISNULL(convert(nvarchar(10),DT_VERIFICATION_REPLIED,101),'') [Verification_Date],
		  ISNULL(sz_notes,'') as Description,
		  Tre.BILL_NUMBER                          
		FROM
		   TXN_VERIFICATION_REQUEST VR (NOLOCK) 
		   INNER JOIN tblcase cas (NOLOCK) on VR.SZ_CASE_ID = cas.Case_Id and GB_CASE_ID IS NOT NULL 
		   INNER JOIN tblTreatment Tre (NOLOCK)  ON VR.SZ_CASE_ID=Tre.Case_Id                         
		WHERE                            
			DT_VERIFICATION_REPLIED BETWEEN @FROMDate AND @ToDate+1
			AND cas.gb_case_id is not null
		ORDER BY i_verification_id DESC
	END
	ELSE IF(@Param = 'Azure')
	BEGIN
			SELECT
			  i_verification_id AS Verification_Id,
			  RI.Filename AS ResponseImageFileName,
			  RIBP.PhysicalBaseSubPath +'\'+ RI.FilePath AS ResponseImageFileVirtualPath                             
			FROM
			   TXN_VERIFICATION_REQUEST VR (NOLOCK) 
			   INNER JOIN tblcase cas (NOLOCK) on VR.SZ_CASE_ID = cas.Case_Id and GB_CASE_ID IS NOT NULL 
			   INNER JOIN tblTreatment Tre (NOLOCK)  ON VR.SZ_CASE_ID=Tre.Case_Id 
			   LEFT JOIN tblDocImages RI (NOLOCK) ON RI.ImageID = VR.ManualResponseImageID AND RI.DomainId = VR.DomainID 
			   	---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		        AND RI.IsDeleted=0
               ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
			   LEFT JOIN tblBasePath RIBP (NOLOCK) ON RIBP.BasePathId = RI.BasePathId                         
			WHERE                            
				DT_VERIFICATION_REPLIED BETWEEN @FROMDate AND @ToDate+1
				AND cas.gb_case_id is not null
				AND RIBP.BasePathType = 2
				

			UNION

			SELECT
			  VR.i_verification_id AS Verification_Id,
			  FI.Filename AS ResponseImageFileName,
			  FIBP.PhysicalBaseSubPath +'\'+ FI.FilePath AS ResponseImageFileVirtualPath                             
			FROM
				tbl_verification_response_fax_attachments FATT (NOLOCK)
				JOIN TXN_VERIFICATION_REQUEST VR (NOLOCK) ON VR.I_VERIFICATION_ID = FATT.I_VERIFICATION_ID
				INNER JOIN tblcase cas (NOLOCK) on VR.SZ_CASE_ID = cas.Case_Id and GB_CASE_ID IS NOT NULL
				JOIN tblDocImages FI (NOLOCK) ON FI.ImageID = FATT.FaxImageID
					---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		        AND FI.IsDeleted=0
                ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
				JOIN tblBasePath FIBP (NOLOCK) ON FIBP.BasePathId = FI.BasePathId                      
			WHERE                            
				DT_VERIFICATION_REPLIED BETWEEN @FROMDate AND @ToDate+1
				AND cas.gb_case_id is not null
				AND FIBP.BasePathType=2
			
			ORDER BY i_verification_id DESC
	END
	ELSE IF(@Param = 'File')
	BEGIN
			SELECT
			 i_verification_id AS Verification_Id,
			  RI.Filename AS ResponseImageFileName,
			  RIBP.PhysicalBasePath+RI.FilePath AS ResponseImageFileVirtualPath   ,
			    RIBP.BasePathType AS BasePathType                        
			FROM
			   TXN_VERIFICATION_REQUEST VR (NOLOCK) 
			   INNER JOIN tblcase cas (NOLOCK) on VR.SZ_CASE_ID = cas.Case_Id and GB_CASE_ID IS NOT NULL 
			   INNER JOIN tblTreatment Tre (NOLOCK)  ON VR.SZ_CASE_ID=Tre.Case_Id 
			   LEFT JOIN tblDocImages RI (NOLOCK) ON RI.ImageID = VR.ManualResponseImageID AND RI.DomainId = VR.DomainID 
			   	---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		        AND RI.IsDeleted=0
                ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
			   LEFT JOIN tblBasePath RIBP (NOLOCK) ON RIBP.BasePathId = RI.BasePathId                         
			WHERE                            
				DT_VERIFICATION_REPLIED BETWEEN @FROMDate AND @ToDate+1
				AND cas.gb_case_id is not null
				
				--AND RIBP.BasePathType != 2
				--AND RIBP.BasePathType != 2
			UNION

			SELECT
			  VR.i_verification_id AS Verification_Id,
			  FI.Filename AS ResponseImageFileName,
			  FIBP.PhysicalBasePath + FI.FilePath AS ResponseImageFileVirtualPath,
			  FIBP.BasePathType AS BasePathType                             
			FROM
				tbl_verification_response_fax_attachments FATT (NOLOCK)
				JOIN TXN_VERIFICATION_REQUEST VR (NOLOCK) ON VR.I_VERIFICATION_ID = FATT.I_VERIFICATION_ID
				INNER JOIN tblcase cas (NOLOCK) on VR.SZ_CASE_ID = cas.Case_Id and GB_CASE_ID IS NOT NULL 
				JOIN tblDocImages FI (NOLOCK) ON FI.ImageID = FATT.FaxImageID
				---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		        AND FI.IsDeleted=0
                ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
				JOIN tblBasePath FIBP (NOLOCK) ON FIBP.BasePathId = FI.BasePathId                      
			WHERE                            
				DT_VERIFICATION_REPLIED BETWEEN @FROMDate AND @ToDate+1
				AND cas.gb_case_id is not null
				
				--AND FIBP.BasePathType!= 2
			ORDER BY i_verification_id DESC
	END
END
