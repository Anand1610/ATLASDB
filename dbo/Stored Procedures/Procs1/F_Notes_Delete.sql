CREATE PROCEDURE [dbo].[F_Notes_Delete]   --[dbo].[F_Notes_Delete]  
(  
@DomainId NVARCHAR(50),
@Notes_ID INT
)  
   
AS  
  
BEGIN  
  DECLARE @s_l_message NVARCHAR(500)
		
	INSERT INTO dbo.tblNotes_Deleted (Notes_ID,Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DATE_DELETED, DomainId)  
 SELECT Notes_ID,Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,getdate(), DomainId FROM tblNotes WHERE Notes_ID = @Notes_ID and DomainId=@DomainId 

   DELETE FROM tblNotes WHERE Notes_ID = @Notes_ID  and DomainId=@DomainId
   
   SET @s_l_message	=  'Notes Deleted successfuly'
   
   
   
   SELECT @s_l_message AS [MESSAGE]
  
END

