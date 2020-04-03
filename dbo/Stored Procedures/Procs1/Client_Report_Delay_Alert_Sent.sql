CREATE PROCEDURE Client_Report_Delay_Alert_Sent 
	@ReportIds varchar(8000)
AS
BEGIN
	
	Update tblClient_Shared_Report_Details 
	Set Is_DelayAlertSent = 1
	WHERE ReportID in (Select s from SplitString(@ReportIds,','))
	
END
