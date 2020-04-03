CREATE PROCEDURE [dbo].[SP_ADD_REJECTION_REQUEST]-- [SP_ADD_REJECTION_REQUEST] 'FH12-95855','16','tech',1
(  
   @Case_ID nvarchar(50),
   @List_ID int,
   @USER nvarchar(50),
   @chkStatus bit
)  
as  
begin  
 Declare @desc nvarchar(1000)
 
 --select * from tblREJECTION_REQUEST
 if (not exists(select list_id from tblREJECTION_REQUEST where case_id= @Case_ID and list_id =@list_id) and @chkStatus = 1)
 Begin
  insert into tblREJECTION_REQUEST(case_id, list_id)
  values(@Case_ID, @List_ID)
  
  set @desc = (select List_Status +' - '+ List_Name +' is Added' from MST_REQUEST_REJECTION_MASTER where List_Id =@List_ID)
  
  exec LCJ_AddNotes @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@USER,@ApplyToGroup = 0   
 End
 
 if (exists(select list_id from tblREJECTION_REQUEST where case_id= @Case_ID and list_id =@list_id) and @chkStatus = 0)
 Begin
  delete from  tblREJECTION_REQUEST where list_id=@list_id and case_id= @Case_ID
  
  set @desc = (select List_Status +' - '+ List_Name +' is Deleted' from MST_REQUEST_REJECTION_MASTER where List_Id =@List_ID)
  
  exec LCJ_AddNotes @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@USER,@ApplyToGroup = 0   

 End
 
end

