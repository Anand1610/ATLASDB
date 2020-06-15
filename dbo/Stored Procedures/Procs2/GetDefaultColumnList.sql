CREATE Procedure GetDefaultColumnList  
as  
BEGIN  
select dbo.[UDF_Remove_Duplicate_Entry] ((select Stuff((select   ','+ table_column from tbl_display_column_case_search FOR XML PATH('')), 1, 1, '')),',')  
END