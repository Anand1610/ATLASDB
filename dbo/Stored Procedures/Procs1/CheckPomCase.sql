CREATE PROCEDURE [dbo].[CheckPomCase]
	@POMID int
AS
BEGIN
	Select Count(*) From tblPomCase Where pom_id = @POMID and DomainId = 'BT'
END




