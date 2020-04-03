Create PROCEDURE [dbo].[LCJ_DDL_Arbitrator]
@DomainId NVARCHAR(50)
AS        
begin        
SELECT '0' AS ARBITRATOR_ID,'--Select--' AS ARBITRATOR_NAME
UNION
SELECT     ARBITRATOR_ID, CONCAT(ARBITRATOR_NAME,  ' [ ', ABITRATOR_LOCATION, ' ] ') AS ARBITRATOR_NAME
FROM         TblArbitrator
WHERE DomainId=@DomainId
order by arbitrator_name
end

--[LCJ_DDL_Arbitrator] 'amt'
