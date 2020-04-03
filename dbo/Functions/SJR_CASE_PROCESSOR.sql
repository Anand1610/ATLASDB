-- =============================================
-- Author:		srosenthal
-- ALTER date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[SJR_CASE_PROCESSOR] ()

RETURNS TABLE 
AS
RETURN 
(
	SELECT     tblcase.Case_Id, tblNotes.User_Id, tblcase.Status
FROM         tblcase INNER JOIN
                      tblNotes ON tblcase.Case_Id = tblNotes.Case_Id
WHERE      (tblNotes.Notes_Desc = N'case opened')
GROUP BY tblcase.Case_Id, tblNotes.User_Id, tblcase.Status
)
