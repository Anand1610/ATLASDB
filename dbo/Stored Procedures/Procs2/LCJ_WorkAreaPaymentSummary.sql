CREATE PROCEDURE [dbo].[LCJ_WorkAreaPaymentSummary]

(
@Case_Id as NVARCHAR(400)
)

 AS

Select * from LCJ_VW_CaseSearchDetails where Case_Id= + @Case_Id

