CREATE TABLE [dbo].[tblAutoEmailRecipients] (
    [pk_recipient_id]   INT           IDENTITY (1, 1) NOT NULL,
    [DomainId]          VARCHAR (50)  NOT NULL,
    [ToEmail]           VARCHAR (MAX) NOT NULL,
    [CCEMail]           VARCHAR (MAX) NULL,
    [BCCEmail]          VARCHAR (MAX) NULL,
    [fk_report_type_id] INT           NULL,
    PRIMARY KEY CLUSTERED ([pk_recipient_id] ASC),
    CONSTRAINT [tblAutoEmailRecipients_fk_report_type_id] FOREIGN KEY ([fk_report_type_id]) REFERENCES [dbo].[tblAutoEmailReportType] ([pk_report_type_id])
);

