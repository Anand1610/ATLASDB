CREATE PROCEDURE [dbo].[F_DDL_M_DenialReasons]
@DomainId NVARCHAR(50)

AS
BEGIN
	
	SELECT 0 as PK_Denial_ID,' ---Select Denial Reasons--- ' AS DenialReason
	UNION
    SELECT PK_Denial_ID, DenialReason FROM MST_DenialReasons WHERE DomainId=@DomainId
    ORDER BY DenialReason ASC
END

