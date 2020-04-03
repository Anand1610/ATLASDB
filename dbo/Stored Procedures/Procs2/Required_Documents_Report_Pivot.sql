CREATE PROCEDURE [dbo].[Required_Documents_Report_Pivot]   -- Required_Documents_Report 'localhost',0
	@DomainID VARCHAR(50),
	@b_DisplayDocumentType bit = 0
AS
BEGIN
	--SELECT * FROM Required_Documents
	SET NOCOUNT ON;
	DECLARE @ReminderTable TABLE
	(
		DocumentType VARCHAR(100),
		CASE_ID VARCHAR(50),
		ReminderDays int,
		PivotRange VARCHAR(50)
	)

	INSERT INTO  @ReminderTable
	select DocumentType, R.CASE_ID, DATEDIFF(DAY, ReminderDate ,GETDATE()) AS ReminderDays,''
    from Required_Documents R INNER JOIN tblCase C ON C.Case_Id = R.Case_ID
	WHERE  R.DomainID = @DomainID 
		AND ISNULL(isCompleted,0) = 0
		AND ISNULL(C.IsDeleted,0) = 0
	
	UPDATE @ReminderTable
	SET PivotRange = '0 - 15'
	WHERE ReminderDays <= 15

	UPDATE @ReminderTable
	SET PivotRange = '16 - 30'
	WHERE ReminderDays > 15 and ReminderDays <= 30

	UPDATE @ReminderTable
	SET PivotRange = '31 - 45'
	WHERE ReminderDays > 30 and ReminderDays <= 45

	UPDATE @ReminderTable
	SET PivotRange = '> 45 '
	WHERE ReminderDays > 45
	
	IF(@b_DisplayDocumentType = '0')
	BEGIN
		SELECT  [0 - 15], [16 - 30], [31 - 45], [> 45]  
		FROM
			(SELECT PivotRange, CASE_ID
			 FROM @ReminderTable) AS SourceTable
			PIVOT
			(
			 COUNT(Case_ID) 
			 FOR PivotRange IN ([0 - 15], [16 - 30], [31 - 45], [> 45])
			) AS PivotTable;
	END
	ELSE
	BEGIN
		SELECT  DocumentType, [0 - 15], [16 - 30], [31 - 45], [> 45]  
		FROM
			(SELECT DocumentType, PivotRange, CASE_ID
			 FROM @ReminderTable) AS SourceTable
			PIVOT
			(
			 COUNT(Case_ID) 
			 FOR PivotRange IN ([0 - 15], [16 - 30], [31 - 45], [> 45])
			) AS PivotTable;
	END
END