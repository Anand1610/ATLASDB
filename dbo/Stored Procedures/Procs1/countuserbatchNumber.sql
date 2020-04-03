CREATE PROCEDURE [dbo].[countuserbatchNumber]
(
   @BatchNumber nvarchar(50)
)
as
begin
select UserId from RelationUser_BatchNo where BatchNumber=@BatchNumber
end

