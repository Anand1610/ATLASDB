
CREATE PROCEDURE [dbo].[BulkImportCases]
(
	@tblExcelCases	dbo.UDT_CaseNumber READONLY
	,@DomainID		varchar(50)
	,@Error			int output
)
AS BEGIN
BEGIN TRANSACTION

	DECLARE @TotalCount INT = 0
	DECLARE @Counter INT = 0

 
BEGIN TRY
	SELECT * into #temp FROM @tblExcelCases
	
	DECLARE @Case TABLE
	(	[Id] int,
		[Case_Id] [nvarchar](50),
		[Case_Number] [varchar](40) 
	);

	
	INSERT INTO  @Case
	(	Id
		,Case_Id
		,Case_Number
	)	
	SELECT Id,Case_Id,Case_Number FROM #temp

	
	MERGE tblcase AS TARGET
	USING @Case AS SOURCE 
	ON (TARGET.Case_Id = SOURCE.Case_Id) 
	--When records are matched, update 
	--the records if there is any change
	WHEN MATCHED AND TARGET.DomainId=@DomainID
	THEN 
	UPDATE SET TARGET.IndexOrAAA_Number = SOURCE.Case_Number;
	
	set @Error=1; 

COMMIT TRANSACTION
--ROLLBACK TRANSACTION
 
END TRY
BEGIN CATCH

	DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;
    SELECT 
		@ErrorMessage=   ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

		set @Error=0;
RETURN;
ROLLBACK TRANSACTION
END CATCH;

END


