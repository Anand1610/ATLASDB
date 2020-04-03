CREATE PROCEDURE [dbo].[BarcodeScan_Save]
	-- Add the parameters for the stored procedure here
	@FileName nvarchar(100),
	@ImagePath nvarchar(255),
	@BarcodeVal nvarchar(50),
	@UserId nchar(10),
	@DomainId nvarchar(50),
	@DocType nvarchar(100),
	@BarcodeFormat nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into BarcodeScan(FileName,ImagePath,BarcodeVal,UserId,DomainId,DocType,ScanDate,BarcodeFormat,ActiveFlag)
	values(@FileName,@ImagePath,@BarcodeVal,@UserId,@DomainId,@DocType,GETDATE(),@BarcodeFormat,1)
END



