CREATE PROCEDURE [dbo].[stips_notes] (
@case_id nvarchar(100)
)
as
insert into tblnotes (notes_desc,User_Id,case_id,notes_date,notes_type,notes_priority) values
('Stipulation of discontinuous printed','system',@case_id,getdate(),'A',0)

