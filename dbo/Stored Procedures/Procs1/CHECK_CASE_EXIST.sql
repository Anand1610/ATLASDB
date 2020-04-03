CREATE PROCEDURE [dbo].[CHECK_CASE_EXIST]	
	@CaseID nvarchar(100)
as
IF EXISTS(SELECT Case_ID FROM dbo.tblCase WHERE Case_Id=@CaseID)
	select 1 [Result]
Else
	select 0 [Result]

