﻿CREATE PROCEDURE [dbo].[SP_LIST_DENIAL_CATEGORY]  
AS  
BEGIN  
 SELECT   
  I_CATEGORY_ID,  
  SZ_CATEGORY_NAME,  
  SZ_CATEGORY_COLOR  
 FROM MST_DENIAL_CATEGORY  
END

