CREATE PROCEDURE [dbo].[Shared_Report_Details_Update]   
 @DomainID varchar(50),  
 @Report_Name nvarchar(50),  
 @Report_Sent_To nvarchar(50),  
 @Report_Folder nvarchar(50),  
 @Share_URL nvarchar(500),  
 @Report_Type NVARCHAR(50),
 @ReportId int
  
AS  
BEGIN  
  
 SET NOCOUNT ON;  
			 Update tblClient_Shared_Report_Details Set
			 Report_Name = @Report_Name,
			 Report_Sent_To = @Report_Sent_To,
			 Report_Folder = @Report_Folder,
			 Share_URL = @Share_URL,
			 Is_Processed = 1, 
			 In_Progress = 0  
			 Where DomainID = @DomainID and Report_Type = @Report_Type and ReportID = @ReportId
END  
  