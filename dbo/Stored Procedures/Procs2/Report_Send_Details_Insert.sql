-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Report_Send_Details_Insert] 
	-- Add the parameters for the stored procedure here	
	@Provider nvarchar(MAX),	
	@FileName nvarchar(500),	
	@domainID nvarchar(512),
	@Generated_By int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	

	insert into Report_Send_Details(Provider,Report_Send_Date,Filename,domainID,Generated_By,Report_Send_Id)
	OUTPUT inserted.Report_Send_Id
	values(@Provider,GETDATE(),@FileName,@domainID,@Generated_By,ISNULL(( select MAX(Report_Send_Id)+1 from Report_Send_Details),1))
END
