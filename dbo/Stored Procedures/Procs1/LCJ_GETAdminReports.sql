CREATE PROCEDURE [dbo].[LCJ_GETAdminReports]--'03/02/2005','02/03/2010','slaxman'
(
@dt1 datetime,
@dt2 datetime,
@User nvarchar(20)
)

 AS
BEGIN
select Notes_Desc,count(*) as [Count] from tblnotes  n
where user_id=@User and cast(floor(convert( float,n.Notes_Date)) as datetime)>= @dt1 
and cast(floor(convert( float,n.Notes_Date)) as datetime) <= @dt2
and (n.Notes_Desc is not null and n.Notes_Desc <> '...Select....' and LTRIM(RTRIM(n.Notes_Desc)) <> '')
group by n.Notes_Desc
order by n.Notes_Desc asc

End

