
CREATE PROCEDURE [dbo].[GreenBillServiceType_Retrive] 
(
	@s_a_GB_ServiceType Varchar(200),
	@s_a_DomainId  Varchar(200)
)
AS
BEGIN
	SET NOCOUNT ON;

    IF(@s_a_GB_ServiceType = 'All')
    BEGIN
		 
		SELECT DISTINCT     GB_ServiceType,
							ServiceType,
							DomainId

							
						
	     FROM GreenBillServiceType
		 WHERE DomainId = @s_a_DomainId
		 
	END
	ELSE IF(@s_a_GB_ServiceType = 'UnAssign')
    BEGIN
		 
			 
		 
		SELECT DISTINCT     GB_ServiceType,
							ServiceType,
							DomainId
						
	     FROM GreenBillServiceType
		 WHERE ServiceType is null and  DomainId =  @s_a_DomainId
		 
		 
	END
	
    
END




