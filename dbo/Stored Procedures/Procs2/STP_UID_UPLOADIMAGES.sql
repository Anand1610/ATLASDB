CREATE PROCEDURE [dbo].[STP_UID_UPLOADIMAGES]  
@DomainId nvarchar(50),
@PARENTID	bigint,
@FILEPATH	NVARCHAR(max),
@FILENAME	NVARCHAR(max),
@LOGINID	NVARCHAR(max)
AS
BEGIN  
 DECLARE @NEWIMAGEID bigint
 DECLARE @BasePathId INT
 
 IF(@LOGINID = '')
	SET @LOGINID	=	'1'
 ELSE IF(@LOGINID IS NULL)
	SET @LOGINID	=	'1'

SELECT TOP 1 @BasePathId = ParameterValue FROM tblApplicationSettings WHERE ParameterName = 'BasePathId'

SET @LOGINID = (SELECT USERID FROM dbo.IssueTracker_Users where UserName=RTRIM(@LOGINID) and DomainId= @DomainId)
  --select * from tblImageTag
 INSERT INTO tblDocImages (FILENAME, FILEPATH, OCRDATA, STATUS,from_flag,DomainId,BasePathId)  
 VALUES(@FILENAME, @FILEPATH, NULL, 1,0,@DomainId,@BasePathId)  
   
 SET @NEWIMAGEID = (select max(imageid) from tbldocimages WHERE DomainId =@DomainId)  
  
 INSERT INTO tblImageTag (IMAGEID, TAGID, LOGINID, DateInserted,DomainId)   
     VALUES (@NEWIMAGEID,@PARENTID,@LOGINID, GetDate(),@DomainId)  
  
  
END
--sp_columns TBLDOCIMAGES

