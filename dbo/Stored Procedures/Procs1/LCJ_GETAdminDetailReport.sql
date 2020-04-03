CREATE PROCEDURE [dbo].[LCJ_GETAdminDetailReport]--'02/09/2010','03/09/2010','slaxman'
(
@dt1 datetime,
@dt2 datetime,
@User_Id nvarchar(20),
@Notes_Desc varchar(8000)
)

 AS
BEGIN
--select n.User_Id ,c.Case_Id,n.Notes_Type,
--convert(nvarchar,n.Notes_Date,101)[Notes],
--n.Notes_Desc from tblnotes as n,
--tblcase as c
-- where n.Notes_Type=@Notes
-- and
--
--  cast(floor(convert( float,n.Notes_Date)) as datetime)=@Notes_Date 
--and
-- n.User_Id =@User_Id 
--and
-- n.Case_Id=@Case_Id 
--and
-- c.status not in ('CLOSED','Closed Arbitration','Closed as per RCF','Closed Judgement','Closed Withdrawn with Prejudice','Closed Withdrawn without prejudice','Settled','Withdrawn-with-prejudice','withdrawn-without-prejudice','Carrier In Rehab','Pending','Open-Old','Trial Lost')
--and c.Case_Id=n.Case_Id 
--order by n.Notes_Date desc
select Case_Id,Notes_Type,Notes_Desc,Notes_Date from tblnotes  n where user_id=@User_Id
and n.Notes_Desc=@Notes_Desc and 
cast(floor(convert( float,n.Notes_Date)) as datetime)>= @dt1
and cast(floor(convert( float,n.Notes_Date)) as datetime) <= @dt2

End

