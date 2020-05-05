CREATE PROCEDURE [dbo].[LCJ_WorkArea_AAASearch]--[LCJ_WorkArea_AAASearch] '','','','','',6,'45 DAY RULE'
(
@Provider Nvarchar(100),
@carrier Nvarchar(100),
@AAA_Decision Nvarchar(100),
@Arbitrator Nvarchar(100),
@Service_Type Nvarchar(100),
@DenialReasons_Id int,
@DenialReasons_Type Nvarchar(100)
)

AS  
DECLARE @strsql_cursor as varchar(8000)  
DECLARE @strsql as varchar(8000)
begin
set @strsql_cursor = '  select  
tblcase.Case_Id, 
Case_Code,  
(InjuredParty_LastName + '', '' + InjuredParty_FirstName) as InjuredParty_Name,
Provider_Name,
InsuranceCompany_Name,
convert(varchar, Accident_Date, 101) as Accident_Date,
ISNULL(convert(varchar, tblcase.DateOfService_Start,101),'''') as DateOfService_Start,
ISNULL(convert(varchar, tblcase.DateOfService_End,101),'''') as DateOfService_End,
Status,
Ins_Claim_Number,
round(convert(money,convert(float,tblcase.Claim_Amount) - convert(float,tblcase.Paid_Amount)),2) as Claim_Amount
From tblcase inner join tblprovider on tblcase.provider_id=tblprovider.provider_id inner join tblinsurancecompany on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id left join tbltreatment on tblcase.Case_id = tbltreatment.Case_id left join TXN_tblTreatment on tbltreatment.Treatment_Id = TXN_tblTreatment.Treatment_Id WHERE 1=1 '  

if @Provider <> ''  
begin                
    set @strsql_cursor = @strsql_cursor + ' AND tblprovider.provider_id=''' + @Provider + ''''   
end  
if @carrier <> ''  
begin  
     set @strsql_cursor = @strsql_cursor + '  AND tblinsurancecompany.insurancecompany_id = ''' + @carrier + ''''         
end  
if @AAA_Decision <> ''   
begin  
      set @strsql_cursor = @strsql_cursor + '  AND tblcase.AAA_Decision=''' + @AAA_Decision + ''''           
end    
if @Arbitrator <> ''
begin  

      set @strsql_cursor = @strsql_cursor + '  AND tblcase.Arbitrator_id=''' + @Arbitrator + ''''  
end  
  
if @Service_Type <> ''   
begin  
               set @strsql_cursor = @strsql_cursor + '  AND tbltreatment.SERVICE_TYPE=''' + @Service_Type + ''''  
end    

if (@DenialReasons_Id <> 0)
BEGIN
	set @strsql_cursor = @strsql_cursor + ' AND tblcase.case_id in (select DISTINCT Case_Id from tbltreatment
	inner join TXN_tblTreatment on tblTreatment.Treatment_Id = TXN_tblTreatment.Treatment_Id
	where TXN_tblTreatment.DenialReasons_Id  ='''+convert(nvarchar(200),@DenialReasons_Id)+''')'

END
  
SET @strsql_cursor = @strsql_cursor + ' Group BY tblcase.Case_Id , Case_Code ,  InjuredParty_LastName , InjuredParty_FirstName ,Provider_Name , InsuranceCompany_Name , Accident_Date,tblcase.DateOfService_Start,tblcase.DateOfService_End,Status,Ins_Claim_Number, tblcase.Claim_Amount , tblcase.Paid_Amount , case_autoid order by case_autoid desc'   
  
print @strsql_cursor 
exec (@strsql_cursor)

end
--**************** End of Procedure LCJ_WorkArea_SearchCaseSimple **********************

