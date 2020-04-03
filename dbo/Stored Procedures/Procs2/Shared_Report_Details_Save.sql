CREATE PROCEDURE [dbo].[Shared_Report_Details_Save]   
 @DomainID varchar(50),  
 @Report_Name nvarchar(50),  
 @Report_Sent_To nvarchar(50),  
 @Report_Folder nvarchar(50),  
 @Share_URL nvarchar(500),  
 @Report_Type NVARCHAR(50)  
  
AS  
BEGIN  
  
 SET NOCOUNT ON;  
	IF Not Exists(Select ReportID From tblClient_Shared_Report_Details Where DomainID=@DomainID AND Report_Type=@Report_Type AND CONVERT(date, Report_Date)=CONVERT(date, getdate()) )
		BEGIN
			 INSERT INTO tblClient_Shared_Report_Details
			 (DomainID,Report_Name,Report_Sent_To,Report_Folder,Share_URL,Report_Date,Report_Type, Is_Processed, In_Progress, Is_DelayAlertSent)  
			 VALUES(@DomainID,@Report_Name,@Report_Sent_To,@Report_Folder,@Share_URL,GETDATE(),@Report_Type, 0, 0, 0)  
		END
END  
  