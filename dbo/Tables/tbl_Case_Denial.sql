CREATE TABLE [dbo].[tbl_Case_Denial] (
    [PK_ID]        INT            IDENTITY (1, 1) NOT NULL,
    [FK_Denial_ID] INT            NULL,
    [Case_Id]      NVARCHAR (50)  NULL,
    [DomainId]     NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_tbl_Case_Denial] PRIMARY KEY CLUSTERED ([PK_ID] ASC),
    CONSTRAINT [FK_tbl_Case_Denial_MST_DenialReasons] FOREIGN KEY ([FK_Denial_ID]) REFERENCES [dbo].[MST_DenialReasons] ([PK_Denial_ID])
);

