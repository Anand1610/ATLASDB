CREATE PROCEDURE [dbo].[Get_Associated_PDF_Notes]
	@File_Name varchar(5000),
	@File_Path varchar(5000)
AS
BEGIN
SELECT [Pdf_ID]
      ,[File_Name]
      ,[File_Path]
      ,[Page_Number]
      ,[Case_Id]
      ,[DateAssociated]
      ,[AssociatedBy]
  FROM [dbo].[Associated_Pdf_Notes]
  where File_Name=@File_Name
  and File_Path=@File_Path
  order by Page_Number,Case_Id
END

