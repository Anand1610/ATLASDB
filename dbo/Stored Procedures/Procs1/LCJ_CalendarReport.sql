CREATE PROCEDURE [dbo].[LCJ_CalendarReport]

(
@DateType nvarchar(100), 
@StartDate varchar(50),
@EndDate varchar(50),
@Defendant_Id nvarchar(3000),
@Provider_Id nvarchar(3000),
@InsuranceCompany_Id nvarchar(3000),
@Status_Type nvarchar(2000),
@Court_Id nvarchar(1000),
@Claim_Amount_Start varchar(50),
@Claim_Amount_End varchar(50)
)
as
begin
declare
@st nvarchar(4000)
 
set @st = 'Select Motion_Date, Trial_Date, Case_Id, Provider_Name, InjuredParty_Name, InsuranceCompany_Name, 
	Defendant_Name, Status, IndexOrAAA_Number from LCJ_VW_CaseSearchDetails '

set @st = @st + 'where (1=1) '
 
if @StartDate <> '' and @EndDate  <> '' 
set @st = @st + ' and ' +  @DateType + ' >= ''' + @StartDate + ''' and ' + @DateType + ' <=''' + @EndDate + ''''
if @Defendant_Id <> 'ALL'
set @st = @st + ' and Defendant_Id in (''' + Replace(@Defendant_Id,',',''',''') + ''')'
if @Provider_Id <> 'ALL'
set @st = @st + ' and Provider_Id in (''' + Replace(@Provider_Id,',',''',''') + ''')'
if @InsuranceCompany_Id <> 'ALL'
set @st = @st + ' and InsuranceCompany_Id in (''' + Replace(@InsuranceCompany_Id,',',''',''') + ''')'
if @Status_Type <> 'ALL'
set @st = @st + ' and Status in (''' + Replace(@Status_Type,',',''',''') + ''')'
if @Court_Id <> 0
set @st = @st + ' and Court_Id in (' + @court_Id + ')'
if @Claim_Amount_Start <> '' and @Claim_Amount_End  <> '' 
set @st = @st + ' and Claim_amount >= ' + @Claim_Amount_Start  + ' and Claim_Amount  <=' + @Claim_Amount_End  + ''
 
set @st = @st + ' order by ' + @DateType + ',provider_name'
 
print @st
execute sp_executesql @st 
end

