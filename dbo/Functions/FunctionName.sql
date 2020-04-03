-- =============================================
-- Author:		Name
-- ALTER date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[FunctionName] 
(
	-- Add the parameters for the function here
	@START_DATE DATETIME, 
	@END_DATE DATETIME
)
RETURNS 
@Table_Var TABLE 
(
	-- Add the column definitions for the TABLE variable here
	c1 int, 
	c2 int
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	
	RETURN 
END
