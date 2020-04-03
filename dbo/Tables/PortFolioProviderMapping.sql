CREATE TABLE [dbo].[PortFolioProviderMapping] (
    [ID]            INT           IDENTITY (1, 1) NOT NULL,
    [Provider_Name] VARCHAR (200) NULL,
    [PortFolio_Id]  INT           NULL,
    [Domainid]      VARCHAR (40)  NULL,
    [Active]        INT           NULL
);


GO
CREATE CLUSTERED INDEX [idx_PortFProviderMap]
    ON [dbo].[PortFolioProviderMapping]([ID] ASC);

