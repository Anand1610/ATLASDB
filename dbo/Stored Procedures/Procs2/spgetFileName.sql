CREATE PROCEDURE [dbo].[spgetFileName](  
@getFName varchar(100)  
) as  
begin  
    declare   
 @st nvarchar(1000)  
    set @st = 'Select a.case_id,b.document_type from tblimages a inner join tbldocumenttype b on a.DocumentID = b.Document_ID where a.filename = '''+@getFName+'''' 
    execute sp_executesql @st  
end

