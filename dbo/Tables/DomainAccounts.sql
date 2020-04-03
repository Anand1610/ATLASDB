CREATE TABLE [dbo].[DomainAccounts] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [DomainId]      VARCHAR (100) NULL,
    [LawFirmName]   VARCHAR (100) NULL,
    [CompanyType]   VARCHAR (100) NULL,
    [LawFirmId]     VARCHAR (100) NULL,
    [AccountDomain] VARCHAR (100) NULL,
    [EmailSendTo]   VARCHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

