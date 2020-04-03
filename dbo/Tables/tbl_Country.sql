CREATE TABLE [dbo].[tbl_Country] (
    [Id]          TINYINT       IDENTITY (1, 1) NOT NULL,
    [CountryCode] NVARCHAR (2)  NOT NULL,
    [CountryText] NVARCHAR (50) NOT NULL,
    [DomainId]    NVARCHAR (50) NOT NULL
);

