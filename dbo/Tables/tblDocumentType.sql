CREATE TABLE [dbo].[tblDocumentType] (
    [Document_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [Document_Type] NVARCHAR (255) NOT NULL,
    [doc_for]       INT            CONSTRAINT [DF_tblDocumentType_doc_for] DEFAULT ((0)) NULL,
    [Doc_Sequence]  INT            NULL,
    [Initial_docs]  BIT            CONSTRAINT [DF_tblDocumentType_Provider_docs] DEFAULT ((0)) NOT NULL,
    [DomainId]      NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_tblDocumentType] PRIMARY KEY CLUSTERED ([Document_ID] ASC) WITH (FILLFACTOR = 90)
);

