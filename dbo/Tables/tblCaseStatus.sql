CREATE TABLE [dbo].[tblCaseStatus] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [name]             NVARCHAR (100) NOT NULL,
    [description]      NVARCHAR (200) NULL,
    [DomainId]         NVARCHAR (50)  CONSTRAINT [DF__tblCaseSt__Domai__318258D2] DEFAULT ('h1') NOT NULL,
    [created_by_user]  NVARCHAR (255) CONSTRAINT [DF__tblCaseSt__creat__494FC0C2] DEFAULT ('admin') NOT NULL,
    [created_date]     DATETIME       CONSTRAINT [DF_tblCaseStatus_created_date] DEFAULT (getdate()) NULL,
    [modified_by_user] NVARCHAR (255) NULL,
    [modified_date]    DATETIME       NULL,
    CONSTRAINT [PK_tblCaseStatus] PRIMARY KEY NONCLUSTERED ([DomainId] ASC, [name] ASC)
);


GO
CREATE UNIQUE CLUSTERED INDEX [CIDX_DomainId_CaseId]
    ON [dbo].[tblCaseStatus]([DomainId] ASC, [name] ASC);

