CREATE PROCEDURE [dbo].[LCJ_DeleteDenialReasons] 
(
@DomainId NVARCHAR(50),
@DenialReasons_Type nvarchar(100)

)


AS

DELETE from tblDenialReasons where DenialReasons_Type = + Rtrim(Ltrim(@DenialReasons_Type)) and DomainId=@DomainId

