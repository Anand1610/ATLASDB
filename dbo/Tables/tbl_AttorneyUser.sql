CREATE TABLE [dbo].[tbl_AttorneyUser] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [Name]           VARCHAR (50)  NOT NULL,
    [Email]          VARCHAR (250) NOT NULL,
    [Role]           VARCHAR (255) NOT NULL,
    [AttorneyFirmId] INT           NOT NULL,
    [UserId]         INT           NOT NULL,
    [Address]        VARCHAR (250) NULL,
    [City]           VARCHAR (50)  NULL,
    [State]          VARCHAR (50)  NULL,
    [Country]        VARCHAR (50)  NULL,
    [Zip]            INT           NOT NULL,
    [Created_Date]   DATE          DEFAULT (getdate()) NOT NULL,
    [DomainId]       NVARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

