CREATE TABLE [dbo].[tblUserDesk] (
    [UserName] NVARCHAR (50)  NULL,
    [Desk_Id]  INT            NULL,
    [DomainId] NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

