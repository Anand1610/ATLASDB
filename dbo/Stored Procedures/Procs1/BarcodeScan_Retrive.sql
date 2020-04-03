CREATE PROCEDURE [dbo].[BarcodeScan_Retrive]
	-- Add the parameters for the stored procedure here
	@UserId nchar(10),
	@DomainId nvarchar(50),
	@DocType nvarchar(100),
	@TempPath nvarchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select BarcodeVal,
	case when ImagePath LIKE '%LSCasemanager/streambills.aspx%'
	THEN
	imagepath 
	ELSE
	(replace(@TempPath,'\','/')+ImagePath+FileName)
	END as Link, ImagePath+FileName as filepath  
	from BarcodeScan where UserId=@UserId and 
	DomainId=@DomainId and DocType=@DocType AND ActiveFlag=1
	ORDER BY ScanDate desc
END
