

CREATE PROCEDURE [dbo].[SP_GET_BASEPATHID_Of_File] 
	@ImageId varchar(500),
	@DomainId varchar(50)
AS
BEGIN
	
	SET NOCOUNT ON;	
    select BasePathId from tblDocImages where ImageID=@ImageId and DomainId=@DomainId
	---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
    AND IsDeleted=0  
    ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
END
