CREATE PROCEDURE [dbo].[F_Notes_Update]      
(
@DomainId NVARCHAR(50),
@Notes_Id varchar(50),
@Notes_Type varchar(20),
@NDesc varchar(3000),
@User_Id varchar(50),
@Notes_Date Datetime =null
)
AS
BEGIN
UPDATE tblNotes SET Notes_Desc=@NDesc, Notes_Type=@Notes_Type,Notes_Date=isnull(@Notes_Date,getdate()),[User_Id]=@User_Id,DomainId=@DomainId WHERE Notes_ID=@Notes_Id and DomainId=@DomainId
END

