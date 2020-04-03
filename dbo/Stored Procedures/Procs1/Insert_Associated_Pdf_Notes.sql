CREATE PROCEDURE [dbo].[Insert_Associated_Pdf_Notes]
@File_Name varchar(5000),
@File_Path varchar(5000),
@Page_Number int,
@Case_Id	varchar(200),
@AssociatedBy	varchar(200)
AS
BEGIN
INSERT INTO [dbo].[Associated_Pdf_Notes]
           ([File_Name]
           ,[File_Path]
           ,[Page_Number]
           ,[Case_Id]
           ,[DateAssociated]
           ,[AssociatedBy])
     VALUES
           (@File_Name,
		   @File_Path,
		   @Page_Number,
		   @Case_Id,
		   GETDATE(),
		   @AssociatedBy)
END

