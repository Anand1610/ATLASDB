CREATE TABLE [dbo].[tblMenu_Access] (
    [MenuAccessId] INT          IDENTITY (1, 1) NOT NULL,
    [RoleId]       INT          NOT NULL,
    [MenuId]       INT          NOT NULL,
    [DomainId]     VARCHAR (50) NOT NULL,
    CONSTRAINT [IX_Role_Menu] UNIQUE NONCLUSTERED ([DomainId] ASC, [RoleId] ASC, [MenuId] ASC)
);


GO
CREATE CLUSTERED INDEX [Xi_domainid]
    ON [dbo].[tblMenu_Access]([DomainId] ASC);

