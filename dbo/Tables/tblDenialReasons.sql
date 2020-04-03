CREATE TABLE [dbo].[tblDenialReasons] (
    [DenialReasons_Id]     INT            IDENTITY (1, 1) NOT NULL,
    [DenialReasons_Type]   VARCHAR (80)   NULL,
    [Denial_Colorcode]     NVARCHAR (100) NULL,
    [I_CATEGORY_ID]        INT            NULL,
    [DomainId]             NVARCHAR (50)  CONSTRAINT [tblDenialReasons_DomainId] DEFAULT ('h1') NULL,
    [created_by_user]      NVARCHAR (255) DEFAULT ('admin') NOT NULL,
    [created_date]         DATETIME       NULL,
    [modified_by_user]     NVARCHAR (255) NULL,
    [modified_date]        DATETIME       NULL,
    [DenialReasons_Id_Old] INT            NULL,
    [IsMain]               BIT            NULL,
    CONSTRAINT [PK_tblDenialReasons] PRIMARY KEY CLUSTERED ([DenialReasons_Id] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [Xi_domainid]
    ON [dbo].[tblDenialReasons]([DomainId] ASC);

