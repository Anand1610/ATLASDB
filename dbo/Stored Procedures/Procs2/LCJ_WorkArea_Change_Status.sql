CREATE PROCEDURE [dbo].[LCJ_WorkArea_Change_Status]
--[LCJ_WorkArea_Change_Status] '','','','','0','0','','','','','S','tech','','','','310','','','1','','0',''

--[LCJ_WorkArea_Change_Status] 'FH07-42372','','','','0','0','','','','','S','tech','0','','','0','','','1','','0',''
--[LCJ_WorkArea_Change_Status] '','','pri','','','0','','','','','S','tech','','','','0','','','1','','0','','Case_ID',''
  (  
@domainId				   nvarchar(50),
@strCaseId                 nvarchar(Max),  
@Status                    nvarchar(max),  
@InjuredParty_LastName     nvarchar(50),  
@InsuredParty_LastName     nvarchar(50),  
@InsuranceCompany_Id       nvarchar(200),  
@Provider_Id               nvarchar(200),  
@Policy_Number             nvarchar(100),  
@Ins_Claim_Number          nvarchar(100),  
@IndexOrAAA_Number         nvarchar(max),  
@Court_Id                  nvarchar(100),  
@UserType				   nvarchar(10),  
@UserTypeLogin			   nvarchar(100),  
@Attorney_Id			   nvarchar(100),
@Initial_Status			   nvarchar(200),  
@Provider_Group			   nvarchar(500),
@PeerReviewDoc	nvarchar(100),			
@DOSStart_Date nvarchar(10),
@DOSEnd_Date nvarchar(10),
@Location nvarchar(200),
@Action_ID nvarchar(100),
@DenialReasons_Id int,
@DenialReasons_Type Nvarchar(100),
@strMultipleField Nvarchar(max),
@strMultipleValues Nvarchar(max)
)  
  
AS  
DECLARE @strsql as varchar(8000)  
DECLARE @MultipleValues AS NVARCHAR(MAX)
set @MultipleValues=REPLACE(@strMultipleValues,',',''',''')
begin  
if(@DenialReasons_Id  = 41 )
	set @DenialReasons_Id = 0


