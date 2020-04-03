/****** Object:  Stored Procedure dbo.LCJ_DeleteDiagnosis    Script Date: 3/13/2008 3:52:10 PM ******/




CREATE PROCEDURE [dbo].[LCJ_DeleteDiagnosis]
(

@Diag_Code nvarchar(50)

)


AS
DELETE from tblDiagnosis where Diag_Code = + Rtrim(Ltrim(@Diag_Code))

