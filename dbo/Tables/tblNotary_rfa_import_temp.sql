CREATE TABLE [dbo].[tblNotary_rfa_import_temp] (
    [NotaryPublicID]   INT           NOT NULL,
    [NPFirstName]      NVARCHAR (50) NULL,
    [NPMiddle]         NVARCHAR (50) NULL,
    [NPLastName]       NVARCHAR (50) NULL,
    [NPCounty]         NVARCHAR (50) NULL,
    [NPRegistrationNo] NVARCHAR (50) NULL,
    [NPExpDate]        DATETIME      NULL,
    [NPPriority]       TINYINT       NOT NULL
);

