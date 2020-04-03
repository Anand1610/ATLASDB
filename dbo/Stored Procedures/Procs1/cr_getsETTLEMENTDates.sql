CREATE PROCEDURE [dbo].[cr_getsETTLEMENTDates](
@DomainId NVARCHAR(50),
@ins varchar(255),
@prov varchar(255),
@yr varchar(50),
@insgp varchar(10),
@prgp varchar(10)
)
as
begin

declare
@st nvarchar(2000),
@sttail nvarchar(2000),
@stbody nvarchar(1500)

set @st = 'select Year(Settlement_date) as YearSettled,Count(distinct cas.Case_Id) as NoOfCases,Avg(datediff(d,date_opened,SETTLEMENT_DATE)) as AvgDaysSETTLED' 
+' from tblcase cas with(nolock)  INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON cas.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id'
+' INNER JOIN dbo.tblProvider WITH (NOLOCK) ON cas.Provider_Id = dbo.tblProvider.Provider_Id  LEFT OUTER JOIN  dbo.tblSettlements WITH (NOLOCK) ON cas.Case_Id = dbo.tblSettlements.Case_Id '
+' where ISNULL(cas.IsDeleted,0) = 0 AND Settlement_Date is not null and cas.DomainId = '''+@DomainId+''''
set @sttail  = ' Group by year(settlement_date) order by year(settlement_date)'
set @stbody  = ''
print @st
if @prgp = 'set' and @prov <> 'ALL'
begin
set @stbody  = @stbody + ' and provider_groupname in (select provider_groupname from tblprovider where provider_id=  ' + @prov + ' and DomainId= '''+@DomainId+''') '
end
ELSE IF @prov <> 'ALL'
BEGIN 
set @stbody  = @stbody + ' and provider_id =  ' + @prov 
END

if @insgp  = 'set' AND @INS <> 'ALL'
begin
set @stbody  =@stbody +  ' and InsuranceCompany_groupname in (select InsuranceCompany_groupname from tblInsuranceCompany where Insurancecompany_id =  ' + @ins  + ' and DomainId = '''+@DomainId+''') '
end
ELSE IF @INS <> 'ALL'
BEGIN
set @stbody  = @stbody + ' and InsuranceCompany_id =  ' + @ins
END

if @yr <> 'ALL'
begin
set @stbody  = @stbody + ' and year(date_opened)=  ' + @yr
end

set @st = @st + @stbody + @sttail

--print @st
execute sp_executesql @st

end

