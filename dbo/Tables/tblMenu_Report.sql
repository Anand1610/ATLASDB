CREATE TABLE [dbo].[tblMenu_Report] (
    [ReportMenuID] INT            IDENTITY (1, 1) NOT NULL,
    [MenuName]     VARCHAR (100)  NOT NULL,
    [MenuLink]     VARCHAR (1000) NULL,
    [Description]  VARCHAR (255)  NULL,
    [ParentID]     INT            NULL,
    [DomainId]     NVARCHAR (50)  NULL,
    CONSTRAINT [PK_tblReportMenu] PRIMARY KEY CLUSTERED ([ReportMenuID] ASC)
);

