CREATE PROCEDURE [dbo].[FHA_WorkArea_SettlementDetails]
	
	(
		@Case_Id NVARCHAR(100)
		
	)

AS

BEGIN

	SELECT    a.*,b.settlement_notes
	FROM        LCJ_VW_CaseSearchDetails a left join tblsettlements b on a.case_id=b.case_id
	WHERE    a.Case_Id = @Case_Id

END

