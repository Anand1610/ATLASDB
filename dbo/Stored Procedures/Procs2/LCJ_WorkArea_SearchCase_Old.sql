
--**************** Start of Procedure LCJ_WorkArea_SearchCase **********************
CREATE PROCEDURE [dbo].[LCJ_WorkArea_SearchCase_Old] 
--[LCJ_WorkArea_SearchCase] '','0','','','0','0','','','','0','S','admin','0','','','0','','','1','','0',''
  (  
  
--@FilterValue    varchar(10),  
@strCaseId                 nvarchar(50),  
@Status                    nvarchar(500),  
@InjuredParty_LastName     nvarchar(100),  
@InsuredParty_LastName     nvarchar(100),  
@InsuranceCompany_Id       nvarchar(200),  
@Provider_Id               nvarchar(200),  
@Policy_Number             nvarchar(100),  
@Ins_Claim_Number          nvarchar(100),  
@IndexOrAAA_Number         nvarchar(100),  
@Court_Id                  int,  
@UserType				   nvarchar(10),  
@UserTypeLogin			   nvarchar(100),  
@Attorney_Id			   nvarchar(100),
@Initial_Status			   nvarchar(100),
@Provider_Group			   nvarchar(500),
@PeerReviewDoc	nvarchar(100),			
@DOSStart_Date nvarchar(10),
@DOSEnd_Date nvarchar(10),
@Location nvarchar(100),
@Action_ID nvarchar(100),
@DenialReasons_Id int,
@DenialReasons_Type Nvarchar(100)
)  
  
AS  
DECLARE @strsql as varchar(8000)  
begin  
if(@DenialReasons_Id  = 41 )
	set @DenialReasons_Id = 0



set @strsql = 'select top 5000
Case_Id as cases,CASE  WHEN provider_groupname=''GBB'' and abs(datediff(dd,Accident_Date,DateOfService_Start))<30
    		THEN ''<font color=red>''+Case_Id+''</font> '' 
			WHEN provider_groupname=''GBB'' and abs(datediff(dd,Accident_Date,DateOfService_Start))>45
			THEN ''<font color=red>''+Case_Id+''</font> ''
			WHEN provider_groupname=''GBB'' and abs(datediff(dd,Accident_Date,DateOfService_Start)) between 30 and 45
			THEN ''<font color=green>''+Case_Id+''</font> ''
            else case_id END
