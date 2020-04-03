CREATE PROCEDURE [dbo].[Report_Active_Delay_CaseCount] 
	-- Add the parameters for the stored procedure here
	@DomainID nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT distinct
		Count(cas.Case_Id) as TotalCase,
		cas.Provider_Id,
		p.Provider_Name
		FROM tblCase cas (NOLOCK) left join tblProvider p (NOLOCK) on p.Provider_Id = cas.Provider_Id
		where cas.DomainId=@DomainID AND ISNULL(cas.IsDeleted, 0) = 0
		AND cas.status IN('ACTIVE BILLING DELAYED','ACTIVE BILLING DELAYED 60','ACTIVE BILLING DELAYED 90','ACTIVE BILLING DELAYED 120')
		group by cas.Provider_Id, p.Provider_Name

END