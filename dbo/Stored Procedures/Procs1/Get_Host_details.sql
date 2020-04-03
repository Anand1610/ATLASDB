

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_Host_details] 
	-- Add the parameters for the stored procedure here
	@DomainId varchar(50) ='',
	@ReportType NVARCHAR(50)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if(@DomainId != '' AND  @ReportType != '')
	BEGIN
	Select * from tblclient_Network_details WHERE DomainID=@DomainId AND Report_Type=@ReportType
	END
	ELSE
	Select * from tblclient_Network_details 

END

