-- =============================================
-- Author:		Tausif Kazi
-- Create date: 06-25-2019
-- Description:	Template Tag retrieving procedure
-- =============================================
CREATE PROCEDURE Get_Template_Tags 
AS
BEGIN

	SET NOCOUNT ON;
     Select Distinct column_name, friendly_name From tbl_template_column(NOLOCK) order by column_name, friendly_name
END
