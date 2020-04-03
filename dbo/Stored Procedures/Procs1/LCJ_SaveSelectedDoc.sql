CREATE PROCEDURE [dbo].[LCJ_SaveSelectedDoc]
(
  @Case_Id varchar(50),
  @Exhibit_Id int
)
as
begin
declare @Sequence int

--if exists(select Exhibit_Id from tblExhibitSequence where Case_Id=@Case_Id and Exhibit_Id=@Exhibit_Id)
  --begin
	--delete tblExhibitSequence where Exhibit_Id=@Exhibit_Id and Case_Id=@Case_Id

	set @Sequence = (select isnull(max(Sequence),0)+1 from tblExhibitSequence where Case_Id = @Case_Id)
	BEGIN TRAN
		insert into tblExhibitSequence(Case_Id,Exhibit_Id,Sequence)Values(@Case_Id,@Exhibit_Id,@Sequence)
	COMMIT TRAN
end

