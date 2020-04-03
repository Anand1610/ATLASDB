CREATE PROCEDURE [dbo].[SpGetMergedCasesFilesDetails]
(
	@DOMAINID VARCHAR(20)
)
AS
BEGIN
	
	UPDATE a 
	SET [STATUS] = (
						CASE WHEN (STATENAME = 'Failed' OR STATENAME = 'Deleted')	THEN 'Failed'
						WHEN STATENAME = 'Succeeded' THEN 'Done'
						ELSE 'In-Progress'
						END
					)				
	FROM	MergedCasesFiles a
	JOIN	[HangFire].[Job] b on a.JobId = b.Id 
	WHERE	a.DomainId = @DOMAINID 
	AND		STATUS = 'In-Progress' 
	

	SELECT		CaseId,NodeName,JobId,CreatedBy,FileName,Status,DateCreated,DomainId,ProcessedCaseId,NonProcessedCaseId
	FROM		MergedCasesFiles
	WHERE		DomainId = @DOMAINID
	ORDER BY	JobId Desc
END