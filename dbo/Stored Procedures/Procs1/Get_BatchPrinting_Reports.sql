CREATE PROCEDURE [dbo].[Get_BatchPrinting_Reports] --[Get_BatchPrinting_Reports] '','SUMMONS REQUESTED','EveryThing Else'
(
  @DomainId NVARCHAR(50),
  @Day nvarchar(50),
  @Status nvarchar(200),
  @Criteria nvarchar(200)
)
as
Declare @str as nvarchar(4000)
begin
create table #Temp(case_id nvarchar(50),patient nvarchar(500),provider_name nvarchar(500),InsuranceCompany_Name nvarchar(500),Claim_Amount nvarchar(50),Paid_Amount nvarchar(50),status nvarchar(500),provider_Type nvarchar(500),Provider_groupName nvarchar(500),Criteria nvarchar(500),Printed_Date nvarchar(50))

insert into #Temp 
select tblcase.case_id,
(InjuredParty_FirstName+' '+InjuredParty_LastName)as patient,
provider_name,
InsuranceCompany_Name,
(convert(money,Claim_Amount)-convert(money,Paid_Amount)) as Claim_Amount,
Paid_Amount,
status,
provider_Type,
Provider_groupName,
isnull(case when Provider_GroupName not in ('NSLIJ','TRITEC HC') and isFromNassau ='True' then 'Provider Verification'
when Provider_GroupName not in ('NSLIJ','TRITEC HC') and isFromNassau ='False' then 'Attorney Verification' 
when provider_groupname in('TRITEC HC','NSLIJ') then provider_groupname
else provider_Type End,'')as Criteria,
Printed.Notes_Date as Printed_Date
from tblcase  AS tblcase inner join tblProvider  AS tblprovider on tblcase.Provider_Id=tblprovider.Provider_Id
inner join tblInsuranceCompany  AS tblInsuranceCompany on tblInsuranceCompany.InsuranceCompany_Id=tblcase.InsuranceCompany_Id
inner join (select max(convert(nvarchar,Notes_Date,103))Notes_Date,case_id from tblNotes  where Ltrim(Rtrim(Notes_Desc)) ='Summons Printed' AND DomainId = @DomainId group by case_id)Printed on Printed.case_id=tblcase.case_id
WHERE @DomainId = tblcase.DomainId
order by tblcase.case_id




if(@Day='' and @Criteria='Hospital (TRITEC HC And NSLIJ)' and @status='')
Begin
PRINT 1
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,Provider_groupName as criteria,Printed_Date from #Temp where Provider_groupName in('TRITEC HC','NSLIJ')
End

if(@Day='' and @Criteria Not in('Hospital (TRITEC HC And NSLIJ)','EveryThing Else','REPRINTS') and @Criteria<>'' and @status='')
Begin
PRINT 2
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria=@Criteria
End

if(@Day='' and @Criteria='Hospital (TRITEC HC And NSLIJ)' and @status<>'')
Begin
PRINT 3
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,Provider_groupName as criteria,Printed_Date from #Temp where Provider_groupName in('TRITEC HC','NSLIJ') and status=@Status
End

if(@Day='' and @Criteria Not in('Hospital (TRITEC HC And NSLIJ)','EveryThing Else','REPRINTS') and @Criteria<>'' and @status<>'')
Begin
PRINT 4
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria=@Criteria and status=@Status
End

if(@Day='' and @Criteria='' and @status='')
Begin
PRINT 5
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp
End

if(@Day='' and @Criteria='' and @status<>'')
Begin
PRINT 6
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where status=@Status
End

if(@Day='' and @Criteria='EveryThing Else' and @status='')
Begin
PRINT 7
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria not in('TRITEC HC','NSLIJ','SUPPLY','Provider Verification')
End

if(@Day='' and @Criteria='EveryThing Else' and @status<>'')
Begin
PRINT 8
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria not in('TRITEC HC','NSLIJ','SUPPLY','Provider Verification') and status=@Status
End

--MONDAY
if(@Day='Monday' and (@Criteria='' or @Criteria='Hospital (TRITEC HC And NSLIJ)') and @status='')
Begin
PRINT 9
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,Provider_groupName as criteria,Printed_Date from #Temp where Provider_groupName in('TRITEC HC','NSLIJ')
End

if(@Day='Monday' and (@Criteria='' or @Criteria='Hospital (TRITEC HC And NSLIJ)') and @status<>'')
Begin
PRINT 10
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,Provider_groupName as criteria,Printed_Date from #Temp where Provider_groupName in('TRITEC HC','NSLIJ') and status=@status
End

if(@Day='Monday' and @Criteria<>'' and @Criteria Not in('Hospital (TRITEC HC And NSLIJ)','EveryThing Else','REPRINTS') and @status='')
Begin
PRINT 11
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria =@Criteria
End

