CREATE PROCEDURE [dbo].[CheckReportSentValueForDomain]   
 @DomainID varchar(50),  
 @ReportType NVARCHAR(50)  
AS  
BEGIN  

 SET NOCOUNT ON;  
  
 Select * from tblClient_Shared_Report_Details   
 WHERE DomainID=@DomainID AND Report_Type=@ReportType AND CONVERT(date, Report_Date)=CONVERT(date, getdate()) 
 AND ISNULL(Is_Processed,0) = 0 AND ISNULL(In_Progress,0) = 0
END  
  