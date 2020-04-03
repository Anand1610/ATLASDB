/* Previously Called LCJ_DDL_ClientNames */
CREATE PROCEDURE [dbo].[LCJ_DDL_DbCombo_ProviderNames]

	(
		--@parameter1 datatype = default value,
		--@parameter2 datatype OUTPUT
		--@Alpha VARCHAR(5)
		@Query NVARCHAR(20)
	)

AS
--ALTER TABLE #tmpProviderNames
--	(Provider_ID nvarchar(100), Provider_Name varchar(400))

begin
--insert into #tmpClientNames values(0, Null)
--insert into #tmpProviderNames values(0,'...Select Provider...')
--insert into #tmpProviderNames

	SELECT   DISTINCT Provider_Id, Upper(ISNULL(Provider_Name, '')) AS Provider_Name,Provider_ID AS DbComboValue, Provider_Name AS DbComboText  
	FROM         tblProvider
	WHERE    Provider_Name LIKE @Query  order by Provider_Name
--IF @Alpha = 'ALL'
--	select Provider_ID AS DbComboValue, Provider_Name AS DbComboText  from #tmpProviderNames  WHERE Provider_Name LIKE @Query  order by 2
--ELSE
	--select Client_ID, Client_Name  from #tmpClientNames where Client_Name LIKE @Alpha + '%' order by 2
--drop TABLE #tmpProviderNames
end

