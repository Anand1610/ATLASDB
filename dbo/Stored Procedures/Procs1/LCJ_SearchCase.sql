CREATE PROCEDURE [dbo].[LCJ_SearchCase] -- [LCJ_SearchCase] '1','1','1','1','1','1','','01/01/2011','03/01/2011'
(   
@strCaseId                 nvarchar(50),
@Status                    nvarchar(50),  
@InjuredParty_LastName     nvarchar(50), 
@InsuranceCompany_Id       nvarchar(100),  
@Provider_Id               nvarchar(200),   
@Provider_Group			   nvarchar(500),
@Insurance_Group		   nvarchar(500),
@ServiceType			   nvarchar(100),
@DenialReason			   nvarchar(100),
@DenialReasons_Id int,
@DateOpened1 nvarchar(10),
@DateOpened2 nvarchar(10)  
)  
  
AS
DECLARE @strsql as varchar(8000)  
begin  

set @strsql = 'select distinct 
tblcase.Case_Id,
CASE WHEN tblprovider.provider_groupname=''GBB'' and abs(datediff(dd,tblcase.Accident_Date,tblcase.DateOfService_Start))<30
    		THEN ''<font color=red>''+tblcase.Case_Id+''</font> '' 
			WHEN tblprovider.provider_groupname=''GBB'' and abs(datediff(dd,tblcase.Accident_Date,tblcase.DateOfService_Start))>45
			THEN ''<font color=red>''+tblcase.Case_Id+''</font> ''
			WHEN tblprovider.provider_groupname=''GBB'' and abs(datediff(dd,tblcase.Accident_Date,tblcase.DateOfService_Start)) between 30 and 45
			THEN ''<font color=green>''+tblcase.Case_Id+''</font> ''
            else tblcase.case_id END as Case_Color,  
