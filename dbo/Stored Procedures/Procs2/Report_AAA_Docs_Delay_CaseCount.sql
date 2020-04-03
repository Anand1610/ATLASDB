CREATE PROCEDURE [dbo].[Report_AAA_Docs_Delay_CaseCount]
	@DomainID varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT distinct
		Count(cas.Case_Id) as TotalCase,
		cas.Provider_Id,
		p.Provider_Name
		FROM tblCase cas (NOLOCK) left join tblProvider p (NOLOCK) on p.Provider_Id = cas.Provider_Id
		where cas.DomainId = @DomainID and ISNULL(cas.IsDeleted,0)=0 and LTRIM(RTRIM(Status)) = 'AAA DOCS DELAY'
		group by cas.Provider_Id, p.Provider_Name
END