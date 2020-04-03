CREATE TABLE [dbo].[RelationUser_BatchNo] (
    [AutoId]      INT            IDENTITY (1, 1) NOT NULL,
    [BatchNumber] NVARCHAR (50)  NULL,
    [UserId]      NVARCHAR (50)  NULL,
    [DomainId]    NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

