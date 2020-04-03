CREATE TABLE [dbo].[tbl_Location] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [Location]     VARCHAR (50)  NOT NULL,
    [Address]      VARCHAR (250) NULL,
    [State]        VARCHAR (50)  NULL,
    [City]         VARCHAR (50)  NULL,
    [ZipCode]      VARCHAR (50)  NULL,
    [Created_Date] DATETIME      NULL,
    [DomainId]     VARCHAR (50)  NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

