CREATE TABLE [dbo].[MST_DenialReasons] (
    [PK_Denial_ID]     INT            IDENTITY (1, 1) NOT NULL,
    [DenialReason]     NVARCHAR (200) NULL,
    [DomainId]         NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    [created_by_user]  NVARCHAR (255) DEFAULT ('admin') NOT NULL,
    [created_date]     DATETIME       NULL,
    [modified_by_user] NVARCHAR (255) NULL,
    [modified_date]    DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([PK_Denial_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Xi_domainid]
    ON [dbo].[MST_DenialReasons]([DomainId] ASC);

