
CREATE PROCEDURE [dbo].[LCJ_GETfirmchecks] (
	@DomainId NVARCHAR(50),
	@dt1 datetime,
	@dt2 datetime
)
as
	BEGIN
		SELECT 
		c.PROVIDER_ID,
		PROVIDER_NAME,
		c.CASE_ID,
		INDEXORAAA_NUMBER,
		TRANSACTIONS_TYPE,
		TRANSACTIONS_AMOUNT,
		Convert(varchar(20), TRANSACTIONS_DATE,101) AS TRANSACTIONS_DATE,
		TRANSACTIONS_DESCRIPTION
		FROM --lcj_vw_casesearchdetails a 
		tblcase c WITH (NOLOCK)
		INNER JOIN dbo.tblProvider p WITH (NOLOCK) ON c.Provider_Id = p.Provider_Id 
		INNER JOIN tbltransactions t
		on c.case_id=t.case_id where transactions_type in ('AF','FFC') and 
		cast(floor(convert( float,t.transactions_date)) as datetime)>= @dt1 and cast(floor(convert( float,t.transactions_date)) as datetime) <= @dt2
		and p.DomainId=@DomainId
		order by t.transactions_date
	END

