CREATE TABLE [dbo].[tblAttorney_Case_Assignment] (
    [Assignment_Id]    INT            IDENTITY (1, 1) NOT NULL,
    [Attorney_Type_Id] NVARCHAR (50)  NOT NULL,
    [Attorney_Id]      INT            NOT NULL,
    [Case_Id]          NVARCHAR (50)  NOT NULL,
    [DomainId]         NVARCHAR (512) NOT NULL,
    [created_by_user]  NVARCHAR (255) NOT NULL,
    [created_date]     DATETIME       NULL,
    [modified_by_user] NVARCHAR (255) NULL,
    [modified_date]    DATETIME       NULL
);


GO
CREATE CLUSTERED INDEX [CIDX_tblattorney_Case_Assignment]
    ON [dbo].[tblAttorney_Case_Assignment]([DomainId] ASC, [Case_Id] ASC);

