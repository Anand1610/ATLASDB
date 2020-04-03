--ALTER TABLE DAILYSUMMONS(CASE_ID VARCHAR(50))

CREATE PROCEDURE [dbo].[printdailysummons]
as
begin
select * from lcj_vw_casesearchdetails where case_id in (select case_id from DAILYSUMMONS) order by case_id
end

