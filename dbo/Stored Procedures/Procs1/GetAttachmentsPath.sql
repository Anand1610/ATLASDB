CREATE PROCEDURE [dbo].[GetAttachmentsPath] --'FH10-68763'
	@Case_ID varchar(50)
AS
BEGIN
	SELECT
		ImagePath + '\' + FileName [InputFilePath]
	FROM
		tblExhibitSequence INNER JOIN tblimages
		ON Exhibit_Id = DocumentID
	WHERE 
		tblimages.Case_Id = @Case_ID
		and tblExhibitSequence.Case_Id = @Case_ID
		and DocumentID in(select exhibit_id from tblexhibitsequence where case_id=@Case_ID)	
	ORDER BY Sequence ASC
END

