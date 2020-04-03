CREATE PROCEDURE [dbo].[LCJ_DDL_SettlementType]
@DomainId NVARCHAR(50)
AS
--ALTER TABLE #tmpStatus
--	(Status_Abr nvarchar(100), Status_Type varchar(100))

begin
--insert into #tmpClientNames values(0, Null)
--insert into #tmpStatus values(0,'...Select Status...')
--insert into #tmpStatus
    SELECT 0 AS SettlementType_Id,'...Select...' AS Settlement_Type
UNION
	SELECT   DISTINCT SettlementType_Id,Settlement_Type
	FROM         tblSettlement_Type
	WHERE     (1 = 1) and DomainId=@DomainId order by Settlement_Type
--IF @Alpha = 'ALL'
--	select Status_Abr, Status_Type  from #tmpStatus  order by 2
--	drop table #tmpStatus
--ELSE
	--select Client_ID, Client_Name  from #tmpClientNames where Client_Name LIKE @Alpha + '%' order by 2

--drop TABLE #tmpStatus
end

