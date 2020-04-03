CREATE TABLE [dbo].[tblWorkflowDailyReport] (
    [DailyReportID] INT           IDENTITY (1, 1) NOT NULL,
    [DomainId]      VARCHAR (50)  NOT NULL,
    [Email_To]      VARCHAR (MAX) NOT NULL,
    [Email_CC]      VARCHAR (MAX) NULL,
    [Email_BCC]     VARCHAR (MAX) NULL,
    [Sent_Date]     DATETIME      NULL,
    CONSTRAINT [PK_tblWorkflowDailyReport] PRIMARY KEY CLUSTERED ([DailyReportID] ASC)
);

