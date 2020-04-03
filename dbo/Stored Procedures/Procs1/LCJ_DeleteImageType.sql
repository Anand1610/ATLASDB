CREATE PROCEDURE [dbo].[LCJ_DeleteImageType]
(
@DomainId nvarchar(50),
@Image_Type nvarchar(100)

)


AS

DELETE from tblImageTypes  where Image_Type = + Rtrim(Ltrim(@Image_Type)) and DomainId = @DomainId

