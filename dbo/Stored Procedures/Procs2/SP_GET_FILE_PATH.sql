﻿CREATE PROCEDURE [dbo].[SP_GET_FILE_PATH] -- [SP_GET_FILE_PATH] 594699
@NODEID NVARCHAR(200)=NULL  
AS  
BEGIN  
  
		SELECT DISTINCT I.IMAGEID, B.BasePathType,PATH=(case when B.BasePathType=1 then B.PhysicalBasePath + I.FILEPATH+I.FILENAME when B.BasePathType=2 then I.FILEPATH+I.FILENAME Else Null End),
				I.FILENAME FILENAME 
		FROM tblDocImages I 
		JOIN TBLIMAGETAG IT ON  IT.IMAGEID=I.IMAGEID 
        JOIN TBLTAGS T ON T.NODEID = IT.TAGID AND I.IMAGEID IN (SELECT IMAGEID FROM TBLIMAGETAG 
		LEFT OUTER JOIN tblApplicationSettings app on IT.DomainId = app.DomainId and PARAMETERNAME='DocumentUploadLocationPhysical'
        WHERE ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		TBLIMAGETAG.IsDeleted=0 AND 
		 ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude 
		
		TAGID=(SELECT TAGID FROM TBLIMAGETAG WHERE 
		---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		TBLIMAGETAG.IsDeleted=0 AND 
		 ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
		IMAGEID=CONVERT(INT,  @NODEID))) 
        AND IT.IMAGEID=CONVERT(INT, @NODEID ) 
		LEFT OUTER JOIN tblBasePath B ON B.BasePathId=I.BasePathId
		 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
  WHERE I.IsDeleted=0 AND IT.IsDeleted=0  
  ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
        --LEFT JOIN TBLAPPLICATIONSETTINGS S ON S.PARAMETERNAME= 'DocumentUploadLocationPhysical'
        ORDER BY I.IMAGEID
   
END  
  
