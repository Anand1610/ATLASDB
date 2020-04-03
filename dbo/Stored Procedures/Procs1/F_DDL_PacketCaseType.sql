CREATE PROCEDURE [dbo].[F_DDL_PacketCaseType]
(
	@DomainID VARCHAR(50)
)	
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT '0' as PacketCaseTypeID,' ---Select Packet Case Type--- ' as PacketCaseType
	UNION
	SELECT PK_CaseType_Id AS PacketCaseTypeID,Upper(ISNULL(CaseType, '')) AS PacketCaseType FROM MST_PacketCaseType WHERE PK_CaseType_Id <> 0 and DomainID = @DomainID
	
	SET NOCOUNT OFF ;



END

