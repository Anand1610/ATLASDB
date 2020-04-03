-- =============================================
-- Author:		Chetan A. Sharma
-- ALTER date: 07/22/2007
-- Description:	Gets Settled Cause of Action.
-- =============================================
--[FHA_WorkArea_SettledCauses] 'FH06-29519'
CREATE PROCEDURE [dbo].[FHA_WorkArea_SettledCauses]
	-- Add the parameters for the stored procedure here
	@Case_Id nvarchar(200)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;   
	select 
	Case_Id,
	Settlement_Id,
	Settlement_Amount,
	Settlement_Int,
	Settlement_Af,
	Settlement_Ff,
	Settlement_Total,
	Settlement_Date,
	SettledWith,
	Settlement_Notes,
	Settled_With_Name,
	Settled_With_Phone,
	Settled_With_Fax,
	Settlement_Type
	FROM Tblsettlements 
	left outer join
	tblSettlement_Type 
	on  Tblsettlements.Settled_Type=tblSettlement_Type.SettlementType_Id 
	WHERE Case_Id = @Case_Id
END

