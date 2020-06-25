CREATE PROCEDURE Check_DOA_For_DemandLetterWithAOB_Batch
(
	@DomainId VARCHAR(20),
	@CaseId VARCHAR(MAX)
)
AS
BEGIN
	SELECT Case_Id FROM tblcase where Case_Id IN(SELECT VALUE FROM  STRING_SPLIT(@CaseId,',')) AND DomainId = @DomainId AND (Accident_Date IS NULL OR Accident_Date = '' or convert(date,Accident_Date)=CONVERT(date,'01/01/1990'))
END