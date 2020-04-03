CREATE PROCEDURE [dbo].[Update_Cases_Assigned_Attorney]
	@NewAssigned_Attorney varchar(100),
	@case_id varchar(20),
	@User_Id varchar(50)
AS
BEGIN
    Declare @NDesc varchar(max)
	set @NDesc = 'Assigned_Attorney changed from '+ (select Assigned_Attorney from tblcase where case_id = @Case_Id) +' to ' + @NewAssigned_Attorney
	
	if(@NewAssigned_Attorney<>'')
	begin
	   update tblcase
	   set  Assigned_Attorney = @NewAssigned_Attorney
	   where case_id = @case_id
   	
	   insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id)
	   values (@NDesc,'Activity',1,@Case_Id,getdate(),@User_Id)
    end
END

