CREATE TABLE [dbo].[objs] (
    [objID]         INT            IDENTITY (1, 1) NOT NULL,
    [docID]         INT            NOT NULL,
    [objType]       INT            NOT NULL,
    [objSettings]   INT            NOT NULL,
    [objData]       IMAGE          NOT NULL,
    [objDataLength] INT            NOT NULL,
    [DomainId]      NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_objs] PRIMARY KEY CLUSTERED ([objID] ASC)
);

