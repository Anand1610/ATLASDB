CREATE PROCEDURE [dbo].[F_Get_TiffImages_by_Case_Id]   --[dbo].[F_Get_TiffImages_by_Case_Id] 'FH13-1630614'     
(
	@Case_Id VARCHAR(200)
)
AS  
	BEGIN
			SELECT A.Case_Id  AS Case_Id,REPLACE(B.Document_Type,'/','-') AS Doc_Type,A.FileName AS [FileName],A.ImagePath AS ImgPath FROM tblImages A INNER JOIN tblDocumentType B ON A.DocumentId=B.Document_ID
			WHERE A.Case_Id=@Case_Id
	END

