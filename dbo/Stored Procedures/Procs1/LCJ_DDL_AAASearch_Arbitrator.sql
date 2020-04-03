CREATE PROCEDURE [dbo].[LCJ_DDL_AAASearch_Arbitrator]
@DomainId NVARCHAR(50)
AS        
begin        
SELECT     ARBITRATOR_ID, ARBITRATOR_NAME + ' [ ' + ABITRATOR_LOCATION + ' ] ' AS ARBITRATOR_NAME
FROM         TblArbitrator where DomainId=@DomainId and ARBITRATOR_NAME in(select distinct ARBITRATOR_NAME from TblArbitrator where ARBITRATOR_NAME !='')
order by arbitrator_name
end

