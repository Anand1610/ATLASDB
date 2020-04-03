CREATE TABLE [dbo].[BarcodeScan] (
    [ImageId]       INT            IDENTITY (1, 1) NOT NULL,
    [FileName]      NVARCHAR (100) NULL,
    [ImagePath]     NVARCHAR (255) NULL,
    [BarcodeVal]    NVARCHAR (50)  NULL,
    [ScanDate]      DATETIME       NULL,
    [UserId]        NCHAR (10)     NULL,
    [DomainId]      NVARCHAR (50)  NULL,
    [DocType]       NVARCHAR (100) NULL,
    [BarcodeFormat] NVARCHAR (100) NULL,
    [ActiveFlag]    BIT            NULL,
    CONSTRAINT [PK_BarcodeScan] PRIMARY KEY CLUSTERED ([ImageId] ASC)
);

