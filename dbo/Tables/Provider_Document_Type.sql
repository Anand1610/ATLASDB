CREATE TABLE [dbo].[Provider_Document_Type] (
    [Doc_Id]           INT            IDENTITY (1, 1) NOT NULL,
    [ProviderDoc_Type] NVARCHAR (50)  NOT NULL,
    [domainId]         NVARCHAR (50)  NULL,
    [created_by_user]  NVARCHAR (255) DEFAULT ('admin') NOT NULL,
    [created_date]     DATETIME       NULL,
    [modified_by_user] NVARCHAR (255) NULL,
    [modified_date]    DATETIME       NULL
);

