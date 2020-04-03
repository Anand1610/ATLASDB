CREATE TABLE [dbo].[tblCPT] (
    [CPT_Id]   INT            IDENTITY (1, 1) NOT NULL,
    [CPT_Code] NVARCHAR (50)  NOT NULL,
    [CPT_Name] NVARCHAR (300) NULL,
    [Amount]   MONEY          NULL,
    [DomainId] NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_tblCPT] PRIMARY KEY CLUSTERED ([CPT_Id] ASC)
);

