CREATE PROCEDURE F_DDL_Insurance_TPA_Group
(
	@DomainId varchar(10)
)
AS
BEGIN
	SELECT 0 AS TPA_Group_ID, '--SELECT--' AS TPAGroupName
	UNION ALL
	SELECT PK_TPA_Group_ID AS TPA_Group_ID,TPA_Group_Name AS TPAGroupName FROM tblInsurance_TPA_Group WHERE DomainId = @DomainId AND IsActive = 0
END