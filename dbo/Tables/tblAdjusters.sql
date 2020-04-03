CREATE TABLE [dbo].[tblAdjusters] (
    [Adjuster_Id]         INT            IDENTITY (1, 1) NOT NULL,
    [Adjuster_LastName]   NVARCHAR (100) NULL,
    [Adjuster_FirstName]  NVARCHAR (100) NULL,
    [InsuranceCompany_Id] NVARCHAR (50)  NULL,
    [Adjuster_Phone]      NVARCHAR (50)  NULL,
    [Adjuster_Fax]        NVARCHAR (50)  NULL,
    [Adjuster_Email]      NVARCHAR (50)  NULL,
    [Adjuster_Extension]  NVARCHAR (50)  NULL,
    [Adjuster_Address]    NVARCHAR (250) NULL,
    [DomainId]            NVARCHAR (512) CONSTRAINT [DF__tblAdjust__Domai__22401542] DEFAULT ('h1') NOT NULL,
    [created_by_user]     NVARCHAR (255) CONSTRAINT [DF__tblAdjust__creat__62A57E71] DEFAULT ('admin') NOT NULL,
    [created_date]        DATETIME       NULL,
    [modified_by_user]    NVARCHAR (255) NULL,
    [modified_date]       DATETIME       NULL,
    [adjuster_id_old]     INT            NULL,
    CONSTRAINT [PK_tblAdjusters] PRIMARY KEY CLUSTERED ([Adjuster_Id] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [Xi_domainid]
    ON [dbo].[tblAdjusters]([DomainId] ASC);

