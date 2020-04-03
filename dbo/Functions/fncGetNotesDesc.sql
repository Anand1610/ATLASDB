CREATE FUNCTION [dbo].[fncGetNotesDesc](@Case_id varchar(50))
returns varchar(8000) as
BEGIN
 DECLARE @description VARCHAR(8000)
 DECLARE @OutputString VARCHAR(8000)
 
 DECLARE CUR_Notes CURSOR
 FOR select NOTES_DESC+' ('+CONVERT(NVARCHAR(12),NOTES_DATE,101)+')' as Notes_description from tblnotes where  case_id=@Case_id AND NOTES_TYPE in ('PROVIDER') --,'PENDING'
  Order BY NOTES_DATE desc
 
 OPEN CUR_Notes
 
 set @OutputString = ''
 FETCH CUR_Notes INTO @description
 
 set @OutputString = ''
 WHILE @@FETCH_STATUS = 0
  BEGIN
   set @OutputString = @OutputString +  @description + '<BR>'
   FETCH CUR_Notes INTO @description
  END
  CLOSE CUR_Notes
 DEALLOCATE CUR_Notes

 if  len(@OutputString) >1
  set @OutputString = LEFT(@OutputString, LEN(ltrim(rtrim(@OutputString))) - 4)

 RETURN @OutputString 
END
