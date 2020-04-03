CREATE TABLE [dbo].[tblMenu_Report_Access] (
    [MenuAccessId] INT          IDENTITY (1, 1) NOT NULL,
    [RoleId]       INT          NOT NULL,
    [ReportMenuId] INT          NOT NULL,
    [DomainId]     VARCHAR (50) NOT NULL,
    CONSTRAINT [IX_Report_Role_Menu] UNIQUE NONCLUSTERED ([DomainId] ASC, [RoleId] ASC, [ReportMenuId] ASC)
);

