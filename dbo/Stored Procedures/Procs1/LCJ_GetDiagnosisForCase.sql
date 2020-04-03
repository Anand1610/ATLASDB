CREATE PROCEDURE [dbo].[LCJ_GetDiagnosisForCase]
(
@Case_Id		nvarchar(50)
)
AS
BEGIN
	
		Select  D.Diag_Id,
				D.Diag_Code	
		from tblCaseDiagnosis CD ,
			 tblDiagnosis D
		where cd.Case_Id=@Case_Id AND CD.DIAG_ID = D.DIAG_ID


END

