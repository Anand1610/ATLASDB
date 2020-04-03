CREATE PROCEDURE [dbo].[F_GetNotesDetails]
(
			@s_a_case_id  NVARCHAR(10),
			@s_a_notes_type VARCHAR(20),
			@i_a_mode INT
)
AS
BEGIN
	IF(@s_a_notes_type ='')
		SELECT * FROM tblNotes WHERE Case_Id = @s_a_case_id order by Notes_ID desc
	ELSE
		SELECT * FROM tblNotes WHERE Case_Id = @s_a_case_id and Notes_Type = @s_a_notes_type order by Notes_ID desc

END

