/****** Object:  Stored Procedure dbo.LCJ_DeleteDiagnosisForCase    Script Date: 3/13/2008 3:52:10 PM ******/




CREATE PROCEDURE [dbo].[LCJ_DeleteDiagnosisForCase]
(
@Case_Id nvarchar(50),
@Diag_Id int

)


AS
DELETE from tblCaseDiagnosis where Case_Id = @Case_Id AND Diag_Id = @Diag_Id

