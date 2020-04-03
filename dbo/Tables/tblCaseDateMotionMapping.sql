CREATE TABLE [dbo].[tblCaseDateMotionMapping] (
    [Id]                   INT            IDENTITY (1, 1) NOT NULL,
    [CaseDateDetailsID]    INT            NULL,
    [DomainId]             NVARCHAR (100) NULL,
    [MotionTypeId]         INT            NULL,
    [MotionHearingDate]    DATETIME       NULL,
    [Motion_for_PL_or_DEF] BIT            NULL,
    [CreatedBy]            NVARCHAR (100) NULL,
    [CreatedDate]          DATETIME       NULL,
    [UpdatedBy]            NVARCHAR (100) NULL,
    [UpdatedDate]          DATETIME       NULL,
    CONSTRAINT [PK_tblCaseDateMotionMapping] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_tblCaseDateMotionMapping_tblCase_Date_Details] FOREIGN KEY ([CaseDateDetailsID]) REFERENCES [dbo].[tblCase_Date_Details] ([Auto_Id]),
    CONSTRAINT [FK_tblCaseDateMotionMapping_tblMotionType] FOREIGN KEY ([MotionTypeId]) REFERENCES [dbo].[tblMotionType] ([MotionTypeId])
);

