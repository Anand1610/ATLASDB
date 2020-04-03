
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Task_Status_DDL]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	Select '0' As [Task_Status_ID], ' ---Select Task Status--- ' as [Description]
	UNION 
	Select [Task_Status_ID], [Description] From Task_Status

END
