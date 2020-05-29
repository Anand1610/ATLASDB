/* 
modified by	Atul Jadhav
Date		5/29/2020
Description	Created for relove the web application error
Last used by :
*/
CREATE PROCEDURE [dbo].[Get_User_For_Admin_Report]
@DomainId varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT UserName AS UserId,UserName from IssueTracker_Users(NOLOCK) where roleid<>2 order by UserName
END