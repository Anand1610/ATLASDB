CREATE procedure [dbo].[getSerivceType]
@DomainId varchar(50)
as
begin
SELECT '0' AS ServiceTypeID,' --- Select Sevice Types --- ' AS ServiceType
	union 
	SELECT DISTINCT ServiceTypeID AS ServiceTypeID, Specialty as ServiceType 
	FROM MST_PROCEDURE_CODES WHERE DomainId=@DomainId
	order by  ServiceTypeID
end