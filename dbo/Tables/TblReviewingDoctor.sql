CREATE TABLE [dbo].[TblReviewingDoctor] (
    [Doctor_id]        INT            IDENTITY (1, 1) NOT NULL,
    [Doctor_Name]      VARCHAR (100)  NOT NULL,
    [Active]           BIT            CONSTRAINT [DF_TblReviewingDoctor_Active] DEFAULT ((1)) NOT NULL,
    [DomainId]         NVARCHAR (50)  DEFAULT ('h1') NULL,
    [created_by_user]  NVARCHAR (255) DEFAULT ('admin') NOT NULL,
    [created_date]     DATETIME       NULL,
    [modified_by_user] NVARCHAR (255) NULL,
    [modified_date]    DATETIME       NULL,
    CONSTRAINT [PK_TblReviewingDoctor] PRIMARY KEY CLUSTERED ([Doctor_id] ASC)
);

