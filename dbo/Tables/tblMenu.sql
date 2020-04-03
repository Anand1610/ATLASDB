CREATE TABLE [dbo].[tblMenu] (
    [MenuID]      INT            NOT NULL,
    [MenuName]    VARCHAR (100)  NOT NULL,
    [MenuLink]    VARCHAR (1000) NULL,
    [Description] VARCHAR (255)  NULL,
    [ParentID]    INT            NULL,
    CONSTRAINT [PK_Menu] PRIMARY KEY CLUSTERED ([MenuID] ASC)
);

