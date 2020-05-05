CREATE PROCEDURE [dbo].[LCJ_UpdateSettlementPctg]
(
@Settlement_Pctg as float,
@Treatment_Id as int,
@Case_Id nvarchar(100)
)

 AS

Update tblTreatment
SET Settlement_Pctg = @Settlement_Pctg
      
WHERE Case_Id = @Case_Id AND Treatment_Id = @Treatment_Id

