CREATE PROCEDURE [dbo].[LCJ_DeleteMotion]
(
@DomainId nvarchar(50),
@Motion_id nvarchar(3000)

)


AS

DELETE from tblMotions  where Motion_ID = + @Motion_id and DomainId=@DomainId

