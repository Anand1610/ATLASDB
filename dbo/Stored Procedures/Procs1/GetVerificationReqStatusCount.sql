CREATE PROCEDURE [dbo].[GetVerificationReqStatusCount]
(
	@DomainId VARCHAR(10)
)
AS
BEGIN
	SELECT count(VerificationStatus) AS VerificationRequestedCount from tblCase_additional_info where domainId = @DomainId and VerificationStatus = 'VER REQUESTED'
END