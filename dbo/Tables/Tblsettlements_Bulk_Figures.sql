CREATE TABLE [dbo].[Tblsettlements_Bulk_Figures] (
    [GROUP_CODE]  VARCHAR (50)   NOT NULL,
    [PROVIDER_ID] INT            NOT NULL,
    [SETT_RATE]   DECIMAL (4, 4) NOT NULL,
    [AF_RATE]     DECIMAL (4, 4) NOT NULL,
    [AF_MIN]      MONEY          NOT NULL,
    [AF_MAX]      MONEY          NOT NULL,
    [FF_BASE]     MONEY          NOT NULL,
    [DomainId]    NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

