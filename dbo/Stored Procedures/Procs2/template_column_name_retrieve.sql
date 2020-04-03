


CREATE PROCEDURE [dbo].[template_column_name_retrieve]    
AS    
BEGIN    
SET NOCOUNT ON    
 SELECT    
   *     
 FROM           
   tbl_template_column    
 ORDER BY     
   column_name ASC    
 SET NOCOUNT OFF      
END
