CREATE PROCEDURE [dbo].[cr_settlednopaid](
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

set @st = 'select Year(settlement_date) as Yearset,Count(distinct c.case_id) as NoOfCases,Avg(datediff(d,SETTLEMENT_DATE,t.transactions_date)) as AvgDaysSETTLEDnopaid ' +  
   'from tblCase c with(nolock) inner join tbltransactions t on c.case_id=t.case_id ' +
   'INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON c.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id '+
   ' INNER JOIN dbo.tblProvider WITH (NOLOCK) ON c.Provider_Id = dbo.tblProvider.Provider_Id '+
   ' LEFT OUTER JOIN  dbo.tblSettlements WITH (NOLOCK) ON c.Case_Id = dbo.tblSettlements.Case_Id  '+
   'where ISNULL(c.IsDeleted,0) = 0 AND t.transactions_type=''C'' and Settlement_Date is not null and t.transactions_date is not null  and c.DomainId= '''+@DomainId+''''
set @sttail  = ' Group by year(settlement_date) order by year(settlement_date)'
set @stbody  = ''

if @prgp = 'set' and @prov <> 'ALL'
begin
set @stbody  = @stbody + ' and provider_groupname in (select provider_groupname from tblprovider where provider_id =  ' + @prov + ' and DomainId= '''+@DomainId+''') '
end
ELSE IF @prov <> 'ALL'
BEGIN 
set @stbody  = @stbody + ' and c.provider_id =  ' + @prov 
END

if @insgp  = 'set' AND @INS <> 'ALL'
begin
set @stbody  =@stbody +  ' and InsuranceCompany_groupname in (select InsuranceCompany_groupname from tblInsuranceCompany where Insurancecompany_id =  ' + @ins  + ' and DomainId= '''+@DomainId+''') '
end
ELSE IF @INS <> 'ALL'
BEGIN
set @stbody  = @stbody + ' and c.InsuranceCompany_id =  ' + @ins
END

if @yr <> 'ALL'
begin
set @stbody  = @stbody + ' and year(date_opened)=  ' + @yr
end

set @st = @st + @stbody + @sttail

--print @st
execute sp_executesql @st

end



--sp_help tbltransactions

