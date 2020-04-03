CREATE PROCEDURE [dbo].[LCJ_WorkDeskCase]
(

@Desk_Id int

)


 AS

Begin
	Select * from LCJ_VW_CaseSearchDetails Inner Join tblCaseDesk ON LCJ_VW_CaseSearchDetails.Case_Id = tblCaseDesk.Case_Id where tblCaseDesk.Desk_Id = @Desk_Id

End

