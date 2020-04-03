CREATE TABLE [dbo].[tblStatusHierarchyAccessAtlas] (
    [auto_id]      INT           IDENTITY (1, 1) NOT NULL,
    [username]     VARCHAR (200) NULL,
    [userid]       INT           NULL,
    [created_date] DATETIME      DEFAULT (getdate()) NULL,
    [Domainid]     VARCHAR (50)  NULL
);

