CREATE TABLE [dbo].[tblImages] (
    [ImagePath]        NVARCHAR (255) NOT NULL,
    [FileName]         NVARCHAR (100) NOT NULL,
    [ImageId]          INT            IDENTITY (1, 1) NOT NULL,
    [DocumentId]       NVARCHAR (20)  NOT NULL,
    [Case_Id]          NVARCHAR (50)  NOT NULL,
    [ScanDate]         SMALLDATETIME  NOT NULL,
    [UserId]           VARCHAR (50)   NULL,
    [RecordDescriptor] VARCHAR (220)  NULL,
    [DeleteFlag]       INT            CONSTRAINT [DF_tblImages_DeleteFlag] DEFAULT ((0)) NULL,
    [DomainId]         NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_tblImages] PRIMARY KEY CLUSTERED ([ImageId] ASC) WITH (FILLFACTOR = 90)
);

