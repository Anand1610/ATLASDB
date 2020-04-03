﻿CREATE PROCEDURE [dbo].[SP_GET_POPUP_NOTES]  --'FL15-5176'
@SZ_CASE_ID VARCHAR(20)  
AS  
BEGIN  

 SELECT REPLACE(REPLACE(REPLACE(REPLACE(NOTES_DESC,'''','\'''), CHAR(13),'\n'), CHAR(10),'\n'), CHAR(9),'\n') [NOTES] 
 FROM TBLNOTES  (NOLOCK)
 WHERE CASE_ID=@SZ_CASE_ID AND NOTES_TYPE in  ('POPUP')
END

