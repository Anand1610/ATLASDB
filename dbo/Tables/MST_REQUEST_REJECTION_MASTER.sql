CREATE TABLE [dbo].[MST_REQUEST_REJECTION_MASTER] (
    [List_Id]     INT            IDENTITY (1, 1) NOT NULL,
    [List_Name]   NVARCHAR (500) NULL,
    [List_Status] NVARCHAR (100) NULL,
    [DomainId]    NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