InjuredParty_LastName + '', '' + InjuredParty_FirstName as [InjuredParty_Name],  
Provider_Name + ISNULL('' [ '' + Provider_Local_Address + '' ]'','''') + ISNULL('' [ '' + Provider_Groupname + '' ]'','''') as Provider_Name,  
InsuranceCompany_Name,   
convert(decimal(38,2),(convert(money,convert(float,tblcase.Claim_Amount) - convert(float,tblcase.Paid_Amount)))) as Claim_Amount,
Status,  
Ins_Claim_Number, 
(select convert(varchar, min(DateOfService_Start),101) from tbltreatment where tbltreatment.Case_Id=tblcase.Case_Id) + '' - '' +
(select convert(varchar, max(DateOfService_End),101) from tbltreatment where tbltreatment.case_id=tblcase.case_id) as DateOfService, 
'''' as denialreasons_type,
INITIAL_STATUS,
tblcase.insurancecompany_id,
tblcase.Provider_Id,
case_autoid, Accident_Date,
'''' as service_type,
CONVERT(VARCHAR(10), Date_Opened, 101) AS Date_Opened,
Provider_Groupname, 
(Select top 1 a.Case_Id FROM  tblCase a WHERE a.Provider_Id =tblcase.Provider_Id  and a.InjuredParty_LastName =tblcase.InjuredParty_LastName
and a.InjuredParty_FirstName = tblcase.InjuredParty_FirstName and  a.Accident_Date =tblcase.Accident_Date  
 and a.Case_Id <> tblcase.case_id) AS Similar_To_Case_ID,
(Select top 1 a.Case_Id +'' ''+Initial_Status+''/''+ Status  FROM  tblCase a WHERE a.Provider_Id =tblcase.Provider_Id  and a.InjuredParty_LastName =tblcase.InjuredParty_LastName
and a.InjuredParty_FirstName = tblcase.InjuredParty_FirstName and  a.Accident_Date =tblcase.Accident_Date  
and a.Case_Id <> tblcase.case_id) AS Similar_To
From tblcase inner join tblprovider on tblcase.provider_id=tblprovider.provider_id inner join tblinsurancecompany on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id   
left join tbltreatment on tblcase.Case_id = tbltreatment.Case_id   
left join TXN_tblTreatment on tbltreatment.Treatment_Id = TXN_tblTreatment.Treatment_Id  
WHERE 1=1 AND Bit_FromGB=1 '    


IF(@Status ='......select status')
	set @Status =''


if @strCaseId <> ''  
begin  
	set @strsql = @strsql + ' AND tblcase.Case_Id Like ''%' + @strCaseId + '%'''               
end  

if @InjuredParty_LastName <> ''   
begin  
	set @strsql = @strsql + '  AND (InjuredParty_FirstName Like ''%' + @InjuredParty_LastName + '%'' or InjuredParty_LastName like ''%' + @InjuredParty_LastName + '%'')'           
end 

if @InsuranceCompany_Id <> '0' and @InsuranceCompany_Id <> '' and @InsuranceCompany_Id <> '''0''' and @InsuranceCompany_Id <> ''''''
begin  
	set @strsql = @strsql + '  AND tblcase.InsuranceCompany_Id IN (' + @InsuranceCompany_Id + ')'  
end  
  
  
if @Provider_Id <> '0' and @Provider_Id <> '' and @Provider_Id <> '''0''' and @Provider_Id <> ''''''
begin  
	set @strsql = @strsql + '  AND tblcase.Provider_Id IN (' + @Provider_Id + ')'  
end 
  
if @Insurance_Group <> '' and @Insurance_Group<>'0'
Begin
	set @strsql = @strsql + '  AND tblcase.insurancecompany_id in (select insurancecompany_id from tblInsuranceCompany where insurancecompany_groupname = ''' + @Insurance_Group + ''')'
End

if @Provider_Group <> '' and @Provider_Group<> '0'
begin
	set @strsql = @strsql + '  AND tblcase.Provider_Id in (select Provider_id from tblprovider where Provider_GroupName = ''' + @Provider_Group + ''')'
end

if @ServiceType <> ''  and  @ServiceType <>'0'
begin  
	set @strsql = @strsql + '  AND tblcase.case_id in (select distinct (case_id) as case_id from tbltreatment where service_type = ''' + @ServiceType + ''') '  
end


if (@DenialReasons_Id <> 0)
BEGIN
	set @strsql = @strsql + ' AND tblcase.case_id in (select DISTINCT Case_Id from tbltreatment
	inner join TXN_tblTreatment on tblTreatment.Treatment_Id = TXN_tblTreatment.Treatment_Id
	where TXN_tblTreatment.DenialReasons_Id  ='''+convert(nvarchar(200),@DenialReasons_Id)+''')'

END



SET @strsql = @strsql + '  order by case_autoid desc'  


create table #temp
(
	Case_Id nvarchar(20),
	Case_Color nvarchar(500),
	InjuredParty_Name nvarchar(1000),
	Provider_Name nvarchar(500),
	InsuranceCompany_Name nvarchar(1000),
	Claim_Amount nvarchar(50),
	Status nvarchar(100),
	Ins_Claim_Number nvarchar(100),
	DateOfService  nvarchar(500),
	denialreasons_type nvarchar(500),
	INITIAL_STATUS nvarchar(500),
	insurancecompany_id int,
	Provider_Id int,
	case_autoid int,
	Accident_Date datetime,
	service_type nvarchar(500),
	Date_Opened nvarchar(500),
	Provider_Groupname nvarchar(500),
	Similar_To_Case_ID nvarchar(500),
	Similar_To nvarchar(500)
)
print(@strsql)
insert into #temp
exec (@strsql)


update #temp
set denialreasons_type = dbo.fncGetDenialReasons(#temp.case_id), service_type = dbo.fncGetServiceType(#temp.case_id)


DECLARE @strsqltemp as varchar(8000)  
	begin  
		set @strsqltemp = 'select * from #temp where 1=1'
	End
	if @Status <> '' and @Status <> '0'  
	begin  
		set @strsqltemp= @strsqltemp + '  AND STATUS = ''' + @Status + ''''         
	end
	if @DateOpened1<>'' and @DateOpened2<> ''
	Begin
		set @strsqltemp = @strsqltemp + '  AND date_opened between ''' + @DateOpened1 + '''and ''' + @DateOpened2 + ''''
	End
exec (@strsqltemp)
drop table #temp
end

