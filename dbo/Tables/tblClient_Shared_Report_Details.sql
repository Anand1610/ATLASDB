CREATE TABLE [dbo].[tblClient_Shared_Report_Details] (
    [ReportID]          INT            IDENTITY (1, 1) NOT NULL,
    [Report_Name]       NVARCHAR (50)  NOT NULL,
    [Report_Sent_To]    NVARCHAR (50)  NOT NULL,
    [Report_Folder]     NVARCHAR (50)  NOT NULL,
    [Share_URL]         NVARCHAR (500) NOT NULL,
    [Report_Date]       DATETIME       NOT NULL,
    [DomainID]          VARCHAR (50)   NOT NULL,
    [Report_Type]       NVARCHAR (50)  NULL,
    [Is_Processed]      BIT            NULL,
    [In_Progress]       BIT            NULL,
    [Is_DelayAlertSent] BIT            NULL
);

