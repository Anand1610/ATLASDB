CREATE PROCEDURE [dbo].[F_DDL_NotesType]  
/*  
 (  
  @parameter1 datatype = default value,  
  @parameter2 datatype OUTPUT  
 )  
*/		
AS  
--ALTER TABLE #tmpNotesType  
-- (NotesType_Id int, Notes_Type varchar(50))  
  
begin  
  
--insert into #tmpNotesType values(0,'...Select Firm...')  
--insert into #tmpNotesType  
  
 SELECT    DISTINCT NotesType_Id, Upper(ISNULL(Notes_Type, '')) AS Notes_Type  
 FROM         tblNotesType  
 WHERE     (1 = 1) order by Notes_Type
  
--select NotesType_Id, Notes_Type from #tmpNotesType order by 2  
end

