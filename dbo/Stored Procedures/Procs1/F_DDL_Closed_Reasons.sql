CREATE PROCEDURE [dbo].[F_DDL_Closed_Reasons] 
  
AS  
BEGIN
	SELECT * FROM tbl_closed_reasons ORDER BY ClosedReasons
END