if(@Day='Monday' and @Criteria<>'' and @Criteria Not in('Hospital (TRITEC HC And NSLIJ)','EveryThing Else','REPRINTS') and @status<>'')
Begin
PRINT 12
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria =@Criteria and status=@status
End

if(@Day='Monday' and @Criteria='EveryThing Else' and @status='')
Begin
PRINT 13
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria not in('TRITEC HC','NSLIJ','SUPPLY','Provider Verification')
End

if(@Day='Monday' and @Criteria='EveryThing Else' and @status<>'')
Begin
PRINT 14
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria not in('TRITEC HC','NSLIJ','SUPPLY','Provider Verification') and status=@status
End

--TUESDAY
if(@Day='Tuesday' and @Criteria='' and @status='')
Begin
PRINT 15
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria='SUPPLY'
End

if(@Day='Tuesday' and @Criteria='' and @status<>'')
Begin
PRINT 16
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria='SUPPLY' and status=@status
End

if(@Day='Tuesday' and @Criteria not in ('','REPRINTS') and @status='')
Begin
PRINT 17
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria =@Criteria
End

if(@Day='Tuesday' and @Criteria not in ('','REPRINTS') and @status<>'')
Begin
PRINT 18
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria =@Criteria and status=@status
End

if(@Day='Tuesday' and @Criteria='EveryThing Else' and @status='')
Begin
PRINT 19
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria not in('TRITEC HC','NSLIJ','SUPPLY','Provider Verification')
End

if(@Day='Tuesday' and @Criteria='EveryThing Else' and @status<>'')
Begin
PRINT 20
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria not in('TRITEC HC','NSLIJ','SUPPLY','Provider Verification') and status=@status
End
--WEDNESDAY
if(@Day='Wednesday' and @Criteria='' and @status='')
Begin
PRINT 21
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria='Provider Verification'
End

if(@Day='Wednesday' and @Criteria='' and @status<>'')
Begin
PRINT 22
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria='Provider Verification' and status=@status
End

if(@Day='Wednesday' and @Criteria not in ('','REPRINTS') and @status='')
Begin
PRINT 23
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria =@Criteria
End

if(@Day='Wednesday' and @Criteria not in ('','REPRINTS') and @status<>'')
Begin
PRINT 24
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria =@Criteria and status=@status
End

if(@Day='Wednesday' and @Criteria='EveryThing Else' and @status='')
Begin
PRINT 25
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria not in('TRITEC HC','NSLIJ','SUPPLY','Provider Verification')
End

if(@Day='Wednesday' and @Criteria='EveryThing Else' and @status<>'')
Begin
PRINT 26
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria not in('TRITEC HC','NSLIJ','SUPPLY','Provider Verification') and status=@status
End

--THURSDAY
if(@Day='Thursday' and @Criteria='' and @status='')
Begin
PRINT 27
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria not in('Provider Verification','NSLIJ','TRITEC HC','SUPPLY')
End

if(@Day='Thursday' and @Criteria='' and @status<>'')
Begin
PRINT 28
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria not in('Provider Verification','NSLIJ','TRITEC HC','SUPPLY') and status=@status
End

if(@Day='Thursday' and @Criteria not in ('','REPRINTS') and @status='')
Begin
PRINT 29
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria =@Criteria
End

if(@Day='Thursday' and @Criteria not in ('','REPRINTS') and @status<>'')
Begin
PRINT 30
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria =@Criteria and status=@status
End

if(@Day='Thursday' and @Criteria='EveryThing Else' and @status='')
Begin
PRINT 31
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria not in('TRITEC HC','NSLIJ','SUPPLY','Provider Verification')
End

if(@Day='Thursday' and @Criteria='EveryThing Else' and @status<>'')
Begin
PRINT 32
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria not in('TRITEC HC','NSLIJ','SUPPLY','Provider Verification') and status=@status
End

--FRIDAY
if(@Day='Friday' and @Criteria='' and @status<>'')
Begin
PRINT 33
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where status=@status
End

if(@Day='Friday' and @Criteria not in ('','REPRINTS') and @status='')
Begin
PRINT 34
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria =@Criteria
End

if(@Day='Friday' and @Criteria not in ('','REPRINTS') and @status<>'')
Begin
PRINT 35
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria =@Criteria and status=@status
End

if(@Day='Friday' and @Criteria='EveryThing Else' and @status='')
Begin
PRINT 36
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria not in('TRITEC HC','NSLIJ','SUPPLY','Provider Verification')
End

if(@Day='Friday' and @Criteria='EveryThing Else' and @status<>'')
Begin
PRINT 37
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where criteria not in('TRITEC HC','NSLIJ','SUPPLY','Provider Verification') and status=@status
End

if(@Criteria='REPRINTS')
Begin
PRINT 38
select distinct case_id,patient,provider_name,InsuranceCompany_Name,Claim_Amount,Paid_Amount,status,criteria,Printed_Date from #Temp where status= @status
End



END

