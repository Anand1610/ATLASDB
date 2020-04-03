
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Task_Priority_DDL]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    select '0' AS Priority_ID ,' ---Select Priority--- ' AS [Description]
	UNION
	Select [Priority_ID], [Description] From Task_Priority

END
