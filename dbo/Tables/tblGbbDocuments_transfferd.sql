CREATE TABLE [dbo].[tblGbbDocuments_transfferd] (
    [ID]               INT            IDENTITY (1, 1) NOT NULL,
    [Path]             VARCHAR (2000) NULL,
    [NodeType]         VARCHAR (100)  NULL,
    [BasePathId]       INT            NULL,
    [TransferFilePath] VARCHAR (2000) NULL,
    [BillNumber]       VARCHAR (50)   NULL,
    [Gbb_Type]         VARCHAR (50)   NULL,
    [Trnasfferd_Date]  DATETIME       NULL
);

