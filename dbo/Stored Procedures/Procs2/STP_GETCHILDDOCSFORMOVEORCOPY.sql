﻿--STP_GETCHILDDOCSFORMOVEORCOPY 35,10, 32  
CREATE PROCEDURE  [dbo].[STP_GETCHILDDOCSFORMOVEORCOPY]  
(
	@DomainId NVARCHAR(50),
	@NODEID INT,  
	@TARGETNODEID INT,  
	@SOURCENODEID INT  
)
AS   
  
DECLARE @BASEFOLDER AS NVARCHAR(255)  
DECLARE @DESTROOTPATH AS VARCHAR(255)  
DECLARE @SRCTROOTPATH AS VARCHAR(255)  
  
	EXEC STP_DSP_NODEROOTPATH @TARGETNODEID, @DESTROOTPATH OUT  
	EXEC STP_DSP_NODEROOTPATH @SOURCENODEID, @SRCTROOTPATH OUT  
	SELECT 
		@BASEFOLDER=VirtualBasePath 
	FROM tblBasePath Where BasePathId=(Select ParameterValue From
		TBLAPPLICATIONSETTINGS 
	WHERE 
		PARAMETERNAME='BasePathId'  
		AND DomainId=@DomainId)
  
	SELECT 
		I.FILENAME,@BASEFOLDER+@SRCTROOTPATH SOURCEROOTNODE, B.VirtualBasePath+I.FILEPATH SOURCEPATH, @BASEFOLDER + @DESTROOTPATH TARGETPATH, 'F' TYPE, I.IMAGEID, T.TAGID 
	FROM 
		TBLIMAGETAG T  
		INNER JOIN TBLDOCIMAGES I  ON I.IMAGEID=T.IMAGEID  
		LEFT JOIN tblBasePath B ON B.BasePathId = I.BasePathId
	WHERE 
		T.TAGID=@NODEID  
		AND T.DomainId=@DomainId
		---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
        AND T.IsDeleted=0 AND I.IsDeleted=0  
        ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
  
--SELECT I.FILENAME,@SRCTROOTPATH SOURCEROOTNODE, I.FILEPATH SOURCEPATH, @DESTROOTPATH TARGETPATH, 'F' TYPE, I.IMAGEID, T.TAGID FROM TBLIMAGETAG T  
--INNER JOIN TBLDOCIMAGES I  ON I.IMAGEID=T.IMAGEID  
--WHERE T.TAGID=@NODEID  
  
  
  
--Select * from tblTags

