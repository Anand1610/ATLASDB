CREATE PROCEDURE [dbo].[SP_GET_FILE_PATH_FOR_DELETE] -- [SP_GET_FILE_PATH] 490312  
(
	@DOMAINID NVARCHAR(100) = NULL,
	@SZ_NODEID NVARCHAR(200)=NULL
 )
AS  
BEGIN  

	DECLARE @s_a_Exists VARCHAR(10) = 'NO'
	IF EXISTS(select top 1 filepath + [filename],[filename],filepath from tbldocimages where imageid <> @SZ_NODEID and DomainId= @DOMAINID
	AND REPLACE(filepath + [filename],'/', '\') IN (select top 1 REPLACE(filepath + [filename],'/', '\') from tbldocimages where imageid <>  @SZ_NODEID and DomainId= @DOMAINID))
	BEGIN
		SET @s_a_Exists = 'YES'
	END
	
	select filepath + [filename],[filename],filepath, @s_a_Exists as isExists,BasePathId from tbldocimages where imageid = @SZ_NODEID and DomainId= @DOMAINID
	
 
END  
  
