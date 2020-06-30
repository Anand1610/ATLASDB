CREATE PROCEDURE [dbo].[TransferCases]  
(  
 @CaseDetails [UT_TransferCases] READONLY,  
 @Gbb_Type VARCHAR(10)  
)  
  
AS  
BEGIN  
  INSERT INTO XN_TEMP_GBB_ALL  
  SELECT *, 
	--NULL AS TreatmentDetails,
	--NULL AS DiagnosisCodes, 
	NULL AS AtlasInsuranceId, 
    @Gbb_Type,   
    NULL AS Transferd_Date,   
    '' AS Transferd_Status,  
    AtlasCaseID = NULL,  
    AtlasCaseIndexNumber = NULL,  
    AtlasPrincipalAmountCollected = 0,  
    AtlasInterestAmountCollected = 0,  
    AtlasCaseStatus = NULL,  
    AtlasLastTransactionDate = NULL,  
    IsDataSyncedtoGYB = 0,  
    DateSyncedtoGYB = NULL  
  FROM @CaseDetails c  
  WHERE NOT EXISTS  
    (  
     SELECT 1   
     FROM XN_TEMP_GBB_ALL b  (nolock)
     WHERE BillNumber = c.BillNumber  
     AND  b.GBB_TYPE = @Gbb_Type  
    )  
    
  
  UPDATE  XN   
  SET  DomainId = act.DomainId  
  FROM XN_TEMP_GBB_ALL XN  (nolock)
  INNER Join DomainAccounts act (nolock) ON AssignedLawFirmId = act.LawFirmId   
  and  XN.DomainId IS NULL  
  
  UPDATE XN_TEMP_GBB_ALL  
    SET Transferd_Status = T.Case_Id,  
    --AtlasCaseID = T.Case_Id,  
    IsDataSyncedtoGYB = 0  
  FROM XN_TEMP_GBB_ALL X  (nolock)
  INNER JOIN tblTreatment T (nolock) ON X.BillNumber = T.BILL_NUMBER AND X.DomainId = T.DomainId  
  WHERE ISNULL(AtlasCaseID, '') = ''  and Transferd_Status  =''
  
  UPDATE XN_TEMP_GBB_ALL  
  SET  InsuranceName = LTRIM(RTRIM(InsuranceName)),  
    PatientFirstName = LTRIM(RTRIM(PatientFirstName)),  
    PatientLastName = LTRIM(RTRIM(PatientLastName)),  
    ProviderName = LTRIM(RTRIM(ProviderName)),  
    ProviderAddress = LTRIM(RTRIM(ProviderAddress))  
  WHERE ISNULL(Transferd_Status,'') = ''  
   
  UPDATE XN_TEMP_GBB_ALL   
  SET  IsDuplicateCase = CASE WHEN CONVERT(MONEY,[FltBillAmount])- CONVERT(MONEY,FltPaid) > 0 THEN 0 ELSE 1 END  
  WHERE ISNULL(Transferd_Status,'') = ''  
    
  -- INSERT GBB PROVIDER MAPPING IN MASTER  
  INSERT INTO GreenBillsProviders   
  (  
   SZ_COMPANY_ID,   
   SZ_OFFICE_ID,   
   Gbb_Type,DomainId  
  )  
  SELECT DISTINCT  XN.CompanyId,   
    XN.provider_id,   
     xn.GBB_Type,XN.DomainId    
  FROM XN_TEMP_GBB_ALL XN (nolock)
  LEFT OUTER JOIN  GreenBillsProviders GB (nolock) ON XN.CompanyId = GB.SZ_COMPANY_ID AND XN.provider_id=GB.SZ_OFFICE_ID and GB.Gbb_Type = xn.GBB_Type  and XN.DomainId = GB.DomainID  
  WHERE GB.PROVIDER_ID IS NULL AND GB.SZ_COMPANY_ID IS NULL  
  
  ----SELECT DISTINCT  XN.CompanyId, XN.provider_id, Gbb_Type  FROM XN_TEMP_GBB_ALL XN  
  ----LEFT OUTER JOIN  GreenBillsProviders GB ON XN.CompanyId = GB.SZ_COMPANY_ID AND XN.provider_id=GB.SZ_OFFICE_ID and GB.Gbb_Type = xn. xn.GBB_Type  
  ----WHERE GB.PROVIDER_ID IS NULL AND GB.SZ_COMPANY_ID IS NOT NULL  
    
  --- UPDATE Provider as per RFA data  
  UPDATE XN_TEMP_GBB_ALL  
  SET  AtlasProviderID =  GB.PROVIDER_ID  
  FROM XN_TEMP_GBB_ALL XN  (nolock)
  LEFT OUTER JOIN  GreenBillsProviders GB (nolock) ON XN.CompanyId = GB.SZ_COMPANY_ID AND XN.provider_id=GB.SZ_OFFICE_ID and GB.Gbb_Type = xn.GBB_Type and XN.DomainId = GB.DomainID  
  WHERE ISNULL(AtlasProviderID,'') = '' AND  GB.PROVIDER_ID IS NOT NULL  
  
  -- INSERT GBB Insurance MAPPING IN MASTER  
  INSERT INTO GreenBillsInsurance (SZ_COMPANY_ID, SZ_INSURANCE_ID, Gbb_Type,DomainId)  
  SELECT DISTINCT  XN.CompanyId, XN.insurancecompanyid, xn.GBB_Type,XN.DomainId  FROM XN_TEMP_GBB_ALL XN (nolock)
  LEFT OUTER JOIN  GreenBillsInsurance GB (nolock) ON XN.CompanyId = GB.SZ_COMPANY_ID AND XN.insurancecompanyid=GB.SZ_INSURANCE_ID and GB.Gbb_Type = xn.GBB_Type AND XN.DomainId = GB.DomainID   
  WHERE GB.INSURANCECOMPANY_ID IS NULL AND GB.SZ_COMPANY_ID IS NULL   
  
  ----SELECT DISTINCT  XN.CompanyId, XN.insurancecompanyid, xn.GBB_Type  FROM XN_TEMP_GBB_ALL XN  
  ----LEFT OUTER JOIN  GreenBillsInsurance GB ON XN.CompanyId = GB.SZ_COMPANY_ID AND XN.insurancecompanyid=GB.SZ_INSURANCE_ID and GB.Gbb_Type = xn.GBB_Type  
  ----WHERE GB.INSURANCECOMPANY_ID IS NULL AND GB.SZ_COMPANY_ID IS NOT NULL   
  
  
  --- UPDATE InsuranceCompany as per RFA data  
  UPDATE XN_TEMP_GBB_ALL  
  SET  AtlasInsuranceId =  GB.INSURANCECOMPANY_ID  
  FROM XN_TEMP_GBB_ALL XN  (nolock)
  LEFT OUTER JOIN  GreenBillsInsurance GB (nolock) ON XN.CompanyId = GB.SZ_COMPANY_ID AND XN.insurancecompanyid=GB.SZ_INSURANCE_ID  and GB.Gbb_Type = xn.GBB_Type and XN.DomainId = GB.DomainID  
  WHERE ISNULL(AtlasInsuranceId,'') = '' AND  GB.INSURANCECOMPANY_ID IS NOT NULL  
  
  
  EXEC TransferCasesLogic @Gbb_Type  
  EXEC GreenBillsDataReconciliation
     
    
 END

