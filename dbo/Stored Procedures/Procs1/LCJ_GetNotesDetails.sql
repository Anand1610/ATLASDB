CREATE PROCEDURE [dbo].[LCJ_GetNotesDetails]      
(      
@DomainId VARCHAR(50),    
@Case_Id varchar(100),      
@Notes_Type varchar(100),      
@UserType varchar(10)      
)      
       
AS      
      
BEGIN      
        
  SET NOCOUNT ON
         
   SELECT   Notes_Desc, User_Id, Convert(VARCHAR(15), Notes_Date, 101)+' '+ Format(Notes_Date, 'hh:mm tt') AS Notes_Date, Notes_Type      
   FROM       tblNotes WITH(NOLOCK) where Case_Id = @Case_Id  and DomainId=@DomainId    
   and (@Notes_Type=' ---ALL--- '  or Notes_Type=@Notes_Type)    
   ORDER BY Notes_Id Desc,Notes_Date desc    
      
	  SET NOCOUNT OFF
-- END      
      
END    