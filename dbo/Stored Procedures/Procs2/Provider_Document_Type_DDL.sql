
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- DROP PROCEDURE [dbo].[LCJ_GetProviderDocType] 
CREATE PROCEDURE [dbo].[Provider_Document_Type_DDL] 
	-- Add the parameters for the stored procedure here
	@domainId nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT '0' AS Doc_Id, ' --- Select Document Type --- ' AS ProviderDoc_Type
	UNION
	SELECT Doc_Id,ProviderDoc_Type from Provider_Document_type where domainId=@domainId
END

