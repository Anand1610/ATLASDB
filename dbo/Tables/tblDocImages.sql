CREATE TABLE [dbo].[tblDocImages] (
    [ImageID]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Filename]         VARCHAR (255)  NOT NULL,
    [FilePath]         VARCHAR (255)  NOT NULL,
    [OCRData]          TEXT           NULL,
    [Status]           BIT            NULL,
    [is_saga_doc]      BIT            NULL,
    [nodeid]           BIGINT         NULL,
    [createduser]      VARCHAR (200)  NULL,
    [Revisededuser]    VARCHAR (200)  NULL,
    [createddate]      DATETIME       NULL,
    [Revisededdate]    DATETIME       NULL,
    [from_flag]        INT            NULL,
    [description]      VARCHAR (500)  NULL,
    [DOCUMENTID]       BIGINT         NULL,
    [imageid1]         INT            NULL,
    [DomainId]         NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    [BasePathId]       INT            NULL,
    [statusdone]       VARCHAR (200)  NULL,
    [FilePathOld]      VARCHAR (255)  NULL,
    [Node_ID]          INT            NULL,
    [CID]              NVARCHAR (100) NULL,
    [BillNumber]       VARCHAR (100)  NULL,
    [ACT_CASE_ID]      VARCHAR (40)   NULL,
    [azure_statusdone] VARCHAR (100)  NULL,
    [IsDeleted]        BIT            DEFAULT ((0)) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CIDX_tblDocImages]
    ON [dbo].[tblDocImages]([ImageID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_tblDocImages_Domain_imageId]
    ON [dbo].[tblDocImages]([DomainId] ASC, [ImageID] ASC)
    INCLUDE([Filename], [FilePath], [Status], [nodeid], [BasePathId], [DOCUMENTID]);

