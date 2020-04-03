


CREATE PROCEDURE [dbo].[LCJ_DeleteServiceType]
(
@DomainId nvarchar(50),
@ServiceType nvarchar(100)

)


AS

DELETE from tblservicetype  where ServiceType  = + Rtrim(Ltrim(@ServiceType)) and DomainId = @DomainId

