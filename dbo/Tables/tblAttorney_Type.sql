CREATE TABLE [dbo].[tblAttorney_Type] (
    [Attorney_Type_ID] INT            IDENTITY (1, 1) NOT NULL,
    [Attorney_Type]    VARCHAR (100)  NOT NULL,
    [DomainID]         VARCHAR (50)   NOT NULL,
    [created_by_user]  NVARCHAR (255) NULL,
    [created_date]     DATETIME       NULL,
    [modified_by_user] NVARCHAR (255) NULL,
    [modified_date]    DATETIME       NULL
);