set @strsql = 'select top 5000
Case_Id as cases, case_id as Case_Id,Case_Code,Last_Status,   
InjuredParty_LastName + '', '' + InjuredParty_FirstName as [InjuredParty_Name],  
Provider_Name + ISNULL('' [ '' + Provider_Groupname + '' ]'','''') as Provider_Name,  
InsuranceCompany_Name,
Court_Name,
Initial_Status,
Indexoraaa_number,  
convert(decimal(38,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount)))) as Claim_Amount,
Status,  
Ins_Claim_Number, 
(select convert(varchar, min(DateOfService_Start),101) from tblTreatment where case_id=tblcase.case_id and DomainId=tblcase.DomainId) + '' - '' +
(select convert(varchar, max(DateOfService_End),101) from tblTreatment where case_id=tblcase.case_id and DomainId=tblcase.DomainId) as DateOfService, 
INITIAL_STATUS,
(select dbo.[fncGetPeerReviewDoctor](@domainId, tblcase.case_id)) as Doctor_Name,
tblcase.insurancecompany_id,
tblcase.Provider_Id,
case_autoid,
Provider_Groupname,
convert(varchar,Accident_Date,101) AS Accident_Date,
CASE WHEN (date_status_Changed is null) THEN datediff(dd,date_opened,getdate()) ELSE datediff(dd,date_status_Changed,getdate())  END as Status_Age,
isnull((select location_address from MST_Service_Rendered_Location where DomainId=tblcase.DomainId and location_id=tblcase.location_id),'''') as Location_Address,
convert(decimal(38,2),(SELECT SUM(Transactions_Amount) FROM dbo.tblTransactions WHERE DomainId=tblcase.DomainId and Case_id = tblcase.case_id)) as Transactions_Amount,
convert(decimal(38,2),(select sum(Settlement_Amount) FROM tblSettlements WHERE DomainId=tblcase.DomainId and Case_id = tblcase.case_id)) as Settlement_Amount,
convert(decimal(38,2),(select sum(Settlement_AF) FROM tblSettlements WHERE DomainId=tblcase.DomainId and Case_id = tblcase.case_id)) as Settlement_AF,
convert(decimal(38,2),(select sum(Settlement_FF) FROM tblSettlements WHERE DomainId=tblcase.DomainId and Case_id = tblcase.case_id)) as Settlement_FF, 
(select top 1 CONVERT(varchar,Event_Date,101) from tblEvent where DomainId=tblcase.DomainId and EventTypeId=19 and Case_Id=tblcase.Case_Id order by Event_Date desc)[Hearing_Date],
(select top 1 CONVERT(varchar,Event_Date,101) from tblEvent where DomainId=tblcase.DomainId and EventTypeId=14 and Case_Id=tblcase.Case_Id order by Event_Date desc)[Trial_Date],
(select top 1 CONVERT(varchar,Event_Date,101) from tblEvent where DomainId=tblcase.DomainId and EventTypeId=15 and Case_Id=tblcase.Case_Id order by Event_Date desc)[Motion_Date],
  Opened_By,

  CONVERT(VARCHAR,Date_Opened,101) Date_Opened
From tblcase inner join tblprovider on tblcase.provider_id=tblprovider.provider_id and tblcase.DomainId=tblprovider.DomainId
inner join tblinsurancecompany on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id and 
left outer join tblcourt on tblcourt.court_id=tblcase.court_id
WHERE 1=1 AND tblcase.DomainId = '''+@domainId  +''''
  
 if @strMultipleField = 'Case_ID' and @strMultipleValues <> ''
 begin
 set @strsql = @strsql + ' AND Case_Id in(''' + @MultipleValues + ''')'
 end
  if @strMultipleField = 'IndexOrAAAOrNAM'
 begin
 set @strsql = @strsql + '  AND IndexOrAAA_Number in ( ''' + @MultipleValues + ''')' 
 end
if @strCaseId <> ''  
begin  
	set @strsql = @strsql + ' AND Case_Id like ''%' + @strCaseId + '%'''           
end  
if @Status <> '' and @Status <> '0'  --and @Status <> '''0'''  
begin  
	set @strsql = @strsql + '  AND STATUS IN (' + @Status + ')'            
end 

if @Initial_Status <> '' and @Initial_Status <> '0' and @Initial_Status <> '...Select Status...'
begin
	set @strsql = @strsql + '  AND INITIAL_STATUS  in (' + @Initial_Status +')'
end
if @InjuredParty_LastName <> ''   
begin  
	set @strsql = @strsql + '  AND (InjuredParty_FirstName Like ''%' + @InjuredParty_LastName + '%'' or InjuredParty_LastName like ''%' + @InjuredParty_LastName + '%'')'           
end  
  
if @InsuredParty_LastName <> ''   
begin  
	set @strsql = @strsql + '  AND (InsuredParty_LastName Like ''%' + @InsuredParty_LastName + '%'' or InsuredParty_FirstName like ''%' + @InsuredParty_LastName + '%'')'  
end
  
if @InsuranceCompany_Id <> '0' and @InsuranceCompany_Id <> '' and @InsuranceCompany_Id <> '''0''' and @InsuranceCompany_Id <> ''''''
begin  
	set @strsql = @strsql + '  AND tblcase.InsuranceCompany_Id IN (' + @InsuranceCompany_Id + ')'  
end  
  
  
if @Provider_Id <> '0' and @Provider_Id <> '' and @Provider_Id <> '''0''' and @Provider_Id <> ''''''
begin  
	set @strsql = @strsql + '  AND tblcase.Provider_Id IN (' + @Provider_Id + ')'  
end 
  
if @Policy_Number <> ''  
begin  
	set @strsql = @strsql + '  AND Policy_Number like ''%' + @Policy_Number + '%'''  
end  
  
  
if @Ins_Claim_Number <> ''  
begin  
	set @strsql = @strsql + '  AND Ins_Claim_Number like ''%' + @Ins_Claim_Number + '%'''  
end  
  
if  @IndexOrAAA_Number <> ''  
begin                
	set @strsql = @strsql + '  AND IndexOrAAA_Number like ''%' + @IndexOrAAA_Number + '%'''  
end  
  
if @Provider_Group <> '' and @Provider_Group <> '0'
begin
	set @strsql = @strsql + '  AND tblcase.Provider_Id in (select Provider_id from tblprovider where Provider_GroupName in  (' + @Provider_Group + '))'
end
  
if @PeerReviewDoc <> '' AND  @PeerReviewDoc <> '0'
begin
	set @strsql = @strsql + '  AND tblcase.case_id in(select distinct (case_id) from tbltreatment where treatment_id in (select TREATMENT_ID from TXN_CASE_PEER_REVIEW_DOCTOR where doctor_id in ( ''' + @PeerReviewDoc + ''')))'
end 

if @Court_Id <> '0' and @Court_Id <> ''
begin  
		set @strsql = @strsql + '  AND tblcase.Court_Id in (' + @Court_Id +')' 
end  
  
if @userType = 'P'  
begin
	set @strsql = @strsql + ' AND tblcase.Provider_Id = ''' + @userTypeLogin + ''''  
end  
  
   
else if @userType = 'I'  
begin  
	set @strsql = @strsql + ' AND tblcase.InsuranceCompany_Id = ''' + @userTypeLogin + ''''  
end  
   
else if @userType = 'S'  
begin  
	set @strsql = @strsql  
end  
  
if @Attorney_Id <> '0' and @Attorney_Id <> '' and @Attorney_Id <> '486'  
begin  
	set @strsql = @strsql + '  AND defendant_Id in (' + @Attorney_Id + ')'  
end

if @Location <> '' and @Location <> '1'
begin  
	set @strsql = @strsql + '  AND tblcase.location_id = ''' + @Location + ''''  
end

if @DOSStart_Date<>'' and @DOSEnd_Date<> ''
Begin
	set @strsql = @strsql + '  AND case_id in (select distinct (case_id) as case_id from tbltreatment where DateOfService_Start >= ''' + @DOSStart_Date + '''and DateOfService_Start <= ''' + @DOSEnd_Date + ''')'
End
  
if (@DenialReasons_Id <> 1)
BEGIN
	set @strsql = @strsql + ' AND tblcase.case_id in (select DISTINCT Case_Id from tbltreatment
	inner join TXN_tblTreatment on tblTreatment.Treatment_Id = TXN_tblTreatment.Treatment_Id
	where TXN_tblTreatment.DenialReasons_Id  ='''+convert(nvarchar(200),@DenialReasons_Id)+''')'

END

if @Action_ID <> ''  
begin  
	set @strsql = @strsql + ' AND tblcase.case_id in (select distinct case_id from tbltreatment where action_type ='''+ @Action_ID +'''
or treatment_id in(select treatment_id from TXN_tblTreatment where action_type='''+ @Action_ID +'''))' 
end 

SET @strsql = @strsql + '  order by case_autoid desc'  

print (@strsql)
exec (@strsql)

end

