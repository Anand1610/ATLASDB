CREATE TABLE [dbo].[deflist] (
    [DEFENDANTNAME] NVARCHAR (255) NULL,
    [ID]            INT            NULL,
    [CNT]           INT            NULL,
    [NEWID]         INT            NULL,
    [DomainId]      NVARCHAR (50)  DEFAULT ('h1') NOT NULL
);

