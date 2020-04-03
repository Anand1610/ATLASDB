CREATE PROCEDURE [dbo].[LCJ_DeleteEventType]
(
@DomainId varchar(50),
@EventTypeName varchar(100)

)


AS

DELETE from tblEventType  where EventTypeName = + @EventTypeName and DomainId = @DomainId

