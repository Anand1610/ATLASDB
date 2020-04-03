CREATE TABLE [dbo].[TXN_PROVIDER_LOGIN] (
    [Auto_Id]     INT            IDENTITY (1, 1) NOT NULL,
    [Provider_id] NVARCHAR (50)  NULL,
    [user_id]     INT            NULL,
    [DomainId]    NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

