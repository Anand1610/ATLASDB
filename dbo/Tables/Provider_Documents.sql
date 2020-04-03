CREATE TABLE [dbo].[Provider_Documents] (
    [PDocID]      INT            IDENTITY (1, 1) NOT NULL,
    [File_Path]   NVARCHAR (100) NOT NULL,
    [FileName]    NVARCHAR (500) NOT NULL,
    [DocType_ID]  INT            NOT NULL,
    [CreatedBy]   NVARCHAR (50)  NOT NULL,
    [CreatedDate] DATETIME       NULL,
    [DomainId]    NVARCHAR (50)  NOT NULL,
    [Provider_Id] INT            NULL,
    [BasePathId]  INT            NULL,
    CONSTRAINT [PK_tblProvider_Documents] PRIMARY KEY CLUSTERED ([PDocID] ASC)
);

