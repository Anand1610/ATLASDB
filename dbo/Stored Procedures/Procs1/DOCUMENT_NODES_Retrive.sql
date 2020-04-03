-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DOCUMENT_NODES_Retrive]
	@DomainID varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT '0' AS NodeID, ' ---Select Document Node--- ' AS NodeName
	UNION 
    SELECT NodeID, NodeName FROM MST_DOCUMENT_NODES WHERE DomainId = @DomainID
	ORDER BY NodeName
END
