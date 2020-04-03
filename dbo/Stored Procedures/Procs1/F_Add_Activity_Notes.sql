CREATE PROCEDURE [dbo].[F_Add_Activity_Notes]
(
			@DomainId nvarchar(50),
			@s_a_case_id  NVARCHAR(100),
			@s_a_notes_type VARCHAR(20),
			@s_a_ndesc VARCHAR(3000),
			@s_a_user_Id VARCHAR(50),
			@i_a_applytogroup INT
)
AS
BEGIN
	INSERT INTO tblNotes(DomainId, case_id, Notes_Type, Notes_Date,Notes_Priority,Notes_Desc,User_Id)
	values( @DomainId, @s_a_case_id, @s_a_notes_type,GETDATE(),'0',@s_a_ndesc,@s_a_user_Id)
	

	--Insert into tbl_case_activity (case_id, activity_category, created_date,description,Created_User_ID)
	--values( @s_a_case_id, @s_a_notes_type,GETDATE(),@s_a_ndesc,@s_a_user_Id)

END

