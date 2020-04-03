
CREATE PROCEDURE [dbo].[SP_GET_SERVICE_TYPES]
@DomainId NVARCHAR(50)
AS
BEGIN
	SELECT '0' AS ServiceTypeID,' --- Select Sevice Types --- ' AS ServiceType
	union 
	SELECT DISTINCT ServiceType AS ServiceTypeID, ServiceType 
	FROM tblServiceType WHERE DomainId=@DomainId

END


