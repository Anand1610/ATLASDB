CREATE TABLE [dbo].[tblAction] (
    [Action_id]        INT            IDENTITY (1, 1) NOT NULL,
    [DenialReasons_Id] INT            NULL,
    [Action_type]      NVARCHAR (50)  NULL,
    [DomainId]         NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_tblAction] PRIMARY KEY CLUSTERED ([Action_id] ASC),
    CONSTRAINT [AddDenialReason] FOREIGN KEY ([DenialReasons_Id]) REFERENCES [dbo].[tblDenialReasons] ([DenialReasons_Id]) ON DELETE CASCADE
);

