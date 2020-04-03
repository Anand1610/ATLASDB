CREATE TABLE [dbo].[pges] (
    [pgeID]        INT            IDENTITY (1, 1) NOT NULL,
    [pdfID]        INT            NOT NULL,
    [docID]        INT            NOT NULL,
    [keyID]        INT            NOT NULL,
    [pgeDate]      DATETIME       NOT NULL,
    [pgeStatus]    INT            NOT NULL,
    [pgeNumber]    INT            NOT NULL,
    [pgeImageType] INT            NOT NULL,
    [pgeImageData] IMAGE          NULL,
    [DomainId]     NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_pges] PRIMARY KEY CLUSTERED ([pgeID] ASC)
);

