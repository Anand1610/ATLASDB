
CREATE VIEW [dbo].[LCJ_VW_ManageDesk]
AS
SELECT     dbo.tblUserDesk.UserName, dbo.tblDesk.Desk_Name, dbo.tblUserDesk.Desk_Id, tblUserDesk.DomainId
FROM         dbo.tblUserDesk INNER JOIN
                      dbo.tblDesk ON dbo.tblUserDesk.Desk_Id = dbo.tblDesk.Desk_Id
