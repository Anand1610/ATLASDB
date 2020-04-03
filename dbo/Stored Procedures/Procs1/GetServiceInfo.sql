CREATE PROCEDURE [dbo].[GetServiceInfo](
@dt1 varchar(50),
@dt2 varchar(50)
)
as
begin
select b.InsuranceCompany_Id,InsuranceCompany_Name,isnull(Insurancecompany_Local_Address,' ') + ',' + isnull(Insurancecompany_Local_City,' ') + ',' + 
isnull(Insurancecompany_Local_state,' ') + ' ' + isnull(Insurancecompany_Local_zip,' ') as [Address],count(a.case_id) as [Cnt] 
from tblCase a inner join tblinsurancecompany b
on a.insurancecompany_id=b.insurancecompany_id where status='INDEX-NUMBERS'
AND CAST(FLOOR(CAST(Date_Summons_Sent_Court AS float)) AS datetime) >= @dt1  and CAST(FLOOR(CAST(Date_Summons_Sent_Court AS float)) AS datetime) <= @dt2 
and b.InsuranceCompany_type=0 
group by InsuranceCompany_name,b.InsuranceCompany_Id,Insurancecompany_Local_Address,
Insurancecompany_Local_City,
Insurancecompany_Local_state,
Insurancecompany_Local_zip 
order by InsuranceCompany_Name
end

