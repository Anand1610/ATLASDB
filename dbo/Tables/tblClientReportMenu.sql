CREATE TABLE [dbo].[tblClientReportMenu] (
    [MenuID]   INT           IDENTITY (1, 1) NOT NULL,
    [MenuName] VARCHAR (100) NOT NULL,
    [Link]     VARCHAR (200) NULL,
    [ParentID] INT           NULL,
    CONSTRAINT [PK_tblClientReportMenu] PRIMARY KEY CLUSTERED ([MenuID] ASC)
);

