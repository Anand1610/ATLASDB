CREATE PROCEDURE [dbo].[LCJ_GetAdminNotesDetails] -- [LCJ_GetAdminNotesDetails]'Add Box Detail','06122012_1'
(  
@DomainId nvarchar(50),
@Notes_Type nvarchar(100),
@batch_num nvarchar(100)
)  
   
AS    
BEGIN 
 SELECT   Notes_Id,SUBSTRING (Notes_Desc , CHARINDEX('s', Notes_Desc) + 12, LEN(Notes_Desc)) as Notes_Desc, User_Id, Notes_Date
   FROM       AdminNotes where Type  = +@Notes_Type and Notes_Desc like '%'+@batch_num+'%' AND @DomainId = DomainId
   
   ORDER BY Notes_Date desc  
END

