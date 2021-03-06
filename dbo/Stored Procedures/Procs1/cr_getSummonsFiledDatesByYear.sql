﻿CREATE PROCEDURE [dbo].[cr_getSummonsFiledDatesByYear](
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

set @st = 'select Provider_Name,Count(distinct Case_Id) as NoOfCases,Avg(datediff(d,date_opened,Date_Index_Number_Purchased)) as AvgDaysIndex 
  from tblCase cas with(nolock)  INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON cas.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id
  INNER JOIN dbo.tblProvider WITH (NOLOCK) ON cas.Provider_Id = dbo.tblProvider.Provider_Id  where ISNULL(cas.IsDeleted,0) = 0   AND Date_Index_Number_Purchased is not null '
set @sttail  = ' Group by Provider_Name order by Provider_Name'
set @stbody  = ''

if @prgp = 'set' and @prov <> 'ALL'
begin
set @stbody  = @stbody + ' and provider_groupname in (select provider_groupname from tblprovider where provider_id =  ' + @prov + ') '
end
ELSE IF @prov <> 'ALL'
BEGIN 
set @stbody  = @stbody + ' and cas.provider_id =  ' + @prov 
END

if @insgp  = 'set' AND @INS <> 'ALL'
begin
set @stbody  =@stbody +  ' and InsuranceCompany_groupname in (select InsuranceCompany_groupname from tblInsuranceCompany where Insurancecompany_id =  ' + @ins  + ') '
end
ELSE IF @INS <> 'ALL'
BEGIN
set @stbody  = @stbody + ' and cas.InsuranceCompany_id =  ' + @ins
END

if @yr <> 'ALL'
begin
set @stbody  = @stbody + ' and year(date_opened)=  ' + @yr + ''
end

set @st = @st + @stbody + @sttail

--print @st
execute sp_executesql @st

end
