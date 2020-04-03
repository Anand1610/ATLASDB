

CREATE PROCEDURE [dbo].[SP_GET_BASEPATHID_Of_File] 
	@ImageId varchar(500),
	@DomainId varchar(50)
AS
BEGIN
	
	SET NOCOUNT ON;	
    select BasePathId from tblDocImages where ImageID=@ImageId and DomainId=@DomainId
END