as Case_Id,Case_Code,Last_Status,   
InjuredParty_LastName + '', '' + InjuredParty_FirstName as [InjuredParty_Name],  
Provider_Name + ISNULL('' [ '' + Provider_Groupname + '' ]'','''') as Provider_Name,  
InsuranceCompany_Name,  
Indexoraaa_number, 
CONVERT(VARCHAR(10),Accident_Date,101) AS Accident_Date,
convert(decimal(38,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount)))) as Claim_Amount,
Status,  
Ins_Claim_Number, 
(select convert(varchar, min(DateOfService_Start),101) from tbltreatment where case_id=tblcase.case_id) + '' - '' +
(select convert(varchar, max(DateOfService_End),101) from tbltreatment where case_id=tblcase.case_id) as DateOfService, 
INITIAL_STATUS,
(select dbo.[fncGetPeerReviewDoctor](tblcase.case_id)) as Doctor_Name,
tblcase.insurancecompany_id,
tblcase.Provider_Id,
case_autoid,
Provider_Groupname,
CASE WHEN (date_status_Changed is null) THEN datediff(dd,date_opened,getdate()) ELSE datediff(dd,date_status_Changed,getdate())  END as Status_Age,
isnull((select location_address from mst_service_rendered_location where location_id=tblcase.location_id),'''') as Location_Address,
convert(decimal(38,2),(SELECT SUM(Transactions_Amount) FROM dbo.tblTransactions WHERE Case_id = tblcase.case_id)) as Transactions_Amount,
convert(decimal(38,2),(select sum(Settlement_Amount) FROM tblsettlements WHERE Case_id = tblcase.case_id)) as Settlement_Amount,
convert(decimal(38,2),(select sum(Settlement_AF) FROM tblsettlements WHERE Case_id = tblcase.case_id)) as Settlement_AF,
convert(decimal(38,2),(select sum(Settlement_FF) FROM tblsettlements WHERE Case_id = tblcase.case_id)) as Settlement_FF, 
(Select top 1 a.Case_Id FROM  tblCase a WHERE a.Provider_Id =tblcase.Provider_Id  and a.InjuredParty_LastName =tblcase.InjuredParty_LastName
and a.InjuredParty_FirstName = tblcase.InjuredParty_FirstName and  a.Accident_Date =tblcase.Accident_Date  
 and a.Case_Id <> tblcase.case_id) AS Similar_To_Case_ID,
(Select top 1 a.Case_Id +'' ''+Initial_Status+''/''+ Status  FROM  tblCase a WHERE a.Provider_Id =tblcase.Provider_Id  and a.InjuredParty_LastName =tblcase.InjuredParty_LastName
and a.InjuredParty_FirstName = tblcase.InjuredParty_FirstName and  a.Accident_Date =tblcase.Accident_Date  
 and a.Case_Id <> tblcase.case_id) AS Similar_To
From tblcase inner join tblprovider on tblcase.provider_id=tblprovider.provider_id 
inner join tblinsurancecompany on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id
WHERE 1=1 '  
  
if @strCaseId <> ''  
begin  
	set @strsql = @strsql + ' AND Case_Id Like ''%' + @strCaseId + '%'''               
end  
  
if @Status <> '' and @Status <> '0'  
begin  
	set @strsql = @strsql + '  AND STATUS = ''' + @Status + ''''         
end 

if @Initial_Status <> '' and @Initial_Status <> '0' and @Initial_Status <> '...Select Status...'
begin
	set @strsql = @strsql + '  AND INITIAL_STATUS = ''' + @Initial_Status + ''''
end
if @InjuredParty_LastName <> ''   
begin  
	set @strsql = @strsql + '  AND (InjuredParty_FirstName Like ''%' + @InjuredParty_LastName + '%'' or InjuredParty_LastName like ''%' + @InjuredParty_LastName + '%'')'           
end  
  
if @InsuredParty_LastName <> ''   
begin  
	set @strsql = @strsql + '  AND (InsuredParty_LastName Like ''%' + @InsuredParty_LastName + '%'' or InsuredParty_FirstName like ''%' + @InsuredParty_LastName + '%'')'  
end
  
if @InsuranceCompany_Id <> '0' and @InsuranceCompany_Id <> '' and @InsuranceCompany_Id <> '''0''' and @InsuranceCompany_Id <> '''''' and @InsuranceCompany_Id <> '...Select Insurance Company...'
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
  
if @IndexOrAAA_Number <> ''  
begin                
	set @strsql = @strsql + '  AND IndexOrAAA_Number LIKE ''%' + @IndexOrAAA_Number + '%'''  
end  
  
if @Provider_Group <> ''
begin
	set @strsql = @strsql + '  AND tblcase.Provider_Id in (select Provider_id from tblprovider where Provider_GroupName = ''' + @Provider_Group + ''')'
end
  
--if @PeerReviewDoc <> '' and @PeerReviewDoc <> '0'
--begin
--	set @strsql = @strsql + '  AND tblcase.case_id in(select distinct (case_id) from tbltreatment where treatment_id in (select TREATMENT_ID from TXN_CASE_PEER_REVIEW_DOCTOR where doctor_id in (select doctor_id from TblReviewingDoctor where doctor_id = ''' + @PeerReviewDoc + ''')))'
--end 

if @Court_Id <> 0  and @Court_Id <> 1
begin  
	set @strsql = @strsql + '  AND Court_Id = ' + str(@Court_Id)  
end  
  
--if @userType = 'P'  
--begin
--	set @strsql = @strsql + ' AND tblcase.Provider_Id = ''' + @userTypeLogin + ''''  
--end  
  
   
--else if @userType = 'I'  
--begin  
--	set @strsql = @strsql + ' AND tblcase.InsuranceCompany_Id = ''' + @userTypeLogin + ''''  
--end  
   
--else if @userType = 'S'  
--begin  
--	set @strsql = @strsql  
--end  
  
--if @Attorney_Id <> '0' and @Attorney_Id <> '' and @Attorney_Id <> '486'  
--begin  
--	set @strsql = @strsql + '  AND defendant_Id = ''' + @Attorney_Id + ''''  
--end

--if @Location <> '' and @Location <> '1'
--begin  
--	set @strsql = @strsql + '  AND tblcase.location_id = ''' + @Location + ''''  
--end

if @DOSStart_Date<>'' and @DOSEnd_Date<> ''
Begin
	set @strsql = @strsql + '  AND case_id in (select distinct (case_id) as case_id from tbltreatment where DateOfService_Start >= ''' + @DOSStart_Date + '''and DateOfService_Start <= ''' + @DOSEnd_Date + ''')'
End
  
if (@DenialReasons_Id <> 0 and @DenialReasons_Id <> 1)
BEGIN
	set @strsql = @strsql + '  AND case_id in (select distinct case_id from tbltreatment where DenialReason_Id ='''+convert(nvarchar(200),@DenialReasons_Id)+'''
								or treatment_id in(select treatment_id from TXN_tblTreatment where DenialReasons_id='''+convert(nvarchar(200),@DenialReasons_Id)+'''))'

END


if @Action_ID <> ''  
begin  
	set @strsql = @strsql + ' AND tblcase.case_id in (select distinct case_id from tbltreatment where action_type ='''+ @Action_ID +'''
or treatment_id in(select treatment_id from TXN_tblTreatment where action_type='''+ @Action_ID +'''))' 
end 

SET @strsql = @strsql + '  order by case_autoid desc'  
print(@strsql)

--ALTER table #temp
--(Case_Id nvarchar(20),
--Case_Code nvarchar(20),   
--InjuredParty_Name nvarchar(200),  
--Provider_Name nvarchar(200),  
--InsuranceCompany_Name nvarchar(200),  
--Indexoraaa_number nvarchar(30),  
--Claim_Amount nvarchar(30),
--Status nvarchar(100),  
--Ins_Claim_Number nvarchar(100), 
--DateOfService nvarchar(100), 
--INITIAL_STATUS nvarchar(100),
--Doctor_Name nvarchar(500),
--insurancecompany_id int,
--Provider_Id int,
--case_autoid int,
--Provider_Groupname nvarchar(200),
--Location_Address nvarchar(200)
--)
--insert into #temp
print (@strsql)
exec (@strsql)


--update #temp
--set Doctor_Name = dbo.[fncGetPeerReviewDoctor](#temp.case_id)
--
--select * from #temp
--drop table #temp
end

