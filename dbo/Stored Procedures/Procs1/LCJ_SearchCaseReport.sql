CREATE PROCEDURE [dbo].[LCJ_SearchCaseReport] 
  (   
	@DomainId				   nvarchar(50),
	@strCaseId                 nvarchar(50),  
	@Status                    nvarchar(50),  
	@InjuredParty_LastName     nvarchar(50),  
	@InsuredParty_LastName     nvarchar(50),  
	@InsuranceCompany_Id       nvarchar(200),  
	@Provider_Id               nvarchar(200),  
	@Policy_Number             nvarchar(100),  
	@Ins_Claim_Number          nvarchar(100),  
	@IndexOrAAA_Number         nvarchar(100), 
	@Initial_Status			   nvarchar(100),
	@Provider_Group			   nvarchar(500)
)  
  --select * from tblnotes
AS  
DECLARE @strsql as varchar(8000)  
begin  

set @strsql = 'select top 5000
tblcase.Case_Id,Case_Code, 
Initial_status, 
InjuredParty_LastName + '', '' + InjuredParty_FirstName as [InjuredParty_Name],  
Provider_Name + ISNULL('' [ '' + Provider_Groupname + '' ]'','''') as Provider_Name,  
InsuranceCompany_Name,  
Indexoraaa_number,  
convert(decimal(38,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount)))) as Claim_Amount,
Status,  
Ins_Claim_Number, 
(select convert(varchar, min(DateOfService_Start),101) from tbltreatment where case_id=tblcase.case_id) + '' - '' +
(select convert(varchar, max(DateOfService_End),101) from tbltreatment where case_id=tblcase.case_id) as DateOfService, 
INITIAL_STATUS,
(select dbo.[fncGetPeerReviewDoctor](@DomainId,tblcase.case_id)) as Doctor_Name,
tblcase.insurancecompany_id,
tblcase.Provider_Id,
case_autoid,
Provider_Groupname,
(convert(nvarchar,date_opened,101))as case_opened,
User_Id as CaseOpened_Name,
isnull((select location_address from mst_service_rendered_location where location_id=tblcase.location_id),'''') as Location_Address,
(select dbo.[fncISAOB](tblcase.case_id)) as AOB
From tblcase  AS tblcase inner join tblprovider  AS tblprovider on tblcase.provider_id=tblprovider.provider_id 
inner join tblinsurancecompany  AS tblinsurancecompany on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id
left outer join tblDenialReasons on tblDenialReasons.DenialReasons_type=tblcase.DenialReasons_type
left outer  join tblAction on tblAction.Denialreasons_Id=tblDenialReasons.Denialreasons_Id
inner join (select distinct case_id,max(user_id) as user_id from tblnotes where notes_desc=''Case Opened'' group by case_id)tblnotes
on tblnotes.case_id=tblcase.case_id
WHERE 1=1 AND '''+@DomainId+''' = tblcase.DomainId '  
  
if @strCaseId <> ''  
begin  
	set @strsql = @strsql + ' AND tblcase.Case_Id Like ''%' + @strCaseId + '%'''               
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
  
if @IndexOrAAA_Number <> ''  
begin                
	set @strsql = @strsql + '  AND IndexOrAAA_Number LIKE ''%' + @IndexOrAAA_Number + '%'''  
end  
  
if @Provider_Group <> ''
begin
	set @strsql = @strsql + '  AND tblcase.Provider_Id in (select Provider_id from tblprovider where Provider_GroupName = ''' + @Provider_Group + ''')'
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
exec (@strsql)


--update #temp
--set Doctor_Name = dbo.[fncGetPeerReviewDoctor](#temp.case_id)
--
--select * from #temp
--drop table #temp
end
