CREATE PROCEDURE [dbo].[getSummonsReportbu322](
@dt1 varchar(20),
@dt2 varchar(20)
)
as
begin
	select a.case_id,injuredparty_lastname + '/' + injuredparty_firstname as [injuredparty_name],provider_name,insurancecompany_name,accident_date,claim_amount,date_opened
	from tblcase a inner join tblprovider b on a.provider_id=b.provider_id
	inner join tblinsurancecompany c on a.insurancecompany_id=c.insurancecompany_id
	where 
	cast(floor(cast(date_opened as float)) as datetime) >=@dt1 and 
	cast(floor(cast(date_opened as float)) as datetime)<=@dt2
	AND GROUP_DATA <= 0
	order by date_opened,a.case_id

end

