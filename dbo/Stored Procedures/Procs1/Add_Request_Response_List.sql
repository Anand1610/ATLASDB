CREATE PROCEDURE [dbo].[Add_Request_Response_List]
(
   @DomainId nvarchar(50),
   @ListName nvarchar(500),
   @List_Type nvarchar(50)
)
as
begin
insert into MST_REQUEST_REJECTION_MASTER values(@DomainId,@ListName,@List_Type)
End

