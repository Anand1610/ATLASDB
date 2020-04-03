CREATE TABLE [dbo].[tblAutoEmailReportType] (
    [pk_report_type_id] INT           IDENTITY (1, 1) NOT NULL,
    [DomainId]          VARCHAR (50)  NOT NULL,
    [report_type]       VARCHAR (MAX) NOT NULL,
    PRIMARY KEY CLUSTERED ([pk_report_type_id] ASC)
);

