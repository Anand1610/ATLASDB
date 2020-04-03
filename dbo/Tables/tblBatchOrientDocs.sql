CREATE TABLE [dbo].[tblBatchOrientDocs] (
    [DocId]       INT           IDENTITY (1, 1) NOT NULL,
    [Batch_Type]  VARCHAR (250) NOT NULL,
    [Docs_Name]   VARCHAR (250) NOT NULL,
    [Exhibit]     VARCHAR (500) NULL,
    [Sequence_No] INT           NOT NULL,
    [DomainId]    VARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_tblBatchOrientDocs] PRIMARY KEY CLUSTERED ([DocId] ASC)
);

