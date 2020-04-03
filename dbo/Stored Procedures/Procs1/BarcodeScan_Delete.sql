CREATE PROCEDURE [dbo].[BarcodeScan_Delete] 
	-- Add the parameters for the stored procedure here
	@UserId nchar(10),
	@DomainId nvarchar(50),
	@DocType nvarchar(100),
	@BarcodeVal nvarchar(50),
	@FileName nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Update BarcodeScan SET ActiveFlag = 0 where --UserId=@UserId AND 
	DomainId=@DomainId AND DocType=@DocType AND BarcodeVal=@BarcodeVal AND FileName=@FileName
	--delete from BarcodeScan where UserId=@UserId AND DomainId=@DomainId AND DocType=@DocType AND BarcodeVal=@BarcodeVal AND FileName=@FileName
END
