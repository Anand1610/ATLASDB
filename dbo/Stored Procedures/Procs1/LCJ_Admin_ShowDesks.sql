CREATE PROCEDURE [dbo].[LCJ_Admin_ShowDesks]

(
@DomainId NVARCHAR(50),
@UserName NVARCHAR(50)
)

AS

SELECT *, '' AS DeleteDesk from LCJ_VW_ManageDesk WHERE Username = + @Username and DomainId=@DomainId

