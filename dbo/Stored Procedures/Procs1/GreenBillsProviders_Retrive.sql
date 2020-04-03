CREATE PROCEDURE [dbo].[GreenBillsProviders_Retrive] 
(
	@s_a_GB_Provider Varchar(200),
	@s_a_DomainId VARCHAR(50)
)
AS
BEGIN	 
	SET NOCOUNT ON;
    IF(@s_a_GB_Provider = 'All')
    BEGIN		 
		  SELECT DISTINCT 
		  GB.ID,
		  GB.PROVIDER_ID,
		  CompanyName, 
          ProviderName + ' '+ ProviderAddress + ' '+ProviderCity+ ' '+ProviderZip+ ' '+ProviderState+ ' '+ProviderTaxId AS [GB_PROVIDER],   
		  Provider_Name + ' '+ ProviderAddress + ' '+ProviderCity+ ' '+ProviderZip+ ' '+ProviderState+ ' '+ProviderTaxId AS PROVIDER,			 
		  name  AS [Case_Status],  
		  Status_Type  AS [Status]										 
		  FROM GreenBillsProviders GB 
		  INNER JOIN XN_TEMP_GBB_ALL XN  ON XN.CompanyId = GB.SZ_COMPANY_ID AND XN.provider_id=GB.SZ_OFFICE_ID AND GB.Gbb_Type =XN.GBB_Type AND XN.DomainId =@s_a_DomainId
		  LEFT OUTER JOIN tblProvider P  ON P.Provider_Id = GB.PROVIDER_ID  AND  P.DomainId = @s_a_DomainId
		  LEFT OUTER JOIN tblCaseStatus CS  ON CS.name = GB.Initial_Status  AND  CS.DomainId =@s_a_DomainId
		  LEFT OUTER JOIN tblStatus S  ON S.Status_Type = GB.Status AND   S.DomainId =@s_a_DomainId
	END
	ELSE IF(@s_a_GB_Provider = 'UnAssign')
    BEGIN
		 
		 
		SELECT  DISTINCT
		 GB.ID,
		 GB.PROVIDER_ID,
		 CompanyName, 
		 ProviderName + ' '+ ProviderAddress + ' '+ProviderCity+ ' '+ProviderZip+ ' '+ProviderState+ ' '+ProviderTaxId AS [GB_PROVIDER], 
		 Provider_Name  + ' '+ ProviderAddress + ' '+ProviderCity+ ' '+ProviderZip+ ' '+ProviderState+ ' '+ProviderTaxId AS PROVIDER,	
		 name  AS [Case_Status],  
		 Status_Type  AS [Status]		
		 FROM GreenBillsProviders GB 
	     INNER JOIN XN_TEMP_GBB_ALL XN  ON XN.CompanyId = GB.SZ_COMPANY_ID AND XN.provider_id=GB.SZ_OFFICE_ID AND GB.Gbb_Type =XN.GBB_Type AND XN.DomainId =  @s_a_DomainId
		 LEFT OUTER JOIN tblProvider P  ON P.Provider_Id = GB.PROVIDER_ID  AND  P.DomainId =    @s_a_DomainId
		 LEFT OUTER JOIN tblCaseStatus CS  ON CS.name = GB.Initial_Status  AND  CS.DomainId = @s_a_DomainId
		 LEFT OUTER JOIN tblStatus S  ON S.Status_Type = GB.Status AND   S.DomainId =@s_a_DomainId
	     AND XN.provider_id=GB.SZ_OFFICE_ID 
		 AND GB.Gbb_Type =XN.GBB_Type
		 AND GB.PROVIDER_ID is null
		 AND GB.Initial_Status is null
		 AND GB.Status is null
		 AND XN.DomainId =@s_a_DomainId
		 Where  GB.PROVIDER_ID is null OR GB.Status is null OR  GB.Initial_Status is null
		 
	END		   
END






