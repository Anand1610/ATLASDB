CREATE PROCEDURE [dbo].[Client_Report_Menu_Retrive] --[Client_Report_Menu_Retrive] 'BT','1370'
AS
BEGIN
	SELECT a.MenuID
		,a.MenuName
		,a.Link
		,a.ParentID
	FROM tblClientReportMenu a
		,tblClientReportMenu b
	WHERE a.ParentID = b.MenuID
END