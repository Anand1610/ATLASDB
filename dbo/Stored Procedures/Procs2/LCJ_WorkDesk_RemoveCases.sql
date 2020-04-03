CREATE PROCEDURE [dbo].[LCJ_WorkDesk_RemoveCases]
(
@DomainID NVARCHAR(50),
@Desk_Id NVARCHAR(200),
@Case_Id NVARCHAR(3000),
@User_Id NVARCHAR(50)

)
AS
BEGIN
	DECLARE
	@ST NVARCHAR(3500)
	IF @Case_Id <> '' AND @Desk_Id <> ''
		BEGIN

		SET @ST = 'Delete from tblCaseDesk where Desk_Id = '+@Desk_Id + ' And Case_Id in (''' +Replace(@Case_Id,',',''',''') + ''')'
		PRINT @ST
		EXEC SP_EXECUTESQL @ST
		INSERT INTO tblNotes  (Notes_Desc,	Notes_Type,	Notes_Priority,	Case_Id,	Notes_Date,	User_Id,	DomainId) 
		VALUES ('Case deleted from default desk!','Activity',1,@Case_Id, getdate(),@User_Id,@DomainID)
	END
END

