CREATE TABLE [dbo].[tblDesk] (
    [Desk_Id]   INT            IDENTITY (1, 1) NOT NULL,
    [Desk_Name] VARCHAR (200)  NULL,
    [DomainId]  NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_tblDesk] PRIMARY KEY CLUSTERED ([Desk_Id] ASC) WITH (FILLFACTOR = 90)
);

