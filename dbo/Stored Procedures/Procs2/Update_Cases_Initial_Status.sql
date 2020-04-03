CREATE PROCEDURE [dbo].[Update_Cases_Initial_Status]
	@status varchar(100),
	@case_id varchar(20),
	@User_Id varchar(50),
    @Desc nvarchar(2000),
    @NoteType varchar(100)
AS
BEGIN
    Declare @NDesc varchar(max)
	set @NDesc = 'Initial_Status changed from '+ (select Initial_Status from tblcase where case_id = @Case_Id) +' to ' + @status
	
	if(@status<>'')
	begin
	   update tblcase
	   set  Initial_Status = @status
	   where case_id = @case_id
   	
	   insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id)
	   values (@NDesc,'Activity',1,@Case_Id,getdate(),@User_Id)
    end
    
    if(@Desc<>'')
    begin
      insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id)
	  values (@Desc,@NoteType,1,@Case_Id,getdate(),@User_Id)
	end
END

