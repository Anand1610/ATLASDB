CREATE TABLE [dbo].[pdfs] (
    [pdfID]         INT            IDENTITY (1, 1) NOT NULL,
    [pdfDate]       DATETIME       NOT NULL,
    [pdfStatus]     INT            NOT NULL,
    [pdfVersion]    INT            NOT NULL,
    [pdfPageLoaded] INT            NOT NULL,
    [pdfPageCount]  INT            NOT NULL,
    [pdfUserRights] INT            NOT NULL,
    [pdfDpi]        INT            NOT NULL,
    [pdfDpiHigh]    INT            NOT NULL,
    [pdfData]       IMAGE          NOT NULL,
    [pdfDataLength] INT            NOT NULL,
    [pdfDataHash]   BINARY (64)    NOT NULL,
    [pdfPassHash]   BINARY (64)    NULL,
    [pdfXml]        NTEXT          NOT NULL,
    [pdfText]       NTEXT          NOT NULL,
    [DomainId]      NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_pdfs] PRIMARY KEY CLUSTERED ([pdfID] ASC)
);

