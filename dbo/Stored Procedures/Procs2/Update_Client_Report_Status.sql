CREATE PROCEDURE Update_Client_Report_Status 
	@DomainId varchar(50),
	@ReportId int,
	@In_Progress bit
AS
BEGIN
	
	Update tblClient_Shared_Report_Details 
	Set In_Progress = @In_Progress
	WHERE DomainID=@DomainID AND ReportID = @ReportId 
	
END
