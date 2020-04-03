CREATE PROCEDURE [dbo].[Update_Letter_Name]
	@Lettername VARCHAR(200),
	@Letterid INT
AS
BEGIN
	UPDATE tbl_Client_Letter
	SET Letter_Display_Name = @Lettername
	WHERE Letter_Auto_Id = @Letterid
END

