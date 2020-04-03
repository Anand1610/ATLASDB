CREATE TABLE [dbo].[RFA_JL_PROVIDERID_MAPPING] (
    [ID]                INT          IDENTITY (1, 1) NOT NULL,
    [RFA_PROVIDER_ID]   INT          NOT NULL,
    [ATLAS_PROVIDER_ID] INT          NOT NULL,
    [DomainId]          VARCHAR (20) NOT NULL
);

