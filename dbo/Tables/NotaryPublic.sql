CREATE TABLE [dbo].[NotaryPublic] (
    [NotaryPublicID]   INT            IDENTITY (1, 1) NOT NULL,
    [NPFirstName]      NVARCHAR (50)  NULL,
    [NPMiddle]         NVARCHAR (50)  NULL,
    [NPLastName]       NVARCHAR (50)  NULL,
    [NPCounty]         NVARCHAR (50)  NULL,
    [NPRegistrationNo] NVARCHAR (50)  NULL,
    [NPExpDate]        DATETIME       NULL,
    [NPPriority]       TINYINT        CONSTRAINT [DF_NotaryPublic_NPPriority] DEFAULT ((0)) NOT NULL,
    [DomainId]         NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

