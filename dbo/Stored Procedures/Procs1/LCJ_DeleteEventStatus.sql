CREATE PROCEDURE [dbo].[LCJ_DeleteEventStatus]
(
@DomainId varchar(50),
@EventStatusName varchar(100)

)


AS

DELETE from tblEventStatus  where EventStatusName = + @EventStatusName and DomainId = @DomainId

