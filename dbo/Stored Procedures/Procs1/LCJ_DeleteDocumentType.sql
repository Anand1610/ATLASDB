CREATE PROCEDURE [dbo].[LCJ_DeleteDocumentType]
(
@DomainId nvarchar(50),
@Doc_Name nvarchar(100)

)


AS

DELETE from tblDocs  where Doc_Name = + Rtrim(Ltrim(@Doc_Name)) and DomainId = @DomainId

