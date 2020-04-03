CREATE FUNCTION [dbo].[fncGetServiceType](@Case_id varchar(50))  
returns varchar(8000) as  
BEGIN 

 DECLARE @servicetype VARCHAR(200)  
 DECLARE @OutputString VARCHAR(8000)  
   

     SELECT 
     @OutputString = STUFF((SELECT distinct  ',' + cast(Service_Type  as varchar(200))
                             FROM  tbltreatment with(nolock) where case_id= @Case_id
                             --ORDER BY Service_Type
                             FOR XML PATH('')), 
                            1, 1, '')


  
     RETURN @OutputString   
 END