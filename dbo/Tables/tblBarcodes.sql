CREATE TABLE [dbo].[tblBarcodes] (
    [Id]           BIGINT         IDENTITY (1, 1) NOT NULL,
    [BarcodeValue] NVARCHAR (200) NOT NULL,
    [PrintedDate]  DATETIME       NULL,
    [UserName]     NVARCHAR (50)  NULL,
    [DomainId]     NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

