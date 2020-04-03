CREATE PROCEDURE [dbo].[F_AdminNotes_Add]
(
			@DomainId NVARCHAR(50),
			@s_a_notes_desc NVARCHAR(500),
			@s_a_user_Id VARCHAR(50),
			@s_a_notes_type NVARCHAR(20)
)
AS
BEGIN
	Insert into AdminNotes (Notes_Desc, Notes_Date,User_Id,Type,DomainId)
	values( @s_a_notes_desc,GETDATE(),@s_a_user_Id,@s_a_notes_type,@DomainId)

END

