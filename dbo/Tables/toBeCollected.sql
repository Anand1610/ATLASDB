CREATE TABLE [dbo].[toBeCollected] (
    [Case_Id]     VARCHAR (50)   NULL,
    [Principal]   VARCHAR (200)  NULL,
    [Interest]    VARCHAR (200)  NULL,
    [FilingFee]   VARCHAR (200)  NULL,
    [AttorneyFee] VARCHAR (200)  NULL,
    [DomainId]    NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

