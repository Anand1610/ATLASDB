CREATE TABLE [dbo].[tbl_Portfolio] (
    [Id]                  INT           IDENTITY (1, 1) NOT NULL,
    [Name]                VARCHAR (50)  NOT NULL,
    [Description]         VARCHAR (250) NULL,
    [Reserved_Percentage] INT           NULL,
    [Created_Date]        DATE          DEFAULT (getdate()) NOT NULL,
    [ProgramId]           INT           NULL,
    [DomainId]            NVARCHAR (50) NOT NULL,
    [Portfolio_Type]      INT           DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Xi_domainid]
    ON [dbo].[tbl_Portfolio]([DomainId] ASC);

