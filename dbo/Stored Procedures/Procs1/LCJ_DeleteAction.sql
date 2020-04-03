CREATE PROCEDURE [dbo].[LCJ_DeleteAction] 
(
	@DomainId NVARCHAR(50),
	@Action_ID int
)
AS

DELETE from tblaction where Action_Id =  @Action_ID and DomainId=@DomainId

