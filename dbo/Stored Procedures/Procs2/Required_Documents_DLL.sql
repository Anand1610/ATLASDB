
CREATE PROCEDURE [dbo].[Required_Documents_DLL] -- Required_Document_DLL
(
@DomainId varchar(50) = null
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	

	SELECT 'A.O.B' AS DocumentType
	UNION SELECT 'CLAIM NUMBER' AS DocumentType
	UNION SELECT 'DENIALS' AS DocumentType
	UNION SELECT 'IME REPORT' AS DocumentType
	UNION SELECT 'MEDICAL REPORT' AS DocumentType
	UNION SELECT 'PEER REVIEW REPORT' AS DocumentType
	UNION SELECT 'POLICY NUMBER' AS DocumentType
	UNION SELECT 'STAMPED PROOF OF MAILING' AS DocumentType
				
END
