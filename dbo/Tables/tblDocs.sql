CREATE TABLE [dbo].[tblDocs] (
    [Doc_Id]     INT            IDENTITY (1, 1) NOT NULL,
    [Doc_Name]   NVARCHAR (500) NULL,
    [Doc_Value]  NVARCHAR (500) NULL,
    [Settlement] BIT            CONSTRAINT [DF_tblDocs_Settlement] DEFAULT ((0)) NULL,
    [DomainId]   NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

