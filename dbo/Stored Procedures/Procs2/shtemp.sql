CREATE PROCEDURE [dbo].[shtemp]
as
begin
Select t1.case_id,* from LCJ_VW_CASESEARCHDETAILS t1 inner join tblserved t2 on t1.served_to=t2.id where t1.insurancecompany_id=t2.insurancecompany_id and t1.insurancecompany_type = 0 and t1.case_id in (select DISTINCT CASE_ID from tblcase where SERVED_ON_DATE in ('2009-03-06 00:00:00.000') AND STATUS = 'SERVED-ON-CARRIER') ORDER BY court_name,substring(t1.indexoraaa_number,2,1)desc,substring(t1.indexoraaa_number,1,6)
end

