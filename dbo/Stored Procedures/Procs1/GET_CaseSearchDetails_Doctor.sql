CREATE PROCEDURE [dbo].[GET_CaseSearchDetails_Doctor] --'FH11-85139'
	@DomainId NVARCHAR(50),
	@Case_Id nvarchar(20)
AS
BEGIN
	select * from CaseSearchDetails_Doctor (NOLOCK) where [Case Id]=@Case_Id and DomainId = @DomainId
END
