CREATE PROCEDURE [dbo].[LCJ_GETCLIENTDETAILS_GROUP]
(
	@dt1 datetime,
	@dt2 datetime,
	@provider_group varchar(50)       
)
AS

SELECT * FROM TBLPROVIDER (NOLOCK) WHERE Provider_id in 
	(select Provider_Id from tblclientaccount (NOLOCK)
	where Provider_id in (select distinct Provider_Id from tblProvider (NOLOCK) where Provider_GroupName =@provider_group)
	and cast(floor(convert( float,account_date)) as datetime)>= @dt1
	and cast(floor(convert( float,account_date)) as datetime) <= @dt2)

