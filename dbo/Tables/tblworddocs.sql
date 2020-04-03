CREATE TABLE [dbo].[tblworddocs] (
    [ID]       INT            IDENTITY (1, 1) NOT NULL,
    [NAME]     NVARCHAR (50)  NULL,
    [VALUE]    NVARCHAR (50)  NULL,
    [DomainId] NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

