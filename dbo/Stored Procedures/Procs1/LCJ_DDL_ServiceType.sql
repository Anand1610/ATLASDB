CREATE PROCEDURE [dbo].[LCJ_DDL_ServiceType]
@DomainId NVARCHAR(50)
AS
begin

	SELECT ServiceType FROM tblServiceType WHERE DomainId = @DomainId order by ServiceType ASC

end

