CREATE TABLE [dbo].[tblGbbDocuments] (
    [ID]             INT            IDENTITY (1, 1) NOT NULL,
    [FileName]       VARCHAR (200)  NULL,
    [Path]           VARCHAR (2000) NULL,
    [NodeType]       VARCHAR (100)  NULL,
    [BasePathId]     INT            NULL,
    [BaseFilePath]   VARCHAR (200)  NULL,
    [BillNumber]     VARCHAR (50)   NULL,
    [Gbb_Type]       VARCHAR (50)   NULL,
    [DownloadStatus] VARCHAR (2000) NULL,
    [BasePathType]   VARCHAR (10)   NULL
);


GO
CREATE NONCLUSTERED INDEX [IDX_GBBDocuments]
    ON [dbo].[tblGbbDocuments]([BillNumber] ASC, [Gbb_Type] ASC)
    INCLUDE([Path]);

