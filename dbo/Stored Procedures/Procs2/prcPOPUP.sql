CREATE PROCEDURE [dbo].[prcPOPUP](@vCase_ID varchar(50))
as
	declare @Out varchar(400)
	Begin
select distinct(notes_type) from tblNotes where case_id=@vCase_Id and Notes_type='POPUP'
	end

