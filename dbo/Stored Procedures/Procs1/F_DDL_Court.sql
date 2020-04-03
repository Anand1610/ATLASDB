
CREATE PROCEDURE [dbo].[F_DDL_Court]
(
	@DomainID VARCHAR(50)
)	
AS
BEGIN

	SET NOCOUNT ON;
WITH CTE AS (  
 SELECT top 10000 Court_Id,Court_Name FROM tblCourt WHERE Court_Name not like '%select%' and Court_Id <> 0   
 AND DomainID = @DomainID   
 ORDER BY Court_Name )  
 SELECT '0' as Court_Id,' ---Select Court--- ' as Court_Name  
 UNION   
 SELECT Court_Id, Court_Name from CTE  
  

	SET NOCOUNT OFF ;



END

