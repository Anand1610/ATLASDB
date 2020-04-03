-- =============================================
-- Author:		srosenthal
-- Create date: 
-- Description:	
-- =============================================
Create FUNCTION [dbo].[FUNC_Case_Processor] (@case_id varchar(50))

RETURNS varchar(50) 
AS
begin
Declare @User varchar(50)

	SELECT  @user=tblNotes.User_Id
FROM         tblcase INNER JOIN
                      tblNotes ON tblcase.Case_Id = tblNotes.Case_Id
WHERE      (tblNotes.Notes_Desc = N'case opened') and (tblnotes.case_id=@case_id)
GROUP BY tblNotes.User_Id

return @user


end
