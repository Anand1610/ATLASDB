CREATE PROCEDURE CheckBatchTypeCaseExists --CheckBatchTypeCaseExists 'priyanka.k@lawspades.com','PDC20-101101','Complaint Packet-Over $8000-Conforming'
(
	@Email VARCHAR(50), 
	@CASE_IDS VARCHAR(MAX),
	@BatchType VARCHAR(50)
)
AS
BEGIN
	IF NOT EXISTS(SELECT UserId from IssueTracker_Users where DomainId = 'PDC' and (@Email = 'robert@flinslaw.com'))
		BEGIN
			DECLARE @ProcessedCaseIdTable Table
			(
				ID INT IDENTITY(1,1) NOT NULL,
				CaseId varchar(MAX) NOT NULL,
				UserName varchar(100) NOT NULL
			);
			INSERT INTO @ProcessedCaseIdTable
			SELECT CASE WHEN processed_case_ids IS NULL THEN
					case_ids
					ELSE
					processed_case_ids
					END,
					UserName
			FROM tbl_batch_print_offline_queue
			INNER JOIN IssueTracker_Users ON tbl_batch_print_offline_queue.fk_configured_by_id = IssueTracker_Users.UserId
			WHERE tbl_batch_print_offline_queue.DomainId = 'PDC' and IsDeleted = 0 and printing_type = @BatchType and (in_progress is null or in_progress = 1 or is_processed = 1)
			ORDER BY pk_batch_print_id DESC

			DECLARE @COUNT INT = @@ROWCOUNT
			DECLARE @DistinctProcessedCases TABLE
			(
				CaseId varchar(25) NOT NULL,
				UserName varchar(100) NOT NULL
			);
			WHILE(@COUNT > 0)
			BEGIN
				DECLARE @CaseId VARCHAR(25)
				DECLARE @UserName VARCHAR(25)
				SELECT @CaseId = CaseId,@UserName = UserName from @ProcessedCaseIdTable WHERE Id = @COUNT
				INSERT INTO @DistinctProcessedCases
				SELECT value,ISNULL(@UserName,'') FROM  STRING_SPLIT(@CaseId,',')
			SET @COUNT = @COUNT - 1
		END
				DECLARE @temp TABLE
				(
					Case_Id varchar(25) NOT NULL
				);
				INSERT INTO @temp
				SELECT VALUE FROM STRING_SPLIT(@CASE_IDS,',')


				SELECT DISTINCT Case_Id,UserName FROM @temp INNER JOIN @DistinctProcessedCases ON Case_Id = CaseId
		END
END