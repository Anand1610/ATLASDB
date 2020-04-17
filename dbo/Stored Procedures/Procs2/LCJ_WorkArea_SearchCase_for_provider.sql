CREATE PROCEDURE [dbo].[LCJ_WorkArea_SearchCase_for_provider] --[LCJ_WorkArea_SearchCase_for_provider] '','','Simpson, Darnell A','','0','','','','P','78','',''
  
(   
@DomainId				   nvarchar(50),
@strCaseId                 nvarchar(50),  
@Status                    nvarchar(50),  
@InjuredParty_LastName     nvarchar(50),  
@InsuredParty_LastName     nvarchar(50),  
@InsuranceCompany_Id       nvarchar(200),  
--@Provider_Id               nvarchar(200),  
@Policy_Number             nvarchar(100),  
@Ins_Claim_Number          nvarchar(100),  
@IndexOrAAA_Number         nvarchar(100),  
--@Court_Id                  int,  
@UserType				   nvarchar(10),  
@UserTypeLogin			   nvarchar(100),  
--@Attorney_Id			   nvarchar(100),
--@Initial_Status			   nvarchar(100),
--@Provider_Group			   nvarchar(500),
@PeerReviewDoc	nvarchar(100),			
--@DOSStart_Date nvarchar(10),
--@DOSEnd_Date nvarchar(10),
@Location nvarchar(100)   
)  
  

AS  
DECLARE @strsql as varchar(8000)  
declare @prov as nvarchar(4000)
begin  
set @prov='select Provider_id from dbo.TXN_PROVIDER_LOGIN where user_id=(select UserId from dbo.IssueTracker_Users where UserTypeLogin='''+@UserTypeLogin+''')'

set @strsql = 'select top 5000
tblcase.Case_Id,   
InjuredParty_LastName + '', '' + InjuredParty_FirstName as [InjuredParty_Name],  
Provider_Name + ISNULL('' [ '' + Provider_Groupname + '' ]'','''') as Provider_Name,  
InsuranceCompany_Name,  
Indexoraaa_number,  
convert(decimal(38,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount)))) as Claim_Amount,
(select convert(varchar, min(DateOfService_Start),101) from tbltreatment where case_id=tblcase.case_id) + '' - '' +
(select convert(varchar, max(DateOfService_End),101) from tbltreatment where case_id=tblcase.case_id) as DateOfService, 
DenialReasons_Type as Denial_Reason,
(select dbo.[fncGetPeerReviewDoctor](@DomainId,tblcase.case_id)) as Doctor_Name,
Paid_Amount,(select sum(settlement_amount) from tblsettlements where case_id =tblcase.case_id) as Settlement_Amount,
(convert(varchar(12),(select max(settlement_date) from tblsettlements where case_id =tblcase.case_id),103)) as Settlement_Date,isnull(convert(varchar(12),Date_Opened,101),'''') as Date_Opened,Defendant_Name
From tblcase AS tblcase inner join tblprovider AS tblprovider on tblcase.provider_id=tblprovider.provider_id 
inner join tblinsurancecompany AS tblinsurancecompany on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id   
INNER JOIN TXN_PROVIDER_LOGIN ON tblcase.provider_id = TXN_PROVIDER_LOGIN.provider_id
left outer join tblDefendant on tblDefendant.Defendant_id=tblcase.Defendant_id
WHERE tblcase.provider_id in ('+@prov+') AND tblcase.DomainId = '''+@DomainId+''''  
  
if @strCaseId <> ''  
begin  
	set @strsql = @strsql + ' AND Case_Id Like ''%' + @strCaseId + '%'''               
end  
  
if @Status <> '' and @Status <> '0'  
begin  
	set @strsql = @strsql + '  AND STATUS = ''' + @Status + ''''         
end 

if @InjuredParty_LastName <> ''   
begin  
	set @strsql = @strsql + '  AND (InjuredParty_LastName + '', '' + InjuredParty_FirstName Like ''%' + @InjuredParty_LastName + '%'')'         
end  
  
if @InsuredParty_LastName <> ''   
begin  
	  set @strsql = @strsql + '  AND (InsuredParty_LastName Like ''%' + @InsuredParty_LastName + '%'' or InsuredParty_FirstName like ''%' + @InsuredParty_LastName + '%'')'       
end
  
if @InsuranceCompany_Id <> '0' and @InsuranceCompany_Id <> '' and @InsuranceCompany_Id <> '''0''' and @InsuranceCompany_Id <> ''''''
begin  
	set @strsql = @strsql + '  AND tblcase.InsuranceCompany_Id IN (' + @InsuranceCompany_Id + ')'  
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
  
  
if @PeerReviewDoc <> ''
begin
	set @strsql = @strsql + '  AND tblcase.case_id in(select distinct (case_id) from tbltreatment where treatment_id in (select TREATMENT_ID from TXN_CASE_PEER_REVIEW_DOCTOR where doctor_id in (select doctor_id from TblReviewingDoctor where doctor_name like ''%' + @PeerReviewDoc + '%'')))'
end 
  
if @Location <> '' and @Location <> '1'
begin  
	set @strsql = @strsql + '  AND tblcase.location_id = ''' + @Location + ''''  
end

SET @strsql = @strsql + '  order by case_autoid desc'  
--print(@strsql)



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


