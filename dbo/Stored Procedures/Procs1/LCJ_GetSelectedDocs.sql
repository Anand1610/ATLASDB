CREATE PROCEDURE [dbo].[LCJ_GetSelectedDocs] --'FH10-73699'
(
@Case_id varchar(50)
)
as 
begin
	SELECT
		Document_ID,
		Document_Type
	FROM
		tblExhibitSequence INNER JOIN tbldocumenttype
		ON Exhibit_Id = Document_ID
	WHERE 
		Case_Id = @Case_id
	ORDER BY Sequence ASC
end

