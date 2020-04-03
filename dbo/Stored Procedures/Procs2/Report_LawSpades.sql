

CREATE PROCEDURE [dbo].[Report_LawSpades]  

     
(  
@s_a_Report_Type Varchar(200),
@strCaseId                              nvarchar(50)='',   
@InjuredParty_LastName                nvarchar(50)='',  
@InjuredParty_FirstName                nvarchar(50)='',   
@IndexOrAAA_Number                   nvarchar(100)='',  
 
@DomainId        NVARCHAR(50)=''
)  
AS  
begin  
SET @strCaseId=(LTRIM(RTRIM(@strCaseId)))  
   
  
    
DECLARE @strsql as nvarchar(max)  
SET NOCOUNT ON;

DECLARE @tblCaseTemp AS TABLE
(
	Case_Id VARCHAR(100)
)

INSERT INTO @tblCaseTemp
select items FROM dbo.STRING_SPLIT(@strCaseId,',')


DECLARE @tblCaseTemp1 AS TABLE
(
	IndexOrAAA_Number VARCHAR(100)
)

INSERT INTO @tblCaseTemp1
select items FROM dbo.STRING_SPLIT(@IndexOrAAA_Number,',')





    IF(@s_a_Report_Type = 'IndexNumber_Report')
    BEGIN
		 SELECT distinct   v.Case_Id AS CASEID
            --, InjuredParty_Name AS [PATIENT NAME]
               ,(InjuredParty_LastName + ',' + InjuredParty_FirstName) as [PATIENT NAME]
            , Provider_Name AS [PROVIDER NAME]
			,InsuranceCompany_Name
			,Claim_Amount
          
			,Paid_Amount

			 ,(convert(decimal(38,2),Claim_Amount)-convert(decimal(38,2),Paid_Amount))[Balance]
			  ,(select top 1 [User_Id] from tblNotes WHERE Case_Id= v.Case_Id And Notes_Desc like '%Case Opened%'  order by Notes_ID desc) AS OPENED_BY
           , Date_Opened
, Accident_Date AS [DATE OF ACCIDENT],
   --, DOS_Start AS [DATE OF SERVICE START]
   --         , DOS_End AS [DATE OF SERVICE END]
            
            ISNULL(convert(varchar, DateOfService_Start,101),'') as DOS_Start,
ISNULL(convert(varchar, DateOfService_End,101),'') as DOS_End

			, Initial_Status AS [CASE STATUS]
            , Status AS [STATUS]
         
			, DBO.FNCGETDENIALREASONS(v.CASE_ID) [DENIAL REASONS]
		
			,IndexOrAAA_Number[Index/aaa/nam #]

		   , STUFF((SELECT distinct ',' + p1.Service_type FROM tblTreatment p1 WHERE v.Case_Id = p1.Case_Id FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,1,'') [Service Type]
  ,(Select COUNT(*) from [dbo].[tblTreatment] T  WHERE T.[Case_Id]= v.Case_Id ) AS BILL_NUMBER_Count
            FROM dbo.tblcase v
inner join tblProvider  on v.provider_id=tblProvider.provider_id and v.DomainId=tblProvider.DomainId
inner join tblInsuranceCompany  on v.insurancecompany_id=tblInsuranceCompany.insurancecompany_id  and v.DomainId=tblInsuranceCompany.DomainId

  WHERE 1=1  
  
 and v.DomainId= @DomainId  AND ISNULL(v.IsDeleted,0) = 0
  --AND (@strCaseId ='' or v.Case_Id IN ('' + @strCaseId + ''))   
 AND (@strCaseId ='' OR v.Case_Id in (SELECT Case_Id FROM @tblCaseTemp))

  AND (@InjuredParty_LastName = '' or InjuredParty_LastName Like '%' + @InjuredParty_LastName + '%')   
  AND (@InjuredParty_FirstName = '' or InjuredParty_FirstName Like '%' + @InjuredParty_FirstName + '%')  
  
  --and (@IndexOrAAA_Number = '' or IndexOrAAA_Number IN (@IndexOrAAA_Number))
  AND (@IndexOrAAA_Number ='' OR v.IndexOrAAA_Number in (SELECT IndexOrAAA_Number FROM @tblCaseTemp1)) 
 
END 

END 
  

