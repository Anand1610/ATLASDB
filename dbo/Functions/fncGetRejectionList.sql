CREATE FUNCTION [dbo].[fncGetRejectionList](@Case_id varchar(50))
returns varchar(MAX) as
BEGIN
 DECLARE @Request_List VARCHAR(200)
 DECLARE @OutputString VARCHAR(8000)
 
 DECLARE CUR_Notes CURSOR
 FOR select List_Name from MST_REQUEST_REJECTION_MASTER where List_id in(select list_id from tblREJECTION_REQUEST where case_id=@Case_id) and list_status='REJECTION LIST'  
 OPEN CUR_Notes
 
 set @OutputString = ''
 FETCH CUR_Notes INTO @Request_List
 
 set @OutputString = ''
 WHILE @@FETCH_STATUS = 0
  BEGIN
   set @OutputString = @OutputString +  @Request_List + convert(varchar(200),', ')
   FETCH CUR_Notes INTO @Request_List
  END
  CLOSE CUR_Notes
 DEALLOCATE CUR_Notes

	if 	len(@OutputString) >0
		set @OutputString = LEFT(@OutputString, LEN(ltrim(rtrim(@OutputString))) - 1)

 RETURN @OutputString 
END
