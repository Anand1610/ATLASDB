
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- DROP PROCEDURE Task_Type_Retrive
CREATE PROCEDURE [dbo].[Task_Type_DDL]
	@DomainID varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	SELECT '0' as [Task_Type_ID], ' ---Select Type--- ' as [Description]
	UNION
	Select [Task_Type_ID], [Description] From Task_Type Where DomainID = @DomainID
	ORDER BY [Description]

END
