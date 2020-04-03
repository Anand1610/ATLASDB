CREATE TABLE [dbo].[tbl_City] (
    [Id]       TINYINT       IDENTITY (1, 1) NOT NULL,
    [CityCode] NVARCHAR (2)  NOT NULL,
    [CityText] NVARCHAR (50) NOT NULL,
    [StateId]  TINYINT       NOT NULL,
    [DomainId] NVARCHAR (50) NOT NULL
);

