CREATE TABLE [dbo].[tbl_State] (
    [Id]        TINYINT       IDENTITY (1, 1) NOT NULL,
    [StateCode] NVARCHAR (2)  NOT NULL,
    [StateText] NVARCHAR (50) NOT NULL,
    [CountryId] TINYINT       NOT NULL,
    [DomainId]  NVARCHAR (50) NOT NULL
);

