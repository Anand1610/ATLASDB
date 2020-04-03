CREATE TABLE [dbo].[keys] (
    [keyID]       INT            IDENTITY (1, 1) NOT NULL,
    [docID]       INT            NOT NULL,
    [keyData]     CHAR (25)      NOT NULL,
    [keyExpires]  DATETIME       NOT NULL,
    [keySettings] INT            NOT NULL,
    [DomainId]    NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_keys] PRIMARY KEY CLUSTERED ([keyID] ASC)
);

