CREATE TABLE [dbo].[tblLogs] (
    [szMessage] NVARCHAR (2000) NULL,
    [dt]        DATETIME        DEFAULT (getdate()) NULL,
    [DomainId]  NVARCHAR (512)  DEFAULT ('h1') NOT NULL
);

