CREATE TABLE [dbo].[Financial_Report_Track] (
    [ID]            INT            IDENTITY (1, 1) NOT NULL,
    [DomainID]      NVARCHAR (50)  NULL,
    [provider_id]   INT            NULL,
    [provider_name] NVARCHAR (150) NULL,
    [report_month]  NVARCHAR (50)  NULL,
    [file_path]     NVARCHAR (500) NULL,
    [mail_sent]     NVARCHAR (50)  NULL,
    [sent_date]     DATETIME       NULL,
    [file_name]     VARCHAR (500)  NULL,
    [BasePathId]    INT            NULL,
    CONSTRAINT [PK_Financial_Report_Track] PRIMARY KEY CLUSTERED ([ID] ASC)
);

