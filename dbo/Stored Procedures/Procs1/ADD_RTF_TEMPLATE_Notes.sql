CREATE PROCEDURE [dbo].[ADD_RTF_TEMPLATE_Notes]
(
	@DomainId nvarchar(50),
	@Notes_Desc nvarchar(2000),
	@UID varchar(50),
	@template_name varchar(200),
	@type int
)
as
begin
	if (@type = 1)
	begin
		insert into tblRTFNotes(Notes_Desc,Notes_Date,template_name,User_Id,DomainId)
		values (@Notes_Desc, getdate(),@template_name,@UID,@DomainId)
	end
end

