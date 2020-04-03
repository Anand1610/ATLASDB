CREATE TABLE [dbo].[RelationProv_BatchNo] (
    [Auto_id]     INT            IDENTITY (1, 1) NOT NULL,
    [BatchNumber] NVARCHAR (50)  NULL,
    [ProviderId]  NVARCHAR (50)  NULL,
    [DomainId]    NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

