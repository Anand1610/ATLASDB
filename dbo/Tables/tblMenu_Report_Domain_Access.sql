CREATE TABLE [dbo].[tblMenu_Report_Domain_Access] (
    [MenuAccessId] INT          IDENTITY (1, 1) NOT NULL,
    [ReportMenuId] INT          NOT NULL,
    [DomainId]     VARCHAR (50) NOT NULL,
    CONSTRAINT [IX_Report_Role_Domain_Menu] UNIQUE NONCLUSTERED ([DomainId] ASC, [ReportMenuId] ASC)
);

