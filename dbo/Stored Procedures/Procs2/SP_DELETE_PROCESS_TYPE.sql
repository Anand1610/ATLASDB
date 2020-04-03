CREATE PROCEDURE [dbo].[SP_DELETE_PROCESS_TYPE]
(
@DomainId nvarchar(50),
@SZ_PROCESS_NAME nvarchar(100)

)


AS

DELETE from MST_PROCESS  where SZ_PROCESS_NAME = + Rtrim(Ltrim(@SZ_PROCESS_NAME)) and DomainId = @DomainId

