CREATE TABLE [dbo].[tbl_TypeOfPractice] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [Name]         VARCHAR (50)  NOT NULL,
    [Description]  VARCHAR (250) NULL,
    [Created_Date] DATETIME      NULL,
    [DomainId]     VARCHAR (50)  NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

