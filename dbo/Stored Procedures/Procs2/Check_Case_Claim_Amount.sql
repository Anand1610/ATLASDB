CREATE PROCEDURE Check_Case_Claim_Amount
(
	@CaseId varchar(2000),
	@DomainId varchar(10),
	@BatchPrintType varchar(20)
)
AS
BEGIN

	Declare @excludedCaseIds varchar(2000) = ''

	Declare @totalCases INT = 0
	DECLARE @CurrentCaseId varchar(25)
	DECLARE @CurrentRowId INT = 0
	DECLARE @CLAIM_AMOUNT DECIMAL(19,2)
	SELECT @totalCases = COUNT(autoid) FROM [dbo].string_split(@CaseId,',')
	While(@totalCases > 0)
		BEGIN
			SELECT @CurrentCaseId = ITEMS FROM [dbo].string_split(@CaseId,',') Where autoid = @CurrentRowId
			Select @CLAIM_AMOUNT = Claim_Amount from tblCase where Case_Id = @CurrentCaseId	AND DomainId = @DomainId
			IF((@CLAIM_AMOUNT > 8000 AND @BatchPrintType = 'STATEMENT OF CLAIMS') OR (@CLAIM_AMOUNT < 8000 AND @BatchPrintType = 'COMPLAINT PACKAGE'))
				BEGIN
					IF(@excludedCaseIds != '')
						BEGIN
							SET @excludedCaseIds = @excludedCaseIds + ',' + @CurrentCaseId
						END
					IF(@excludedCaseIds = '')
						BEGIN
							SET @excludedCaseIds = @CurrentCaseId
						END
				END
			SET @CurrentRowId = @CurrentRowId + 1
			SET @totalCases = @totalCases - 1			
		END
	SELECT @excludedCaseIds AS ExcludedCaseIds
END
