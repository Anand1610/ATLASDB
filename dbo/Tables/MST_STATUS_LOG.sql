CREATE TABLE [dbo].[MST_STATUS_LOG] (
    [ID]           INT            IDENTITY (1, 1) NOT NULL,
    [CASE_ID]      NVARCHAR (100) NULL,
    [DATE_CHANGED] DATETIME       NULL,
    [STATUS_BIT]   INT            NULL,
    [DomainId]     NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

