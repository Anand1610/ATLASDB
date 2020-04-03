CREATE TABLE [dbo].[ProviderCleanUP] (
    [id]         INT            NULL,
    [code]       NVARCHAR (255) NULL,
    [name]       NVARCHAR (255) NULL,
    [countcases] INT            NULL,
    [NEWID]      INT            NULL,
    [DomainId]   NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

