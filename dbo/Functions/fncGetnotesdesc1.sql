CREATE FUNCTION [dbo].[fncGetnotesdesc1](@Case_id varchar(50))
returns varchar(MAX) as
BEGIN
 DECLARE @filedesc VARCHAR(200)
 DECLARE @OutputString VARCHAR(8000)
 
 DECLARE CUR_Notes CURSOR
 FOR SELECT distinct notes_desc FROM tblnotes inner join tblcase
     on tblcase.Case_Id=tblnotes.Case_Id where tblnotes.Notes_Type in('Pending','popup') and tblcase.Case_Id=@Case_id
 
 OPEN CUR_Notes
 
 set @OutputString = ''
 FETCH CUR_Notes INTO @filedesc
 
 set @OutputString = ''
 WHILE @@FETCH_STATUS = 0
  BEGIN
   set @OutputString = @OutputString +  @filedesc + convert(varchar(200),',')
   FETCH CUR_Notes INTO @filedesc
  END
  CLOSE CUR_Notes
 DEALLOCATE CUR_Notes

	if 	len(@OutputString) >0
		set @OutputString = LEFT(@OutputString, LEN(ltrim(rtrim(@OutputString))) - 1)

 RETURN @OutputString 
END
