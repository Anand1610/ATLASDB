CREATE PROCEDURE [dbo].[States_DDL]
	@DomainId NVARCHAR(50)=null	
AS

BEGIN

SELECT '' AS State_Abr, ' ---Select--- ' State_Name
UNION
SELECT   State_Abr, State_Name FROM tblStates
WHERE State_Abr <> '' 
ORDER BY 1 asc

END

