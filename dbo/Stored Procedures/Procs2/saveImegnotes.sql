create procedure saveImegnotes
@Notes_Desc varchar(max),
@Case_Id varchar(50),
@User_Id varchar(50),
@DomainId varchar(10)
as
begin
insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DomainId)
values(@Notes_Desc,'Activity',1,@Case_Id,GETDATE(),@User_Id,@DomainId)
end