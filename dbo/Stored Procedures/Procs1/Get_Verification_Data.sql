CREATE PROCEDURE [dbo].[Get_Verification_Data] 

-- [Get_Verification_Data] 'Data','01/01/2019','01/01/2019'
-- [Get_Verification_Data] 'Azure','01/01/2019','01/01/2019'
-- [Get_Verification_Data] 'File','01/01/2019','01/01/2019'
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
			ISNULL(convert(nvarchar(10),dt_verification_received,101),'') [Verification_Date],
			ISNULL(sz_notes,'') as Description,
			tre.BILL_NUMBER
		  --RI.Filename AS RequestImageFileName,
		  --RIBP.PhysicalBasePath+RI.FilePath+RI.Filename AS RequestImageFileVirtualPath                             
		FROM
		   TXN_VERIFICATION_REQUEST VR (NOLOCK) 
		   INNER JOIN tblTreatment tre (NOLOCK)  ON VR.SZ_CASE_ID=tre.Case_Id 
		   INNER JOIN tblcase cas (NOLOCK) on VR.SZ_CASE_ID = cas.Case_Id and GB_CASE_ID IS NOT NULL                        
		WHERE                            
		 dt_verification_received BETWEEN @FROMDate AND @ToDate+1
		ORDER BY i_verification_id DESC
	END
	ELSE IF(@Param = 'Azure')
	BEGIN
		SELECT
			i_verification_id AS Verification_Id,
			RI.Filename AS RequestImageFileName,
			RIBP.PhysicalBaseSubPath +'\'+ RI.FilePath AS RequestImageFileVirtualPath                             
		FROM
		   TXN_VERIFICATION_REQUEST VR (NOLOCK) 
		   INNER JOIN tblTreatment tre (NOLOCK)  ON VR.SZ_CASE_ID=tre.Case_Id 
		   INNER JOIN tblcase cas (NOLOCK) on VR.SZ_CASE_ID = cas.Case_Id and GB_CASE_ID IS NOT NULL 
		   LEFT JOIN tblDocImages RI (NOLOCK) ON RI.ImageID = VR.RequestImageID AND RI.DomainId = VR.DomainID 
		   ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		 AND RI.IsDeleted=0 
         ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		   LEFT JOIN tblBasePath RIBP (NOLOCK) ON RIBP.BasePathId = RI.BasePathId                        
		WHERE                            
		 dt_verification_received BETWEEN @FROMDate AND @ToDate+1
		 AND RIBP.BasePathType=2 
		  
		ORDER BY i_verification_id DESC
	END
	ELSE IF(@Param = 'File')
	BEGIN
		SELECT
		  i_verification_id AS Verification_Id,
		  RI.Filename AS RequestImageFileName,
		  RIBP.PhysicalBasePath  +'\'+  RI.FilePath AS RequestImageFileVirtualPath  ,
		  RIBP.BasePathType AS BasePathType                           
		FROM
		   TXN_VERIFICATION_REQUEST VR (NOLOCK) 
		   INNER JOIN tblTreatment Tre (NOLOCK)  ON VR.SZ_CASE_ID=tre.Case_Id 
		   INNER JOIN tblcase cas on VR.SZ_CASE_ID = cas.Case_Id and GB_CASE_ID IS NOT NULL 
		   LEFT JOIN tblDocImages RI (NOLOCK) ON RI.ImageID = VR.RequestImageID AND RI.DomainId = VR.DomainID 
		      ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		 AND RI.IsDeleted=0
         ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		   LEFT JOIN tblBasePath RIBP (NOLOCK) ON RIBP.BasePathId = RI.BasePathId                         
		WHERE                            
		 dt_verification_received BETWEEN @FROMDate AND @ToDate+1
		
		 --AND RIBP.BasePathType != 2
		ORDER BY i_verification_id DESC
	END
END
