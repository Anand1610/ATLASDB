CREATE TABLE [dbo].[docs] (
    [docID]           INT            IDENTITY (1, 1) NOT NULL,
    [pdfID]           INT            NOT NULL,
    [docDate]         DATETIME       NOT NULL,
    [docDateModified] DATETIME       NULL,
    [docStatus]       INT            NOT NULL,
    [docSettings]     INT            NOT NULL,
    [docFileName]     NVARCHAR (200) NOT NULL,
    [docXml]          NTEXT          NOT NULL,
    [docOutputData]   IMAGE          NULL,
    [DomainId]        NVARCHAR (50)  DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_docs] PRIMARY KEY CLUSTERED ([docID] ASC)
);

