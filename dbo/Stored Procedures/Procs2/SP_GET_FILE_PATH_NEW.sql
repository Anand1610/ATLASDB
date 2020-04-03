﻿
create PROCEDURE [dbo].[SP_GET_FILE_PATH_NEW] -- [SP_GET_FILE_PATH] 594699
@Images [Images]  READONLY
AS  
BEGIN  
  
		SELECT DISTINCT I.IMAGEID, B.BasePathType,PATH=(case when B.BasePathType=1 then B.PhysicalBasePath + I.FILEPATH+I.FILENAME when B.BasePathType=2 then I.FILEPATH+I.FILENAME Else Null End),
				I.FILENAME FILENAME 
		FROM tblDocImages I 
		JOIN TBLIMAGETAG IT ON  IT.IMAGEID=I.IMAGEID 
        JOIN TBLTAGS T ON T.NODEID = IT.TAGID 
        JOIN @Images IM ON I.ImageID=IM.ImageId
		LEFT OUTER JOIN tblBasePath B ON B.BasePathId=I.BasePathId
        --LEFT JOIN TBLAPPLICATIONSETTINGS S ON S.PARAMETERNAME= 'DocumentUploadLocationPhysical'
        ORDER BY I.IMAGEID
   
END  
  
