
CREATE PROCEDURE [dbo].[LCJ_WorkArea_SearchCaseSimple]  
-- [LCJ_WorkArea_SearchCaseSimple] @DomainId = 'AF' , @SZ_USER_ID= 4088  
     
(  
@strCaseId                              nvarchar(50)='',  
@Status                                 nvarchar(50)='',  
@InjuredParty_LastName                nvarchar(50)='',  
@InjuredParty_FirstName                nvarchar(50)='',  
@InsuredParty_LastName               nvarchar(50)='',  
@InsuredParty_FirstName               nvarchar(50)='',  
@Policy_Number                          nvarchar(100)='',  
@Ins_Claim_Number                       nvarchar(100)='',  
@IndexOrAAA_Number                   nvarchar(100)='',  
@Provider_Id       int=0,  
@InsuranceCompany_Id     int=0,  
@SZ_USER_ID      int=0,  
@AssignedValue      int =0,  
@DenialReasons_Id     int=0,  
@s_a_Rebuttal_Status			nvarchar(100)='', 
@DomainId        NVARCHAR(50)='CC'  
,@PortfolioId int =0  
,@AttorneyFirmId int =0  
,@Reference_CaseId varchar(50)=''
,@InitialStatus varchar(100)=''
,@AccidentDate nvarchar(100) = ''
,@strBill_No    nvarchar(100)=''
)  
AS  
begin 
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 
SET @strCaseId=(LTRIM(RTRIM(@strCaseId)))  
   
DECLARE @strsql_cursor as nvarchar(max)    
DECLARE @strsql as nvarchar(max)  
DECLARE @InvestorId AS INT = 0  
SELECT @InvestorId=InvestorId FROM Tbl_Investor WHERE UserId = @SZ_USER_ID 
 


select  tblCase.Case_Id  as Edit, Case_Id,   
(InjuredParty_LastName + ',' + InjuredParty_FirstName) as InjuredParty_Name,  
Provider_Name,
--Provider_GroupName,
InsuranceCompany_Name,
--InsuranceCompany_GroupName,
 
convert(varchar, Accident_Date, 101) as Accident_Date,  
convert(varchar, ISNULL(tblCase.DateOfService_Start,''),101) as DateOfService_Start,  
convert(varchar, ISNULL(tblCase.DateOfService_End,''),101) as DateOfService_End,  
Status,  
Rebuttal_Status,
Ins_Claim_Number,  
convert(decimal(38,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount)))) as Claim_Amount,  
-- dbo.fncGetBillNumber(tblCase.Case_id) As BillNumber,
--(select top 1 bill_number from tblTreatment where ISNULL(bill_number,'') <> '' and case_id = tblcase.case_id and domainid = tblcase.DomainId) as BillNumber,
'' as BillNumber,
convert(varchar, ISNULL(tblCase.Date_Opened,''),101) as Date_Opened,
IndexOrAAA_Number,  
tblCase.Initial_Status,
(Select top 1 a.Case_Id FROM  tblCase a WHERE a.Provider_Id =tblcase.Provider_Id  and a.InjuredParty_LastName =tblcase.InjuredParty_LastName  
and a.InjuredParty_FirstName = tblcase.InjuredParty_FirstName and  a.Accident_Date =tblcase.Accident_Date   
and a.Case_Id <> tblcase.case_id) AS Similar_To_Case_ID  
,AF.Name AttorneyFirmName, PF.Name PortfolioName  
,ISNULL(tblCase.case_code,'') AS Reference_CaseId
From tblcase as tblcase  (NOLOCK)
left join tblprovider  as tblprovider (NOLOCK) on tblcase.provider_id=tblprovider.provider_id   
left join tblinsurancecompany as tblinsurancecompany (NOLOCK) on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id   
left join tbl_portfolio PF (NOLOCK)on tblcase.PortfolioId=PF.id   
left join tbl_AttorneyFirm AF (NOLOCK) on tblcase.AttorneyFirmId=AF.id  
WHERE tblcase.DomainId= @DomainId  
  AND (@strCaseId ='' or tblcase.Case_Id Like '%' + @strCaseId + '%')    
  AND (@Reference_CaseId ='' OR tblCase.case_code like '%' + @Reference_CaseId + '%')  
  AND (STATUS = @Status OR @Status = '' OR @Status = '0' OR @Status = 'all')  
  AND (@s_a_Rebuttal_Status = '' OR Rebuttal_Status = @s_a_Rebuttal_Status)  
  AND (@InjuredParty_LastName = '' or InjuredParty_LastName Like '%' + @InjuredParty_LastName + '%')   
  AND (@InjuredParty_FirstName = '' or InjuredParty_FirstName Like '%' + @InjuredParty_FirstName + '%')  
  AND (@InsuredParty_LastName = '' or InsuredParty_LastName Like '%' + @InsuredParty_LastName + '%')  
  AND (@InsuredParty_FirstName = '' or InsuredParty_FirstName Like '%' + @InsuredParty_FirstName + '%')    
  AND (@Policy_Number='' or  Policy_Number= @Policy_Number )       
  AND (@Ins_Claim_Number='' or  Ins_Claim_Number= @Ins_Claim_Number )       
  AND (@Ins_Claim_Number='' or  Ins_Claim_Number= @Ins_Claim_Number )   
  and (@IndexOrAAA_Number = '' or IndexOrAAA_Number LIKE '%' + @IndexOrAAA_Number + '%')   
  and (@Provider_Id = 0 or  tblcase.Provider_ID = @Provider_Id )   
  AND (@InsuranceCompany_Id = 0  OR tblcase.InsuranceCompany_Id  =  @InsuranceCompany_Id)   
  and (@AssignedValue = 0 or tblCase.UserId = @SZ_USER_ID ) 
  and (@strBill_No ='' or Case_Id in (select Case_Id from tbltreatment where BILL_NUMBER  Like '%' + @strBill_No + '%')) 
  and ( @DenialReasons_Id = 0   
  OR case_id in ( select distinct case_id   
      from tbltreatment where DenialReason_Id =@DenialReasons_Id  AND DomainId= @DomainId
      OR treatment_id in(select treatment_id   
           from TXN_tblTreatment   
           where DenialReasons_id= @DenialReasons_Id  AND DomainId= @DomainId ))  
      
   ) 

  AND (@PortfolioId=0 OR tblcase.PortfolioId= @PortfolioId)  
  AND (@AttorneyFirmId=0 OR tblcase.AttorneyFirmId=@AttorneyFirmId)  
  AND (@InvestorId = 0 OR tblcase.portfolioid in (SElect portfolioid from tbl_InvestorPortfolio IP WHERE IP.InvestorId =@InvestorId))  
   And (Initial_Status = '' OR Initial_Status LIKE '%' + @InitialStatus + '%')   
  AND (convert(varchar, Accident_Date, 101) like '%' + @AccidentDate + '%')   
   order by case_autoid desc   
end  
  

