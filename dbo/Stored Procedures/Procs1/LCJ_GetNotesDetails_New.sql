CREATE PROCEDURE [dbo].[LCJ_GetNotesDetails_New] --[LCJ_GetNotesDetails_New] 'mccollum' ,'MCCOLLUM17-14151' ,'',''   
(      
	@DomainId VARCHAR(40),    
	@Case_Id VARCHAR(40),      
	@Notes_Type VARCHAR(40),      
	@UserType VARCHAR(10) =''   
)      
       
AS      
      
BEGIN      
  
    SELECT   Notes_ID,Notes_Desc, User_Id, Convert(VARCHAR(10), Notes_Date, 101)+' '+ Format(Notes_Date, 'hh:mm tt') AS Notes_Date, tblNotes.Notes_Type, tblNotesType.NotesType_Id NTID    
   FROM       tblNotes  WITH(NOLOCK)
   left outer join tblNotesType WITH(NOLOCK) on tblNotes.Notes_Type=tblNotesType.Notes_Type  and tblNotes.DomainId=tblNotesType.DomainId  
    WHERE Case_Id = @Case_Id      
	AND tblnotes.DomainId=@DomainId    
   ORDER BY Notes_Id DESC,Notes_Date ASC    
      
-- END      
      
END    
