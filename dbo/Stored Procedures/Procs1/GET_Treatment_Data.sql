CREATE PROCEDURE GET_Treatment_Data
(
	@DomainId VARCHAR(40),
	@Case_ID VARCHAR(40)
)
AS
BEGIN
	SELECT 
		 Provider_Suitname  
		, tre.Claim_Amount
		, tre.Paid_Amount
		, ISNULL(tre.CLAIM_AMOUNT,0) - ISNULL(tre.PAID_AMOUNT,0) AS Balance_Amount
		, CONVERT(VARCHAR(10),tre.DateOfService_Start,101) + ' - '+ CONVERT(VARCHAR(10),tre.DateOfService_End,101) AS DOS_Range 
	FROM tblTreatment tre (nolock)
	join tblcase cas (nolock) On cas.domainid = tre.domainid and cas.case_id = tre.case_id 
	join tblProvider pro (nolock) On cas.domainid = pro.domainid and cas.Provider_Id = pro.Provider_Id
	WHERE	tre.DomainID =  @DomainId
	AND tre.CASE_ID = @Case_ID 
	AND ISNULL(tre.CLAIM_AMOUNT,0) - ISNULL(tre.PAID_AMOUNT,0) > 0 
	
END