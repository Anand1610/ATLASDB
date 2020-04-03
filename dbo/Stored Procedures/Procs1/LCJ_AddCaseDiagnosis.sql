CREATE PROCEDURE [dbo].[LCJ_AddCaseDiagnosis]
(
@Case_Id		nvarchar(50),
@Diag_Id		int

)
AS
BEGIN
	
	BEGIN


		-- Insert the records
		BEGIN TRAN
			
		INSERT INTO tblCaseDiagnosis
		(
		Case_Id,
		Diag_Id
		)

		VALUES(
		@Case_Id,
		@Diag_Id
		)					

		COMMIT TRAN

	END

END

