
CREATE PROCEDURE [dbo].[Case_Search_POM] -- [Case_Search_POM] 'localhost'  
(  
  @DomainID VARCHAR(50),  
  @s_a_ProviderNameGroupSel VARCHAR(MAX) = '',  
  @s_a_InsuranceGroupSel VARCHAR(MAX) = '',  
  @s_a_CurrentStatusGroupSel VARCHAR(MAX) = '',  
  @s_a_MultipleCase_ID VARCHAR(MAX) = '',  
  @s_a_Case_ID VARCHAR(100) = '',  
  @s_a_OldCaseId VARCHAR(100) = '',  
  @s_a_PacketID VARCHAR(100) = '',  
  @s_a_InjuredName VARCHAR(100) = '',  
  @s_a_InsuredName VARCHAR(100) = '',  
  @s_a_POM_Id VARCHAR(100) = '',  
  @s_a_PolicyNo VARCHAR(100) = '',  
  @s_a_ClaimNo VARCHAR(100) = '',  
  @s_a_POMType VARCHAR(5)  = '0'       
)  
AS  
BEGIN   
--DBCC FREEPROCCACHE  
--DBCC DROPCLEANBUFFERS    
 --select Fee_Schedule,* from tblCase  
 SELECT  DISTINCT top 500  
  cas.Case_Id,  
  cas.Case_AutoId,  
  cas.Case_Code AS Case_Code,  
  (SELECT MAX(POM_ID) FROM tblPomCase (NOLOCK) WHERE DomainId = @DomainID and case_id = cas.Case_Id AND POMType = 'POM' ) AS [pom_id] ,  
  (SELECT MAX(POM_ID) FROM tblPomCase (NOLOCK) WHERE DomainId = @DomainID and case_id = cas.Case_Id AND POMType = 'Verification POM') AS vr_pom_id , 
  cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName as InjuredParty_Name,    
  Provider_Name as Provider_Name,    
  ins.InsuranceCompany_Name,    
  ins.InsuranceCompany_Local_Address AS InsuranceCompany_Address,  
  ins.InsuranceCompany_Local_City AS InsuranceCompany_City,  
  ins.InsuranceCompany_Local_State AS InsuranceCompany_State,  
  ins.InsuranceCompany_Local_Zip AS InsuranceCompany_Zip,  
  cas.Indexoraaa_number,    
  convert(decimal(38,2),SUM(ISNULL(cas.Claim_Amount,0)) - SUM(ISNULL(cas.Paid_Amount,0)) - SUM(ISNULL(cas.WriteOff,0))) AS Claim_Amount,  
  convert(decimal(38,2),SUM(ISNULL(cas.Fee_Schedule,0)) - SUM(ISNULL(cas.Paid_Amount,0)) - SUM(ISNULL(cas.WriteOff,0))) AS FS_Balance,
  --convert(decimal(38,2),(convert(money,convert(float,tre.Claim_Amount) - convert(float,tre.Paid_Amount)- convert(float,ISNULL(tre.WriteOff,0))))) as Claim_Amount,  
  --convert(decimal(38,2),(convert(money,convert(float,tre.Fee_Schedule) - convert(float,tre.Paid_Amount) - convert(float,ISNULL(tre.WriteOff,0))))) as FS_Balance,  
  cas.Status,    
  cas.Initial_Status,  
  cas.Accident_Date,    
  cas.Ins_Claim_Number,   
  pro.Provider_GroupName,  
  CONVERT(varchar(10), min(tre.DateOfService_Start), 101) AS DateOfService_Start,   
  CONVERT(varchar(12), min(tre.DateOfService_End), 1) AS DateOfService_End,  
  CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd,cas.date_status_Changed,GETDATE()))) as Status_Age,  
  DATEDIFF(DD, CONVERT(varchar(10), min(tre.DateOfService_Start), 101) , GETDATE()) AS DOS_Start_Age   
 FROM dbo.tblCase cas  
  INNER JOIN dbo.tblprovider pro on cas.provider_id=pro.provider_id   
  INNER JOIN dbo.tblinsurancecompany ins on cas.insurancecompany_id=ins.insurancecompany_id  
  --LEFT OUTER JOIN dbo.tblPomCase pcas On cas.Case_Id = pcas.case_id  
  LEFT OUTER JOIN dbo.tblTreatment tre on tre.Case_Id= cas.Case_Id  
 WHERE  
  cas.DomainId = @DomainID AND ISNULL(cas.IsDeleted, 0) = 0 --AND Status <> 'POM GENERATED'  
  AND (@s_a_ProviderNameGroupSel  ='' OR cas.Provider_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_ProviderNameGroupSel,',')))  
  AND (@s_a_InsuranceGroupSel  ='' OR cas.InsuranceCompany_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_InsuranceGroupSel,',')))  
  AND (cas.Case_Id like 'ACT%' OR Initial_Status = 'PRE-ARB' )  
  AND  status <> 'IN ARB OR LIT'  
  AND (@s_a_CurrentStatusGroupSel ='' OR cas.Status IN (SELECT s FROM dbo.SplitString(@s_a_CurrentStatusGroupSel,',')))  
  AND (@s_a_MultipleCase_ID ='' OR cas.Case_Id IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,',')) OR  cas.Case_Id IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,' ')))  
  AND (@s_a_Case_ID ='' OR cas.Case_Id like '%'+ @s_a_Case_ID + '%')  
  AND (@s_a_OldCaseId ='' OR cas.Case_Code like '%'+ @s_a_OldCaseId + '%')  
  AND (@s_a_InjuredName ='' OR ISNULL(cas.InjuredParty_FirstName,'')+' ' +ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR  ISNULL(cas.InjuredParty_LastName,'') +' ' + ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%')  
  AND (@s_a_InsuredName ='' OR ISNULL(cas.InsuredParty_FirstName,'')+' ' +ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR  ISNULL(cas.InsuredParty_LastName,'') +' ' + ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%')  
  AND (@s_a_POM_Id ='' OR  cas.case_id in (SELECT case_id FROM tblPomCase pcas (NOLOCK) WHERE pcas.DomainId = @DomainID AND pcas.pom_id like '%'+ @s_a_POM_Id + '%'))
  AND (@s_a_PolicyNo ='' OR cas.Policy_Number like '%'+ @s_a_PolicyNo + '%')  
  AND (@s_a_ClaimNo ='' OR cas.Ins_Claim_Number like '%'+ @s_a_ClaimNo + '%')  
  --AND (@s_a_POMType='2'   
  -- OR (@s_a_POMType='0' and Status in ('ACTIVE BILLING TO BE MAILED','ACTIVE BILLING','ACTIVE BILLING LS','BILLING TO BE MAILED','BILLING RESUBMISSION'))   
  -- OR (@s_a_POMType='1' and ISNULL(pcas.pom_id,'') <> '' and ISNULL(POMType,'') = 'POM' )  
  -- OR (@s_a_POMType='3' and Status in ('BILLING VERIFICATION'))  
  -- OR (@s_a_POMType='4' and ISNULL(pcas.pom_id,'') <> '' and ISNULL(POMType,'') = 'Verification POM' )  
  -- )  
  -- @s_a_POMType 2 --> ALL   0 --> Need POM   1 -->Generated POM  
 Group by    
  cas.Case_Id,  
  cas.Case_AutoId,  
  cas.Case_Code,  
  cas.InjuredParty_FirstName,  
  cas.InjuredParty_LastName,  
  pro.Provider_Name,  
  ins.InsuranceCompany_Name,  
  ins.InsuranceCompany_Local_Address,  
  ins.InsuranceCompany_Local_City,  
  ins.InsuranceCompany_Local_State,  
  ins.InsuranceCompany_Local_Zip,  
  cas.Indexoraaa_number,  
  tre.Claim_Amount,  
  tre.Fee_Schedule,  
  cas.Status,  
  cas.Accident_Date,    
  cas.Initial_Status,  
  pro.Provider_GroupName,  
  tre.Paid_Amount,  
  tre.WriteOff,  
  cas.Ins_Claim_Number,  
  Cas.Date_Opened,  
  Cas.Date_Status_Changed  
    
 ORDER BY cas.Case_AutoId asc
 --,InsuranceCompany_Name, InjuredParty_LastName,InjuredParty_FirstName,DateOfService_Start,Provider_Name desc  
--DBCC FREEPROCCACHE  
--DBCC DROPCLEANBUFFERS    
END  
