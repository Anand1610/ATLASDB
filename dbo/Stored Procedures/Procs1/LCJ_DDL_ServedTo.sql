
CREATE PROCEDURE [dbo].[LCJ_DDL_ServedTo] 
	-- Add the parameters for the stored procedure here
@DomainId NVARCHAR(50),
@Case_Id VARCHAR(50)
AS
BEGIN

	SET NOCOUNT ON;
	Declare @InsuranceCompany_Id  int
    set @InsuranceCompany_Id=(select InsuranceCompany_Id from tblcase (NOLOCK) where Case_Id=@Case_Id and DomainId=@DomainId)
	--if(@InsuranceCompany_Id<>'0' and @InsuranceCompany_Id <>'NULL')
	Select '0' AS ID, ' ---Select--- ' AS Name
    UNION
    select ID,Name from tblServed where InsuranceCompany_Id = @InsuranceCompany_Id and DomainId= @DomainId order by ID
END
