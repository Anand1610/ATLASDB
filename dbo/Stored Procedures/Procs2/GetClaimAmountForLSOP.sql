CREATE PROCEDURE GetClaimAmountForLSOP
(
	@DomainId VARCHAR(20),
	@Case_ID VARCHAR(25)
)
AS
BEGIN
	SELECT Claim_Amount from tblCase where Case_Id = @Case_ID AND DomainId = @DomainId
END