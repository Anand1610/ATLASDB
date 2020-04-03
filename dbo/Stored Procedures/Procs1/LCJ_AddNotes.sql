CREATE PROCEDURE [dbo].[LCJ_AddNotes]
(
@DomainId varchar(50),
@Case_Id varchar(50),
@Notes_Type varchar(20),
@NDesc varchar(3000),
@User_Id varchar(50),
@ApplyToGroup int=1
)
AS
BEGIN
	

if @ApplyToGroup > 0 
begin
	Insert into tblNotes (Notes_Desc, Notes_Type, Notes_Priority, Case_Id, Notes_Date, User_Id, DomainId) 
	select @NDesc,@Notes_Type,1,Case_Id,getdate(),@User_Id,@DomainId from tblCase (NOLOCK) where Group_Data=1 and Group_Id in (select Group_Id from tblCase (NOLOCK) where Case_Id=@Case_Id AND DomainId = @DomainId)
end
else
begin
	insert into tblNotes (Notes_Desc, Notes_Type, Notes_Priority, Case_Id, Notes_Date, User_Id, DomainId) 
	values (@NDesc,@Notes_Type,1,@Case_Id,getdate(),@User_Id,@DomainId)
end

if @Notes_Type = 'DELAY' 
begin
	Insert into TXN_VERIFICATION_REQUEST(SZ_CASE_ID,DT_VERIFICATION_RECEIVED,SZ_NOTES,SZ_USER_ID,DomainID) 
	values(@Case_Id,getdate(),@NDesc,@User_Id,@DomainId)
end

END

