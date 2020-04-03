
CREATE PROCEDURE [dbo].[GreenBillsDenial_Retrive] -- Report_Statute_Of_Limitation 'AAA_6YR_UNFILED'
(
	@s_a_GB_Denial Varchar(200),
	@s_a_DomainId  Varchar(200)
)
AS
BEGIN
	

	SET NOCOUNT ON;

    IF(@s_a_GB_Denial = 'All')
    BEGIN
		 
		SELECT DISTINCT     GB_DENIAL_REASON,
							RFA_DENIAL_REASON,
							DomainID AS DomainId

	     FROM GreenBillsDenial
		 WHERE [DomainID] = @s_a_DomainId
		 
	END
	ELSE IF(@s_a_GB_Denial = 'UnAssign')
    BEGIN
		 
			 
		 
		SELECT DISTINCT     GB_DENIAL_REASON,
							RFA_DENIAL_REASON,
							[DomainID ] AS DomainId
						
	     FROM GreenBillsDenial
		 WHERE RFA_DENIAL_REASON is null and  [DomainID ] =  @s_a_DomainId
		 
		 
	END
	
    
END




