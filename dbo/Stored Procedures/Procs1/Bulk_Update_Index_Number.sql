CREATE PROCEDURE [dbo].[Bulk_Update_Index_Number]
(
	@tblExcelCases	dbo.UDT_CaseNumber READONLY,
	@Error			int output
)
AS BEGIN
BEGIN TRANSACTION
BEGIN TRY
	--SELECT * into #temp FROM @tblExcelCases
	
	DECLARE @Case TABLE
	(	[Id] int,
		[Case_Id] [nvarchar](50),
		[Case_Number] [varchar](40) 
	);

	INSERT INTO  @Case
	(	 Id
		,Case_Id
		,Case_Number
	)	
	SELECT Id,EC.Case_Id, Case_Number FROM @tblExcelCases EC INNER JOIN tblcase(NOLOCK) C ON LTRIM(RTRIM(EC.Case_Id)) =  LTRIM(RTRIM(C.Case_Id))
	AND Case_Number not in (Select IndexOrAAA_Number From tblcase(NOLOCK) cas where cas.Case_Id<>C.Case_Id and ISNULL(cas.IndexOrAAA_Number,'') <>'')

	MERGE tblcase AS TARGET
	USING @Case AS SOURCE 
	ON (LTRIM(RTRIM(TARGET.Case_Id)) = LTRIM(RTRIM(SOURCE.Case_Id))) 
	--When records are matched, update 
	--the records if there is any change
	WHEN MATCHED and TARGET.IndexOrAAA_Number<>SOURCE.Case_Number 
	THEN 
	UPDATE SET TARGET.IndexOrAAA_Number = SOURCE.Case_Number;
	
	SELECT  @Error= (Select Count(*) From @Case)

	Select EC.Case_Id, Case_Number, 'Case ID not found.' AS Error from @tblExcelCases EC LEFT JOIN tblcase(NOLOCK) C ON  LTRIM(RTRIM(EC.Case_Id)) =  LTRIM(RTRIM(C.Case_Id))
	Where C.Case_Id is null
	UNION
	Select EC.Case_Id, Case_Number, 'Index Number already exists.' AS Error from @tblExcelCases EC INNER JOIN tblcase(NOLOCK) C 
	ON EC.Case_Number = C.IndexOrAAA_Number AND LTRIM(RTRIM(EC.Case_Id)) <> LTRIM(RTRIM(C.Case_Id)) AND ISNULL(C.IndexOrAAA_Number,'') <>'' 

COMMIT TRANSACTION
 
END TRY
BEGIN CATCH

	--DECLARE @ErrorMessage NVARCHAR(4000);
 --   DECLARE @ErrorSeverity INT;
 --   DECLARE @ErrorState INT;
 --   SELECT 
	--	@ErrorMessage=   ERROR_MESSAGE(),
 --       @ErrorSeverity = ERROR_SEVERITY(),
 --       @ErrorState = ERROR_STATE();

		set @Error=0;
RETURN;
ROLLBACK TRANSACTION
END CATCH;

END


