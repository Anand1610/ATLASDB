CREATE PROCEDURE [dbo].[Delete_Request_Response_List]
(
	@DomainId nvarchar(50),
   @List_Id int
)
as
begin
Delete from MST_REQUEST_REJECTION_MASTER  where List_Id =@List_Id and DomainId = @DomainId
End

