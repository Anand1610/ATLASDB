CREATE PROCEDURE [dbo].[providerstatuslist](
@provider_id varchar(50)
)
as
select status,count(*) as [count] from lcj_vw_casesearchdetails where provider_id = @provider_id group by status order by status

