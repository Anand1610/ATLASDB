CREATE TABLE [dbo].[tblMenu_Domain_Access] (
    [MenuAccessId] INT          IDENTITY (1, 1) NOT NULL,
    [MenuId]       INT          NOT NULL,
    [DomainId]     VARCHAR (50) NOT NULL,
    CONSTRAINT [IX_Menu_Domain_Access] UNIQUE NONCLUSTERED ([DomainId] ASC, [MenuId] ASC)
);

